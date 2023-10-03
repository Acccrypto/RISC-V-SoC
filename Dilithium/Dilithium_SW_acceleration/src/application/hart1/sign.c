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
HART_SHARED_DATA * hart_share;
extern uint64_t mcycle_start, mcycle_end, delta_mcycle;

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
#ifdef  MPFS_HAL_SHARED_MEM_ENABLED
    hart_share = (HART_SHARED_DATA *)hls->shared_mem;
#endif

    uint8_t seedbuf[3*SEEDBYTES] = { 0x7c, 0x99, 0x35, 0xa0, 0xb0, 0x76, 0x94, 0xaa,
            0x0c, 0x6d, 0x10, 0xe4, 0xdb, 0x6b, 0x1a, 0xdd, 0x2f, 0xd8, 0x1a, 0x25,
            0xcc, 0xb1, 0x48, 0x03, 0x2d, 0xcd, 0x73, 0x99, 0x36, 0x73, 0x7f, 0x2d };
    uint8_t tr[CRHBYTES];
    const uint8_t *rho, *rhoprime, *key;
    polyvecl mat[K];
    polyvecl s1, s1hat;
    polyveck s2, t1, t0;

    /* Get randomness for rho, rhoprime and key */
    randombytes(seedbuf, SEEDBYTES);
    shake256(seedbuf, 3*SEEDBYTES, seedbuf, SEEDBYTES);
    rho = seedbuf;
    rhoprime = seedbuf + SEEDBYTES;
    key = seedbuf + 2*SEEDBYTES;

    /* Expand matrix */
    polyvec_matrix_expand(mat, rho);

    /* Sample short vectors s1 and s2 */
    polyvecl_uniform_eta(&s1, rhoprime, 0);
    polyveck_uniform_eta(&s2, rhoprime, L);

    /* Matrix-vector multiplication */

    // t = A * s1 + s2
    //mcycle_start = readmcycle();

    write_polyveck(&s2);
    polyvec_matrix_mult(&t1, mat, &s1, 1);

    //mcycle_end = readmcycle();
    //delta_mcycle += (mcycle_end - mcycle_start);

    /* Extract t1 and write public key */
    polyveck_power2round(&t1, &t0, &t1);
    pack_pk(pk, rho, &t1);

    /* Compute CRH(rho, t1) and write secret key */
    crh(tr, pk, CRYPTO_PUBLICKEYBYTES);

    /* pack_sk */
    pack_sk(sk, rho, tr, key, &t0, &s1, &s2);

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
    unsigned int n;
    uint8_t seedbuf[2*SEEDBYTES + 3*CRHBYTES];
    uint8_t *rho, *tr, *key, *mu, *rhoprime;
    uint16_t nonce = 0;
    polyvecl mat[K], s1, y, z;
    polyveck t0, s2, w1, w0, h;
    poly_instance_t cp;
    _Alignas(8) uint8_t *trm;
    _Alignas(8) unsigned char sm[CRHBYTES+K*POLYW1_PACKEDBYTES];

    trm = (uint8_t *)calloc(CRHBYTES + mlen, sizeof(uint8_t));

    rho = seedbuf;
    tr = rho + SEEDBYTES;
    key = tr + CRHBYTES;
    mu = key + SEEDBYTES;
    rhoprime = mu + CRHBYTES;
    unpack_sk(rho, tr, key, &t0, &s1, &s2, sk);

    /* Compute CRH(tr, msg) */
    memcpy(trm, tr, CRHBYTES);
    memcpy(trm+CRHBYTES, m, mlen);
    shake256(mu, CRHBYTES, trm, CRHBYTES+mlen);

#ifdef DILITHIUM_RANDOMIZED_SIGNING
  randombytes(rhoprime, CRHBYTES);
#else
  crh(rhoprime, key, SEEDBYTES + CRHBYTES);
#endif

    /* Expand matrix */
    polyvec_matrix_expand(mat, rho);

