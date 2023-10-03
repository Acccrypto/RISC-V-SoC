/*
 * sign.c
 *
 *  Created on: 2023年1月8日
 *      Author: wangt
 */

#include <hart1/fips202.h>
#include <hart1/sign.h>
#include <hart1/symmetric.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "mpfs_hal/mss_hal.h"
#include "inc/common.h"
#include <stdlib.h>

uint8_t info_string[100];
extern HART_SHARED_DATA * hart_share;
extern uint64_t mcycle_start, mcycle_end, delta_mcycle;

__attribute__((optimize("O0"))) void waitforhart()
{
    while ((hart_share->core2_end==0) || (hart_share->core3_end==0) || (hart_share->core4_end==0)) { }
}

void randombytes(uint8_t *rd, int len)
{
    int tmp;
    for (int i = 0; i < len/2; i++) {
        tmp = rand();
        rd[i] = (uint8_t)tmp;
        rd[i++] = (uint8_t)(tmp >> 8);
    }
}

/*************************************************
* Name:        crypto_sign_keypair
*
* Description: Generates public and private key.
*
* Arguments:   - uint8_t *pk: pointer to output public key (allocated
*                             array of CRYPTO_PUBLICKEYBYTES bytes)
*              - uint8_t *sk: pointer to output private key (allocated
*                             array of CRYPTO_SECRETKEYBYTES bytes)
*
* Returns 0 (success)
**************************************************/
int crypto_sign_keypair(uint8_t *pk, uint8_t *sk) {
    uint64_t hartid = read_csr(mhartid);
    volatile uint32_t icount = 0U;
    HLS_DATA* hls = (HLS_DATA*)(uintptr_t)get_tp_reg();
    hart_share = (HART_SHARED_DATA *)hls->shared_mem;

  _Alignas(8) uint8_t seedbuf[SEEDBYTES] = { 0x7c, 0x99, 0x35, 0xa0, 0xb0, 0x76, 0x94, 0xaa,
          0x0c, 0x6d, 0x10, 0xe4, 0xdb, 0x6b, 0x1a, 0xdd, 0x2f, 0xd8, 0x1a, 0x25,
          0xcc, 0xb1, 0x48, 0x03, 0x2d, 0xcd, 0x73, 0x99, 0x36, 0x73, 0x7f, 0x2d };
  _Alignas(8) uint8_t tr[CRHBYTES];

  /* Get randomness for rho, rhoprime and key */
  randombytes(seedbuf, SEEDBYTES);

  shake256(pk, 3*SEEDBYTES, seedbuf, SEEDBYTES);
  hart_share->rho = pk;
  hart_share->rhoprime = pk + SEEDBYTES;
  memcpy(sk, pk, SEEDBYTES);
  sk += SEEDBYTES;
  memcpy(sk, pk + 2*SEEDBYTES, SEEDBYTES);
  sk += SEEDBYTES;

  /* Expand matrix and Sample short vectors s1 and s2 */
  hart_share->core2_end = 0;
  hart_share->core3_end = 0;
  hart_share->core4_end = 0;
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  raise_soft_interrupt(4u);
#if DILITHIUM_MODE == 2
  poly_uniform_eta(&hart_share->s2.vec[0], hart_share->rhoprime, L);
  poly_uniform_eta(&hart_share->s1.vec[0], hart_share->rhoprime, 0);
  poly_uniform(&hart_share->mat[0].vec[0], hart_share->rho, 0);
  poly_uniform(&hart_share->mat[0].vec[1], hart_share->rho, 1);
  poly_uniform(&hart_share->mat[0].vec[2], hart_share->rho, 2);
  poly_uniform(&hart_share->mat[0].vec[3], hart_share->rho, 3);
#elif DILITHIUM_MODE == 3
  poly_uniform_eta(&hart_share->s2.vec[0], hart_share->rhoprime, L);
  poly_uniform_eta(&hart_share->s2.vec[4], hart_share->rhoprime, L+4);
  poly_uniform_eta(&hart_share->s1.vec[0], hart_share->rhoprime, 0);
  poly_uniform(&hart_share->mat[0].vec[0], hart_share->rho, 0);
  poly_uniform(&hart_share->mat[0].vec[1], hart_share->rho, 1);
  poly_uniform(&hart_share->mat[0].vec[2], hart_share->rho, 2);
  poly_uniform(&hart_share->mat[0].vec[3], hart_share->rho, 3);
  poly_uniform(&hart_share->mat[0].vec[4], hart_share->rho, 4);
  poly_uniform(&hart_share->mat[4].vec[0], hart_share->rho, 1024);
  poly_uniform(&hart_share->mat[4].vec[1], hart_share->rho, 1025);
#elif DILITHIUM_MODE == 5
  poly_uniform_eta(&hart_share->s2.vec[0], hart_share->rhoprime, L);
  poly_uniform_eta(&hart_share->s2.vec[1], hart_share->rhoprime, L+1);
  poly_uniform_eta(&hart_share->s1.vec[0], hart_share->rhoprime, 0);
  poly_uniform_eta(&hart_share->s1.vec[1], hart_share->rhoprime, 1);
  poly_uniform(&hart_share->mat[0].vec[0], hart_share->rho, 0);
  poly_uniform(&hart_share->mat[0].vec[1], hart_share->rho, 1);
  poly_uniform(&hart_share->mat[0].vec[2], hart_share->rho, 2);
  poly_uniform(&hart_share->mat[0].vec[3], hart_share->rho, 3);
  poly_uniform(&hart_share->mat[0].vec[4], hart_share->rho, 4);
  poly_uniform(&hart_share->mat[0].vec[5], hart_share->rho, 5);
  poly_uniform(&hart_share->mat[0].vec[6], hart_share->rho, 6);
  poly_uniform(&hart_share->mat[1].vec[0], hart_share->rho, 256);
  poly_uniform(&hart_share->mat[1].vec[1], hart_share->rho, 257);
  poly_uniform(&hart_share->mat[1].vec[2], hart_share->rho, 258);
  poly_uniform(&hart_share->mat[1].vec[3], hart_share->rho, 259);
  poly_uniform(&hart_share->mat[1].vec[4], hart_share->rho, 260);
  poly_uniform(&hart_share->mat[1].vec[5], hart_share->rho, 261);
  poly_uniform(&hart_share->mat[1].vec[6], hart_share->rho, 262);
#endif

  waitforhart();

  /* Matrix-vector multiplication */

  // t = A * s1 + s2
  //mcycle_start = readmcycle();
  write_polyveck(&hart_share->s2);
  polyvec_matrix_mult(&hart_share->t1, hart_share->mat, &hart_share->s1, 1);
  //mcycle_end = readmcycle();
  //delta_mcycle = mcycle_end - mcycle_start;

#if 0
  for (int i = 0; i < 256; i++) {
    sprintf(info_string, "t1[%d] = %d\r\n", i, hart_share->t1.vec[1].coeffs[i]);
    spinlock(&hart_share->mutex_uart0);
    MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
    spinunlock(&hart_share->mutex_uart0);
  }
#endif

  /* Extract t1 and write public key */
  hart_share->core2_end = 0;
  hart_share->core3_end = 0;
  hart_share->core4_end = 0;
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  raise_soft_interrupt(4u);
#if DILITHIUM_MODE == 2
  poly_power2round(&hart_share->t1.vec[0], &hart_share->t0.vec[0], &hart_share->t1.vec[0]);
  polyt1_pack(pk + SEEDBYTES, &hart_share->t1.vec[0]);
#elif DILITHIUM_MODE == 3
  poly_power2round(&hart_share->t1.vec[0], &hart_share->t0.vec[0], &hart_share->t1.vec[0]);
  polyt1_pack(pk + SEEDBYTES, &hart_share->t1.vec[0]);
#elif DILITHIUM_MODE == 5
  poly_power2round(&hart_share->t1.vec[0], &hart_share->t0.vec[0], &hart_share->t1.vec[0]);
  polyt1_pack(pk + SEEDBYTES, &hart_share->t1.vec[0]);
  poly_power2round(&hart_share->t1.vec[1], &hart_share->t0.vec[1], &hart_share->t1.vec[1]);
  polyt1_pack(hart_share->pk + SEEDBYTES + POLYT1_PACKEDBYTES, &hart_share->t1.vec[1]);
#endif

  waitforhart();

  /* Compute CRH(rho, t1) and write secret key */
  crh(tr, pk, CRYPTO_PUBLICKEYBYTES);

#if 0
  for (int i = 0; i < 48; i++) {
      if ((i+1) % 8 == 0)
          sprintf(info_string, "%02x\r\n", tr[i]);
      else
          sprintf(info_string, "%02x", tr[i]);
      MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
  }
#endif

  /* pack_sk */
  memcpy(sk, tr, CRHBYTES);
  sk += CRHBYTES;

  hart_share->core2_end = 0;
  hart_share->core3_end = 0;
  hart_share->core4_end = 0;
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  raise_soft_interrupt(4u);
#if DILITHIUM_MODE == 2
  polyeta_pack(sk, &hart_share->s1.vec[0]);
  sk += L*POLYETA_PACKEDBYTES;
  polyeta_pack(sk, &hart_share->s2.vec[0]);
  sk += K*POLYETA_PACKEDBYTES;
  polyt0_pack(sk, &hart_share->t0.vec[0]);
#elif DILITHIUM_MODE == 3
  polyeta_pack(sk, &hart_share->s1.vec[0]);
  polyeta_pack(sk + 4*POLYETA_PACKEDBYTES, &hart_share->s1.vec[4]);
  sk += L*POLYETA_PACKEDBYTES;
  polyeta_pack(sk, &hart_share->s2.vec[0]);
  sk += K*POLYETA_PACKEDBYTES;
  polyt0_pack(sk, &hart_share->t0.vec[0]);
#elif DILITHIUM_MODE == 5
  polyeta_pack(sk, &hart_share->s1.vec[0]);
  polyeta_pack(sk + POLYETA_PACKEDBYTES, &hart_share->s1.vec[1]);
  sk += L*POLYETA_PACKEDBYTES;
  polyeta_pack(sk, &hart_share->s2.vec[0]);
  polyeta_pack(sk + POLYETA_PACKEDBYTES, &hart_share->s2.vec[1]);
  sk += K*POLYETA_PACKEDBYTES;
  polyt0_pack(sk, &hart_share->t0.vec[0]);
  polyt0_pack(sk + POLYT0_PACKEDBYTES, &hart_share->t0.vec[1]);
#endif

  waitforhart();

#if 0
  for (int i = 0; i < CRYPTO_SECRETKEYBYTES; i++) {
      if ((i+1) % 8 == 0)
          sprintf(info_string, "%02x\r\n", hart_share->sk[i]);
      else
          sprintf(info_string, "%02x", hart_share->sk[i]);
      MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
  }
#endif


  return 0;
}

