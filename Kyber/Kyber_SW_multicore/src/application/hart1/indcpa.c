/*
 * indcpa.c
 *
 *  Created on: 2023年1月11日
 *      Author: wangt
 */

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "indcpa.h"
#include "inc/common.h"
#include "mpfs_hal/mss_hal.h"

extern HART_SHARED_DATA * hart_share;
uint8_t info_string[100];

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
* Name:        indcpa_keypair
*
* Description: Generates public and private key for the CPA-secure
*              public-key encryption scheme underlying Kyber
*
* Arguments:   - uint8_t *pk: pointer to output public key
*                             (of length KYBER_INDCPA_PUBLICKEYBYTES bytes)
*              - uint8_t *sk: pointer to output private key
                              (of length KYBER_INDCPA_SECRETKEYBYTES bytes)
**************************************************/
void indcpa_keypair(uint8_t pk[KYBER_INDCPA_PUBLICKEYBYTES],
                    uint8_t sk[KYBER_INDCPA_SECRETKEYBYTES])
{
  unsigned int i, j;
  uint8_t buf[2*KYBER_SYMBYTES] = { 0x7c, 0x99, 0x35, 0xa0, 0xb0, 0x76, 0x94, 0xaa,
          0x0c, 0x6d, 0x10, 0xe4, 0xdb, 0x6b, 0x1a, 0xdd, 0x2f, 0xd8, 0x1a, 0x25,
          0xcc, 0xb1, 0x48, 0x03, 0x2d, 0xcd, 0x73, 0x99, 0x36, 0x73, 0x7f, 0x2d };

  hart_share->publicseed = buf;
  hart_share->noiseseed = buf+KYBER_SYMBYTES;

  randombytes(buf, KYBER_SYMBYTES);
  hash_g(buf, buf, KYBER_SYMBYTES);

  /* Expand matrix and Sample short vectors s and e */
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  raise_soft_interrupt(4u);
#if KYBER_K == 2
  poly_uniform(&hart_share->a[0].vec[0], hart_share->publicseed, 0, 0);
  poly_getnoise_eta1(&hart_share->skpv.vec[0], hart_share->noiseseed, 0);
#elif KYBER_K == 3
  poly_getnoise_eta1(&hart_share->skpv.vec[0], hart_share->noiseseed, 0);
  poly_getnoise_eta1(&hart_share->skpv.vec[1], hart_share->noiseseed, 1);
  poly_getnoise_eta1(&hart_share->skpv.vec[2], hart_share->noiseseed, 2);
  poly_getnoise_eta1(&hart_share->e.vec[0], hart_share->noiseseed, 3);
  poly_getnoise_eta1(&hart_share->e.vec[1], hart_share->noiseseed, 4);
  poly_getnoise_eta1(&hart_share->e.vec[2], hart_share->noiseseed, 5);
#elif KYBER_K == 4
  poly_getnoise_eta1(&hart_share->skpv.vec[0], hart_share->noiseseed, 0);
  poly_getnoise_eta1(&hart_share->skpv.vec[1], hart_share->noiseseed, 1);
  poly_getnoise_eta1(&hart_share->skpv.vec[2], hart_share->noiseseed, 2);
  poly_getnoise_eta1(&hart_share->skpv.vec[3], hart_share->noiseseed, 3);
  poly_getnoise_eta1(&hart_share->e.vec[0], hart_share->noiseseed, 4);
  poly_getnoise_eta1(&hart_share->e.vec[1], hart_share->noiseseed, 5);
  poly_getnoise_eta1(&hart_share->e.vec[2], hart_share->noiseseed, 6);
  poly_getnoise_eta1(&hart_share->e.vec[3], hart_share->noiseseed, 7);
  poly_uniform(&hart_share->a[0].vec[0], hart_share->publicseed, 0, 0);
#endif

  polyvec_hw_ntt(&hart_share->skpv, 1);
  polyvec_hw_ntt(&hart_share->e, 0);

  // matrix-vector multiplication
  polyvec_matrix_mult(&hart_share->pkpv, hart_share->a, &hart_share->skpv);

  /* pack_sk, pack_pk */
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  raise_soft_interrupt(4u);
  memcpy(pk+KYBER_POLYVECBYTES, hart_share->publicseed, KYBER_SYMBYTES*sizeof(uint8_t));
#if KYBER_K == 2
  poly_tobytes(sk, &hart_share->skpv.vec[0]);
#elif KYBER_K == 3
  poly_tobytes(sk, &hart_share->skpv.vec[0]);
  poly_tobytes(sk+KYBER_POLYBYTES, &hart_share->skpv.vec[1]);
#elif KYBER_K == 4
  poly_tobytes(sk, &hart_share->skpv.vec[0]);
  poly_tobytes(sk+KYBER_POLYBYTES, &hart_share->skpv.vec[1]);
#endif
}