rej:
    /* Sample intermediate vector y */
    polyvecl_uniform_gamma1(&y, rhoprime, nonce++);

    /* Matrix-vector multiplication */
    // w = A * y
    //mcycle_start = readmcycle();

    polyvec_matrix_mult(&w1, mat, &y, 1);

    //mcycle_end = readmcycle();
    //delta_mcycle += (mcycle_end - mcycle_start);

    /* Decompose w and call the random oracle */
    polyveck_decompose(&w1, &w0, &w1);
    polyveck_pack_w1(sig, &w1);

    memcpy(sm, mu, CRHBYTES);
    memcpy(sm+CRHBYTES, sig, K*POLYW1_PACKEDBYTES);
    shake256(sig, SEEDBYTES, sm, CRHBYTES+K*POLYW1_PACKEDBYTES);
    poly_challenge(&cp, sig);

    /* Compute z, reject if it reveals secret */
    // z = y + c * s1
    //mcycle_start = readmcycle();

    write_polyvecl(&y);
    polyvecl_mult(&z, &cp, &s1);

    //mcycle_end = readmcycle();
    //delta_mcycle += (mcycle_end - mcycle_start);

    if(polyvecl_chknorm_mod(&z, GAMMA1 - BETA))
      goto rej;

    /* Check that subtracting cs2 does not change high bits of w and low bits
    * do not reveal secret information */
    // w0 = w0 - c * s2
    //mcycle_start = readmcycle();

    write_polyveck(&w0);
    polyveck_mult_cp(&w0, &s2);

    //mcycle_end = readmcycle();
    //delta_mcycle += (mcycle_end - mcycle_start);

    if(polyveck_chknorm_mod(&w0, GAMMA2 - BETA))
      goto rej;

    /* Compute hints for w1 */
    // h = c * t0, w0 = w0 + c * t0
    //mcycle_start = readmcycle();

    polyveck_multadd_cp(&h, &w0, &t0);

    //mcycle_end = readmcycle();
    //delta_mcycle += (mcycle_end - mcycle_start);

    if(polyveck_chknorm_mod(&h, GAMMA2))
      goto rej;

    n = polyveck_make_hint(&h, &w0, &w1);
    if(n > OMEGA)
    goto rej;

    /* Write signature */
    pack_sig(sig, sig, &z, &h);
    *siglen = CRYPTO_BYTES;

    free(trm);

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
    unsigned int i;
    uint8_t buf[CRHBYTES+K*POLYW1_PACKEDBYTES];
    uint8_t rho[SEEDBYTES];
    uint8_t *mu;
    uint8_t c[SEEDBYTES];
    uint8_t c2[SEEDBYTES];
    poly_instance_t cp;
    polyvecl mat[K], z;
    polyveck t1, w1, h;

    if(siglen != CRYPTO_BYTES)
      return -1;

    mu = (uint8_t *)calloc(CRHBYTES + mlen, sizeof(uint8_t));

    /* unpack pk and sig */
    unpack_pk(rho, &t1, pk);
    if(unpack_sig(c, &z, &h, sig))
      return -1;
    if(polyvecl_chknorm(&z, GAMMA1 - BETA))
      return -1;

    /* Compute CRH(CRH(rho, t1), msg) */
    crh(mu, pk, CRYPTO_PUBLICKEYBYTES);
    memcpy(mu+CRHBYTES, m, mlen);
    shake256(mu, CRHBYTES, mu, CRHBYTES+mlen);

    /* Expand matrix */
    poly_challenge(&cp, c);
    polyvec_matrix_expand(mat, rho);

    //mcycle_start = readmcycle();

    /* Matrix-vector multiplication */
    polyvec_matrix_mult(&w1, mat, &z, 0);

    /* compute Az - c*2^d*t1 */
    polyveck_mult(&w1, &cp, &t1);

    //mcycle_end = readmcycle();
    //delta_mcycle += (mcycle_end - mcycle_start);

    /* Reconstruct w1 */
    polyveck_use_hint(&w1, &w1, &h);
    polyveck_pack_w1(buf+CRHBYTES, &w1);

    /* Call random oracle and verify challenge */
    memcpy(buf, mu, CRHBYTES);
    shake256(c2, SEEDBYTES, buf, CRHBYTES+K*POLYW1_PACKEDBYTES);

    free(mu);

    for(int i = 0; i < SEEDBYTES; ++i)
      if(c[i] != c2[i])
        return -1;

#if 0
  sprintf(info_string, "hardware time is %ld\r\n", delta_mcycle);
  MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
#endif

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