/*************************************************
* Name:        crypto_sign_signature
*
* Description: Computes signature.
*
* Arguments:   - uint8_t *sig:   pointer to output signature (of length CRYPTO_BYTES)
*              - size_t *siglen: pointer to output length of signature
*              - uint8_t *m:     pointer to message to be signed
*              - size_t mlen:    length of message
*              - uint8_t *sk:    pointer to bit-packed secret key
*
* Returns 0 (success)
**************************************************/
int crypto_sign_signature(uint8_t *sig,
                          size_t *siglen,
                          const uint8_t *m,
                          size_t mlen,
                          const uint8_t *sk)
{
  //mcycle_start = readmcycle();
  unsigned int n;
  _Alignas(8) uint8_t key[SEEDBYTES + CRHBYTES];
  _Alignas(8) uint8_t *tr;
  uint8_t *mu;
  poly_instance_t cp;

  tr = (uint8_t *)calloc(CRHBYTES + mlen, sizeof(uint8_t));
  mu = key + SEEDBYTES;
  hart_share->rho = (uint8_t *)calloc(SEEDBYTES, sizeof(uint8_t));
  hart_share->rhoprime = (uint8_t *)calloc(CRHBYTES, sizeof(uint8_t));
  hart_share->nonce = 0;

  /* unpack_sk */
  memcpy(hart_share->rho, sk, SEEDBYTES);
  sk += SEEDBYTES;
  memcpy(key, sk, SEEDBYTES);
  sk += SEEDBYTES;
  memcpy(tr, sk, CRHBYTES);
  sk += CRHBYTES;

  hart_share->core2_end = 0;
  hart_share->core3_end = 0;
  hart_share->core4_end = 0;
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  raise_soft_interrupt(4u);
#if DILITHIUM_MODE == 2
  polyeta_unpack(&hart_share->s1.vec[0], sk);
  sk += L*POLYETA_PACKEDBYTES;
  polyeta_unpack_neg(&hart_share->s2.vec[0], sk);
  sk += K*POLYETA_PACKEDBYTES;
  polyt0_unpack(&hart_share->t0.vec[0], sk);
#elif DILITHIUM_MODE == 3
  polyeta_unpack(&hart_share->s1.vec[0], sk);
  polyeta_unpack(&hart_share->s1.vec[4], sk + 4*POLYETA_PACKEDBYTES);
  sk += L*POLYETA_PACKEDBYTES;
  polyeta_unpack_neg(&hart_share->s2.vec[0], sk);
  sk += K*POLYETA_PACKEDBYTES;
  polyt0_unpack(&hart_share->t0.vec[0], sk);
#elif DILITHIUM_MODE == 5
  polyeta_unpack(&hart_share->s1.vec[0], sk);
  polyeta_unpack(&hart_share->s1.vec[1], sk + POLYETA_PACKEDBYTES);
  sk += L*POLYETA_PACKEDBYTES;
  polyeta_unpack_neg(&hart_share->s2.vec[0], sk);
  polyeta_unpack_neg(&hart_share->s2.vec[1], sk + POLYETA_PACKEDBYTES);
  sk += K*POLYETA_PACKEDBYTES;

  /*for (int i = 0; i < POLYT0_PACKEDBYTES; i++) {
      if ((i+1) % 8 == 0)
          sprintf(info_string, "%02x\r\n", sk[i]);
      else
          sprintf(info_string, "%02x", sk[i]);
      MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
  }
  sprintf(info_string, "\r\n");
  MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));*/

  polyt0_unpack(&hart_share->t0.vec[0], sk);
  polyt0_unpack(&hart_share->t0.vec[1], sk + POLYT0_PACKEDBYTES);
#endif

  waitforhart();

  /* Compute CRH(tr, msg) */
  memcpy(tr+CRHBYTES, m, mlen);
  shake256(mu, CRHBYTES, tr, CRHBYTES+mlen);

#if 0
  for (int i = 0; i < CRHBYTES; i++) {
      if ((i+1) % 8 == 0)
          sprintf(info_string, "%02x\r\n", mu[i]);
      else
          sprintf(info_string, "%02x", mu[i]);
      MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
  }
  sprintf(info_string, "\r\n");
  MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
#endif

#ifdef DILITHIUM_RANDOMIZED_SIGNING
  randombytes(rhoprime, CRHBYTES);
#else
  crh(hart_share->rhoprime, key, SEEDBYTES + CRHBYTES);
#endif

  /* Expand matrix */
  hart_share->core2_end = 0;
  hart_share->core3_end = 0;
  hart_share->core4_end = 0;
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  raise_soft_interrupt(4u);
#if DILITHIUM_MODE == 2
  poly_uniform(&hart_share->mat[0].vec[0], hart_share->rho, 0);
  poly_uniform(&hart_share->mat[0].vec[1], hart_share->rho, 1);
  poly_uniform(&hart_share->mat[0].vec[2], hart_share->rho, 2);
  poly_uniform(&hart_share->mat[0].vec[3], hart_share->rho, 3);
#elif DILITHIUM_MODE == 3
  poly_uniform(&hart_share->mat[0].vec[0], hart_share->rho, 0);
  poly_uniform(&hart_share->mat[0].vec[1], hart_share->rho, 1);
  poly_uniform(&hart_share->mat[0].vec[2], hart_share->rho, 2);
  poly_uniform(&hart_share->mat[0].vec[3], hart_share->rho, 3);
  poly_uniform(&hart_share->mat[0].vec[4], hart_share->rho, 4);
  poly_uniform(&hart_share->mat[4].vec[0], hart_share->rho, 1024);
  poly_uniform(&hart_share->mat[4].vec[1], hart_share->rho, 1025);
  poly_uniform(&hart_share->mat[4].vec[2], hart_share->rho, 1026);
#elif DILITHIUM_MODE == 5
  poly_uniform(&hart_share->mat[0].vec[0], hart_share->rho, 0);
  poly_uniform(&hart_share->mat[0].vec[1], hart_share->rho, 1);
  poly_uniform(&hart_share->mat[0].vec[2], hart_share->rho, 2);
  poly_uniform(&hart_share->mat[0].vec[3], hart_share->rho, 3);
  poly_uniform(&hart_share->mat[0].vec[4], hart_share->rho, 4);
  poly_uniform(&hart_share->mat[0].vec[5], hart_share->rho, 5);
  poly_uniform(&hart_share->mat[0].vec[6], hart_share->rho, 6);
  poly_uniform(&hart_share->mat[1].vec[0], hart_share->rho, 256);
  poly_uniform(&hart_share->mat[1].vec[1], hart_share->rho, 257);
  poly_uniform(&hart_share->mat[1].vec[2], hart_share->rho, 258);
  poly_uniform(&hart_share->mat[1].vec[3], hart_share->rho, 259);
  poly_uniform(&hart_share->mat[1].vec[4], hart_share->rho, 260);
  poly_uniform(&hart_share->mat[1].vec[5], hart_share->rho, 261);
  poly_uniform(&hart_share->mat[1].vec[6], hart_share->rho, 262);
#endif

  waitforhart();

  //mcycle_end = readmcycle();
  //delta_mcycle = mcycle_end - mcycle_start;

rej:
  //delta_mcycle = 0;
  //mcycle_start = readmcycle();
  /* Sample intermediate vector y */
  hart_share->core2_end = 0;
  hart_share->core3_end = 0;
  hart_share->core4_end = 0;
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  raise_soft_interrupt(4u);
#if DILITHIUM_MODE == 2
  poly_uniform_gamma1(&hart_share->y.vec[0], hart_share->rhoprime, L*hart_share->nonce);
#elif DILITHIUM_MODE == 3
  poly_uniform_gamma1(&hart_share->y.vec[0], hart_share->rhoprime, L*hart_share->nonce);
  poly_uniform_gamma1(&hart_share->y.vec[4], hart_share->rhoprime, L*hart_share->nonce + 4);
#elif DILITHIUM_MODE == 5
  poly_uniform_gamma1(&hart_share->y.vec[0], hart_share->rhoprime, L*hart_share->nonce);
  poly_uniform_gamma1(&hart_share->y.vec[1], hart_share->rhoprime, L*hart_share->nonce + 1);
#endif

  waitforhart();

  hart_share->nonce += 1;
  hart_share->reject = 0;

  /* Matrix-vector multiplication */
  // w = A * y
  //mcycle_start = readmcycle();
  polyvec_matrix_mult(&hart_share->w1, hart_share->mat, &hart_share->y, 1);
  //mcycle_end = readmcycle();
  //delta_mcycle += mcycle_end - mcycle_start;

  /* Decompose w and call the random oracle */
  hart_share->core2_end = 0;
  hart_share->core3_end = 0;
  hart_share->core4_end = 0;
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  raise_soft_interrupt(4u);
#if DILITHIUM_MODE == 2
  poly_decompose(&hart_share->w1.vec[0], &hart_share->w0.vec[0], &hart_share->w1.vec[0]);
  polyw1_pack(&hart_share->sm[CRHBYTES], &hart_share->w1.vec[0]);
#elif DILITHIUM_MODE == 3
  poly_decompose(&hart_share->w1.vec[0], &hart_share->w0.vec[0], &hart_share->w1.vec[0]);
  polyw1_pack(&hart_share->sm[CRHBYTES], &hart_share->w1.vec[0]);
#elif DILITHIUM_MODE == 5
  poly_decompose(&hart_share->w1.vec[0], &hart_share->w0.vec[0], &hart_share->w1.vec[0]);
  polyw1_pack(&hart_share->sm[CRHBYTES], &hart_share->w1.vec[0]);
  poly_decompose(&hart_share->w1.vec[1], &hart_share->w0.vec[1], &hart_share->w1.vec[1]);
  polyw1_pack(&hart_share->sm[POLYW1_PACKEDBYTES+CRHBYTES], &hart_share->w1.vec[1]);
#endif

  waitforhart();

  memcpy(hart_share->sm, mu, CRHBYTES);
  shake256(hart_share->sm, SEEDBYTES, hart_share->sm, CRHBYTES+K*POLYW1_PACKEDBYTES);
  poly_challenge(&cp, hart_share->sm);

  /* Compute z, reject if it reveals secret */
  // z = y + c * s1
  //mcycle_start = readmcycle();
  write_polyvecl(&hart_share->y);
  polyvecl_mult(&hart_share->z, &cp, &hart_share->s1);
  //mcycle_end = readmcycle();
  //delta_mcycle += mcycle_end - mcycle_start;

  hart_share->reject = polyvecl_chknorm_mod(&hart_share->z, GAMMA1 - BETA);
  if(hart_share->reject)
    goto rej;

  /* Check that subtracting cs2 does not change high bits of w and low bits
   * do not reveal secret information */
  // w0 = w0 - c * s2
  //mcycle_start = readmcycle();
  write_polyveck(&hart_share->w0);
  /*mcycle_end = readmcycle();
  delta_mcycle = mcycle_end - mcycle_start;
  sprintf(info_string, "test time is %ld clock cycles\r\n", delta_mcycle);
  MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));*/

  polyveck_mult_cp(&hart_share->w0, &hart_share->s2);

  hart_share->reject = polyveck_chknorm_mod(&hart_share->w0, GAMMA2 - BETA);
  if(hart_share->reject)
      goto rej;

  /* Compute hints for w1 */
  // h = c * t0, w0 = w0 + c * t0
  //mcycle_start = readmcycle();
  polyveck_multadd_cp(&hart_share->h, &hart_share->w0, &hart_share->t0);
  //mcycle_end = readmcycle();
  //delta_mcycle += mcycle_end - mcycle_start;

  hart_share->reject = polyveck_chknorm_mod(&hart_share->h, GAMMA2);
  if(hart_share->reject)
      goto rej;

  n = polyveck_make_hint(&hart_share->h, &hart_share->w0, &hart_share->w1);
  hart_share->reject = (n > OMEGA)? 1 : 0;
  if(hart_share->reject)
    goto rej;

  /* Write signature */
  hart_share->core2_end = 0;
  hart_share->core3_end = 0;
  hart_share->core4_end = 0;
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  raise_soft_interrupt(4u);
#if DILITHIUM_MODE == 2
  polyz_pack_mod(&hart_share->sm[SEEDBYTES], &hart_share->z.vec[0]);
#elif DILITHIUM_MODE == 3
  polyz_pack_mod(&hart_share->sm[SEEDBYTES], &hart_share->z.vec[0]);
#elif DILITHIUM_MODE == 5
  polyz_pack_mod(&hart_share->sm[SEEDBYTES], &hart_share->z.vec[0]);
  polyz_pack_mod(&hart_share->sm[SEEDBYTES] + POLYZ_PACKEDBYTES, &hart_share->z.vec[1]);
#endif

  waitforhart();

  int sig_offset = SEEDBYTES + L*POLYZ_PACKEDBYTES;
  unsigned int i, j, k;
  for(i = 0; i < OMEGA + K; ++i)
      hart_share->sm[sig_offset+i] = 0;
  k = 0;
  for(i = 0; i < K; ++i) {
    for(j = 0; j < N; ++j)
      if(hart_share->h.vec[i].coeffs[j] != 0) {
          hart_share->sm[sig_offset + k] = j;
          k++;
      }

    hart_share->sm[sig_offset + OMEGA + i] = k;
  }
  *siglen = CRYPTO_BYTES;

  free(tr);
  free(hart_share->rhoprime);
  free(hart_share->rho);

  //mcycle_end = readmcycle();
  //delta_mcycle = mcycle_end - mcycle_start;

#if 0
  for (int i = 0; i < CRYPTO_BYTES; i++) {
      if ((i+1) % 8 == 0)
          sprintf(info_string, "%02x\r\n", hart_share->sm[i]);
      else
          sprintf(info_string, "%02x", hart_share->sm[i]);
      MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
  }
  sprintf(info_string, "\r\n");
  MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
#endif

  return 0;
}