/*************************************************
* Name:        indcpa_enc
*
* Description: Encryption function of the CPA-secure
*              public-key encryption scheme underlying Kyber.
*
* Arguments:   - uint8_t *c:           pointer to output ciphertext
*                                      (of length KYBER_INDCPA_BYTES bytes)
*              - const uint8_t *m:     pointer to input message
*                                      (of length KYBER_INDCPA_MSGBYTES bytes)
*              - const uint8_t *pk:    pointer to input public key
*                                      (of length KYBER_INDCPA_PUBLICKEYBYTES)
*              - const uint8_t *coins: pointer to input random coins
*                                      used as seed (of length KYBER_SYMBYTES)
*                                      to deterministically generate all
*                                      randomness
**************************************************/
void indcpa_enc(uint8_t c[KYBER_INDCPA_BYTES],
                const uint8_t m[KYBER_INDCPA_MSGBYTES],
                const uint8_t pk[KYBER_INDCPA_PUBLICKEYBYTES],
                const uint8_t coins[KYBER_SYMBYTES])
{
  unsigned int i, j;
  poly v, k, epp;

  /* Unpack_pk, Expand matrix and Sample k, sp, ep, epp */
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  raise_soft_interrupt(4u);
#if KYBER_K == 2
  poly_uniform(&hart_share->a[1].vec[0], hart_share->pk+KYBER_POLYVECBYTES, 1, 0);
  poly_uniform(&hart_share->a[1].vec[1], hart_share->pk+KYBER_POLYVECBYTES, 1, 1);
  poly_getnoise_eta2(&epp, hart_share->coins, 4);
#elif KYBER_K == 3
  poly_getnoise_eta1(&hart_share->sp.vec[0], hart_share->coins, 0);
  poly_getnoise_eta1(&hart_share->sp.vec[1], hart_share->coins, 1);
  poly_getnoise_eta1(&hart_share->sp.vec[2], hart_share->coins, 2);
  poly_uniform(&hart_share->a[0].vec[0], hart_share->pk+KYBER_POLYVECBYTES, 0, 0);
  poly_uniform(&hart_share->a[1].vec[2], hart_share->pk+KYBER_POLYVECBYTES, 1, 2);
  poly_getnoise_eta2(&epp, hart_share->coins, 6);
#elif KYBER_K == 4
  poly_getnoise_eta1(&hart_share->sp.vec[0], hart_share->coins, 0);
  poly_getnoise_eta1(&hart_share->sp.vec[1], hart_share->coins, 1);
  poly_getnoise_eta1(&hart_share->sp.vec[2], hart_share->coins, 2);
  poly_uniform(&hart_share->a[0].vec[0], hart_share->pk+KYBER_POLYVECBYTES, 0, 0);
  poly_uniform(&hart_share->a[0].vec[1], hart_share->pk+KYBER_POLYVECBYTES, 0, 1);
  poly_uniform(&hart_share->a[0].vec[2], hart_share->pk+KYBER_POLYVECBYTES, 0, 2);
  poly_uniform(&hart_share->a[0].vec[3], hart_share->pk+KYBER_POLYVECBYTES, 0, 3);
  poly_getnoise_eta2(&epp, hart_share->coins, 8);
#endif

  polyvec_hw_ntt(&hart_share->sp, 1);

  poly_frommsg_addepp(&k, m, &epp);

  // matrix-vector multiplication add
  polyvec_matrix_multadd(&hart_share->bp, hart_share->a, &hart_share->sp, &hart_share->e);

  polyvec_multadd(&v, &hart_share->pkpv, &hart_share->sp, &k);

  /* pack_ciphertext */
#if KYBER_K == 2
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  poly_compress(c+KYBER_POLYVECCOMPRESSEDBYTES, &v);
#elif KYBER_K == 3
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  raise_soft_interrupt(4u);
  poly_compress(c+KYBER_POLYVECCOMPRESSEDBYTES, &v);
#elif KYBER_K == 4
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  raise_soft_interrupt(4u);
  poly_compress(c+KYBER_POLYVECCOMPRESSEDBYTES, &v);
  polyveci_compress(c+3*352, &hart_share->bp, 3);
#endif
}

/*************************************************
* Name:        indcpa_dec
*
* Description: Decryption function of the CPA-secure
*              public-key encryption scheme underlying Kyber.
*
* Arguments:   - uint8_t *m:        pointer to output decrypted message
*                                   (of length KYBER_INDCPA_MSGBYTES)
*              - const uint8_t *c:  pointer to input ciphertext
*                                   (of length KYBER_INDCPA_BYTES)
*              - const uint8_t *sk: pointer to input secret key
*                                   (of length KYBER_INDCPA_SECRETKEYBYTES)
**************************************************/
void indcpa_dec(uint8_t m[KYBER_INDCPA_MSGBYTES],
                const uint8_t c[KYBER_INDCPA_BYTES],
                const uint8_t sk[KYBER_INDCPA_SECRETKEYBYTES])
{
  poly mp;

  /* unpack_ciphertext, unpack_sk */
#if KYBER_K == 2
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  raise_soft_interrupt(4u);
  polyveci_decompress(&hart_share->bp, c, 0);
  polyveci_decompress(&hart_share->bp, c+320, 1);
#elif KYBER_K == 3
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  raise_soft_interrupt(4u);
  polyveci_decompress(&hart_share->bp, c, 0);
  polyveci_decompress(&hart_share->bp, c+320, 1);
#elif KYBER_K == 4
  raise_soft_interrupt(2u);
  raise_soft_interrupt(3u);
  raise_soft_interrupt(4u);
  polyveci_decompress(&hart_share->bp, c, 0);
  polyveci_decompress(&hart_share->bp, c+352, 1);
  poly_decompress(&hart_share->k, c+KYBER_POLYVECCOMPRESSEDBYTES);
#endif

  polyvec_hw_ntt(&hart_share->bp, 1);

  polyvec_multadd(&mp, &hart_share->bp, &hart_share->skpv, &hart_share->k);

  /*for (int i = 0; i < KYBER_N; i++) {
      sprintf(info_string, "%d\r\n", mp.coeffs[i]);
      MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
  }*/

  poly_tomsg(m, &mp);
}