/*************************************************
* Name:        crypto_sign
*
* Description: Compute signed message.
*
* Arguments:   - uint8_t *sm: pointer to output signed message (allocated
*                             array with CRYPTO_BYTES + mlen bytes),
*                             can be equal to m
*              - size_t *smlen: pointer to output length of signed
*                               message
*              - const uint8_t *m: pointer to message to be signed
*              - size_t mlen: length of message
*              - const uint8_t *sk: pointer to bit-packed secret key
*
* Returns 0 (success)
**************************************************/
int crypto_sign(uint8_t *sm,
                size_t *smlen,
                const uint8_t *m,
                size_t mlen,
                const uint8_t *sk)
{
  size_t i;

  for(i = 0; i < mlen; ++i)
    sm[CRYPTO_BYTES + mlen - 1 - i] = m[mlen - 1 - i];
  crypto_sign_signature(sm, smlen, m, mlen, sk);
  *smlen += mlen;
  return 0;
}

/*************************************************
* Name:        crypto_sign_verify
*
* Description: Verifies signature.
*
* Arguments:   - uint8_t *m: pointer to input signature
*              - size_t siglen: length of signature
*              - const uint8_t *m: pointer to message
*              - size_t mlen: length of message
*              - const uint8_t *pk: pointer to bit-packed public key
*
* Returns 0 if signature could be verified correctly and -1 otherwise
**************************************************/
int crypto_sign_verify(const uint8_t *sig,
                       size_t siglen,
                       const uint8_t *m,
                       size_t mlen,
                       const uint8_t *pk)
{
  _Alignas(8) uint8_t *mu;
  _Alignas(8) uint8_t *c;
  _Alignas(8) uint8_t c2[SEEDBYTES];
  poly_instance_t cp;

  if(siglen != CRYPTO_BYTES)
    return -1;

  mu = (uint8_t *)calloc(CRHBYTES + mlen, sizeof(uint8_t));

  /* unpack pk and sig */
  hart_share->rho = hart_share->pk;
  c = hart_share->sm;

  hart_share->core2_end = 0;
  hart_share->core3_end = 0;
  hart_share->core4_end = 0;
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  raise_soft_interrupt(4u);
#if DILITHIUM_MODE == 2
  polyt1_unpack_neg(&hart_share->t1.vec[0], &hart_share->pk[SEEDBYTES]);
  poly_shiftl(&hart_share->t1.vec[0]);
  polyz_unpack(&hart_share->z.vec[0], hart_share->sm + SEEDBYTES);
#elif DILITHIUM_MODE == 3
  polyt1_unpack_neg(&hart_share->t1.vec[0], &hart_share->pk[SEEDBYTES]);
  poly_shiftl(&hart_share->t1.vec[0]);
  polyz_unpack(&hart_share->z.vec[0], hart_share->sm + SEEDBYTES);
#elif DILITHIUM_MODE == 5
  polyt1_unpack_neg(&hart_share->t1.vec[0], &hart_share->pk[SEEDBYTES]);
  poly_shiftl(&hart_share->t1.vec[0]);
  polyt1_unpack_neg(&hart_share->t1.vec[1], &hart_share->pk[SEEDBYTES] + POLYT1_PACKEDBYTES);
  poly_shiftl(&hart_share->t1.vec[1]);
  polyz_unpack(&hart_share->z.vec[0], hart_share->sm + SEEDBYTES);
  polyz_unpack(&hart_share->z.vec[1], hart_share->sm + SEEDBYTES + POLYZ_PACKEDBYTES);
#endif

  waitforhart();

  /* Decode h */
  sig += (SEEDBYTES + L*POLYZ_PACKEDBYTES);

  unsigned int i, j, k;
  k = 0;
  for(i = 0; i < K; ++i) {
    for(j = 0; j < N; ++j)
        hart_share->h.vec[i].coeffs[j] = 0;

    if(sig[OMEGA + i] < k || sig[OMEGA + i] > OMEGA)
      return -1;

    for(j = k; j < sig[OMEGA + i]; ++j) {
      /* Coefficients are ordered for strong unforgeability */
      if(j > k && sig[j] <= sig[j-1]) return -1;
      hart_share->h.vec[i].coeffs[sig[j]] = 1;
    }

    k = sig[OMEGA + i];
  }

  /* Extra indices are zero for strong unforgeability */
  for(j = k; j < OMEGA; ++j)
    if(sig[j]) {
        return -1;
    }


  if(polyvecl_chknorm(&hart_share->z, GAMMA1 - BETA))
    return -1;

  hart_share->pw1_buf = (uint8_t *)calloc(CRHBYTES+K*POLYW1_PACKEDBYTES, sizeof(uint8_t));

  /* Compute CRH(CRH(rho, t1), msg) */
  crh(mu, hart_share->rho, CRYPTO_PUBLICKEYBYTES);
  memcpy(mu+CRHBYTES, m, mlen);
  shake256(mu, CRHBYTES, mu, CRHBYTES+mlen);

  /* Expand matrix */
  hart_share->core2_end = 0;
  hart_share->core3_end = 0;
  hart_share->core4_end = 0;
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  raise_soft_interrupt(4u);
#if DILITHIUM_MODE == 2
  poly_uniform(&hart_share->mat[0].vec[0], hart_share->rho, 0);
  poly_uniform(&hart_share->mat[0].vec[1], hart_share->rho, 1);
  poly_uniform(&hart_share->mat[0].vec[2], hart_share->rho, 2);
  poly_uniform(&hart_share->mat[0].vec[3], hart_share->rho, 3);
#elif DILITHIUM_MODE == 3
  poly_uniform(&hart_share->mat[0].vec[0], hart_share->rho, 0);
  poly_uniform(&hart_share->mat[0].vec[1], hart_share->rho, 1);
  poly_uniform(&hart_share->mat[0].vec[2], hart_share->rho, 2);
  poly_uniform(&hart_share->mat[0].vec[3], hart_share->rho, 3);
  poly_uniform(&hart_share->mat[0].vec[4], hart_share->rho, 4);
  poly_uniform(&hart_share->mat[4].vec[0], hart_share->rho, 1024);
  poly_uniform(&hart_share->mat[4].vec[1], hart_share->rho, 1025);
#elif DILITHIUM_MODE == 5
  poly_uniform(&hart_share->mat[0].vec[0], hart_share->rho, 0);
  poly_uniform(&hart_share->mat[0].vec[1], hart_share->rho, 1);
  poly_uniform(&hart_share->mat[0].vec[2], hart_share->rho, 2);
  poly_uniform(&hart_share->mat[0].vec[3], hart_share->rho, 3);
  poly_uniform(&hart_share->mat[0].vec[4], hart_share->rho, 4);
  poly_uniform(&hart_share->mat[0].vec[5], hart_share->rho, 5);
  poly_uniform(&hart_share->mat[0].vec[6], hart_share->rho, 6);
  poly_uniform(&hart_share->mat[1].vec[0], hart_share->rho, 256);
  poly_uniform(&hart_share->mat[1].vec[1], hart_share->rho, 257);
  poly_uniform(&hart_share->mat[1].vec[2], hart_share->rho, 258);
  poly_uniform(&hart_share->mat[1].vec[3], hart_share->rho, 259);
  poly_uniform(&hart_share->mat[1].vec[4], hart_share->rho, 260);
  poly_uniform(&hart_share->mat[1].vec[5], hart_share->rho, 261);
  poly_uniform(&hart_share->mat[1].vec[6], hart_share->rho, 262);
#endif

  waitforhart();

  /* Matrix-vector multiplication */
  //mcycle_start = readmcycle();
  polyvec_matrix_mult(&hart_share->w1, hart_share->mat, &hart_share->z, 0);
  //mcycle_end = readmcycle();
  //delta_mcycle = mcycle_end - mcycle_start;

  /* compute Az - c*2^d*t1 */

  poly_challenge(&cp, c);

#if 0
  for (int i = 0; i < 256; i++) {
    sprintf(info_string, "cp[%d] = %d\r\n", i, cp.coeffs[i]);
    MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
  }
  sprintf(info_string, "\r\n");
  MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
#endif

  //mcycle_start = readmcycle();
  polyveck_mult(&hart_share->w1, &cp, &hart_share->t1);
  //mcycle_end = readmcycle();
  //delta_mcycle += mcycle_end - mcycle_start;

  /* Reconstruct w1 */
  hart_share->core2_end = 0;
  hart_share->core3_end = 0;
  hart_share->core4_end = 0;
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  raise_soft_interrupt(4u);
#if DILITHIUM_MODE == 2
  poly_use_hint(&hart_share->w1.vec[0], &hart_share->w1.vec[0], &hart_share->h.vec[0]);
  polyw1_pack(hart_share->pw1_buf + CRHBYTES, hart_share->w1.vec);
#elif DILITHIUM_MODE == 3
  poly_use_hint(&hart_share->w1.vec[0], &hart_share->w1.vec[0], &hart_share->h.vec[0]);
  polyw1_pack(hart_share->pw1_buf + CRHBYTES, hart_share->w1.vec);
#elif DILITHIUM_MODE == 5
  poly_use_hint(&hart_share->w1.vec[0], &hart_share->w1.vec[0], &hart_share->h.vec[0]);
  polyw1_pack(hart_share->pw1_buf + CRHBYTES, hart_share->w1.vec);
  poly_use_hint(&hart_share->w1.vec[1], &hart_share->w1.vec[1], &hart_share->h.vec[1]);
  polyw1_pack(&hart_share->pw1_buf[POLYW1_PACKEDBYTES + CRHBYTES], &hart_share->w1.vec[1]);
#endif

  waitforhart();

  /* Call random oracle and verify challenge */
  memcpy(hart_share->pw1_buf, mu, CRHBYTES);
  shake256(c2, SEEDBYTES, hart_share->pw1_buf, CRHBYTES+K*POLYW1_PACKEDBYTES);

  free(hart_share->pw1_buf);
  free(mu);

  for(int i = 0; i < SEEDBYTES; ++i)
    if(c[i] != c2[i])
      return -1;

  return 0;
}

/*************************************************
* Name:        crypto_sign_open
*
* Description: Verify signed message.
*
* Arguments:   - uint8_t *m: pointer to output message (allocated
*                            array with smlen bytes), can be equal to sm
*              - size_t *mlen: pointer to output length of message
*              - const uint8_t *sm: pointer to signed message
*              - size_t smlen: length of signed message
*              - const uint8_t *pk: pointer to bit-packed public key
*
* Returns 0 if signed message could be verified correctly and -1 otherwise
**************************************************/
int crypto_sign_open(uint8_t *m,
                     size_t *mlen,
                     const uint8_t *sm,
                     size_t smlen,
                     const uint8_t *pk)
{
  size_t i;

  if(smlen < CRYPTO_BYTES)
    goto badsig;

  *mlen = smlen - CRYPTO_BYTES;
  for(i = 0; i < *mlen; ++i)
      m[i] = sm[CRYPTO_BYTES + i];

  if(crypto_sign_verify(sm, CRYPTO_BYTES, m, *mlen, pk))
      goto badsig;
  else {
      return 0;
  }

badsig:
  /* Signature verification failed */
  *mlen = -1;
  for(i = 0; i < smlen; ++i)
    m[i] = 0;

  return -1;
}

