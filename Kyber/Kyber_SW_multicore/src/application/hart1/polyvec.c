/*
 * polyvec.c
 *
 *  Created on: 2023年1月11日
 *      Author: wangt
 */

#include <stdint.h>
#include "params.h"
#include "poly.h"
#include "polyvec.h"
#include "mpfs_hal/mss_hal.h"
#include <stdio.h>
#include <string.h>
#include "drivers/mss/mss_mmuart/mss_uart.h"

extern int sign_end;
extern uint64_t mcycle_start, mcycle_end;
uint64_t delta_mcycle = 0U;
uint8_t info_string[100];

/*************************************************
* Name:        polyvec_compress
*
* Description: Compress and serialize vector of polynomials
*
* Arguments:   - uint8_t *r: pointer to output byte array
*                            (needs space for KYBER_POLYVECCOMPRESSEDBYTES)
*              - polyvec *a: pointer to input vector of polynomials
**************************************************/
void polyveci_compress(uint8_t *r, polyvec *a, int i)
{
  unsigned int j,k;

#if (KYBER_POLYVECCOMPRESSEDBYTES == (KYBER_K * 352))
  uint16_t t[8];
  for(j=0;j<KYBER_N/8;j++) {
      for(k=0;k<8;k++)
        t[k] = ((((uint32_t)a->vec[i].coeffs[8*j+k] << 11) + KYBER_Q/2)
                /KYBER_Q) & 0x7ff;

      r[ 0] = (t[0] >>  0);
      r[ 1] = (t[0] >>  8) | (t[1] << 3);
      r[ 2] = (t[1] >>  5) | (t[2] << 6);
      r[ 3] = (t[2] >>  2);
      r[ 4] = (t[2] >> 10) | (t[3] << 1);
      r[ 5] = (t[3] >>  7) | (t[4] << 4);
      r[ 6] = (t[4] >>  4) | (t[5] << 7);
      r[ 7] = (t[5] >>  1);
      r[ 8] = (t[5] >>  9) | (t[6] << 2);
      r[ 9] = (t[6] >>  6) | (t[7] << 5);
      r[10] = (t[7] >>  3);
      r += 11;
  }
#elif (KYBER_POLYVECCOMPRESSEDBYTES == (KYBER_K * 320))
  uint16_t t[4];
  for(j=0;j<KYBER_N/4;j++) {
      for(k=0;k<4;k++)
        t[k] = ((((uint32_t)a->vec[i].coeffs[4*j+k] << 10) + KYBER_Q/2)
                / KYBER_Q) & 0x3ff;

      r[0] = (t[0] >> 0);
      r[1] = (t[0] >> 8) | (t[1] << 2);
      r[2] = (t[1] >> 6) | (t[2] << 4);
      r[3] = (t[2] >> 4) | (t[3] << 6);
      r[4] = (t[3] >> 2);
      r += 5;
  }
#else
#error "KYBER_POLYVECCOMPRESSEDBYTES needs to be in {320*KYBER_K, 352*KYBER_K}"
#endif
}

/*************************************************
* Name:        polyvec_decompress
*
* Description: De-serialize and decompress vector of polynomials;
*              approximate inverse of polyvec_compress
*
* Arguments:   - polyvec *r:       pointer to output vector of polynomials
*              - const uint8_t *a: pointer to input byte array
*                                  (of length KYBER_POLYVECCOMPRESSEDBYTES)
**************************************************/
void polyveci_decompress(polyvec *r, const uint8_t *a, int i)
{
  unsigned int j,k;

#if (KYBER_POLYVECCOMPRESSEDBYTES == (KYBER_K * 352))
  uint16_t t[8];
  for(j=0;j<KYBER_N/8;j++) {
      t[0] = (a[0] >> 0) | ((uint16_t)a[ 1] << 8);
      t[1] = (a[1] >> 3) | ((uint16_t)a[ 2] << 5);
      t[2] = (a[2] >> 6) | ((uint16_t)a[ 3] << 2) | ((uint16_t)a[4] << 10);
      t[3] = (a[4] >> 1) | ((uint16_t)a[ 5] << 7);
      t[4] = (a[5] >> 4) | ((uint16_t)a[ 6] << 4);
      t[5] = (a[6] >> 7) | ((uint16_t)a[ 7] << 1) | ((uint16_t)a[8] << 9);
      t[6] = (a[8] >> 2) | ((uint16_t)a[ 9] << 6);
      t[7] = (a[9] >> 5) | ((uint16_t)a[10] << 3);
      a += 11;

      for(k=0;k<8;k++)
        r->vec[i].coeffs[8*j+k] = -(((uint32_t)(t[k] & 0x7FF)*KYBER_Q + 1024) >> 11);
  }
#elif (KYBER_POLYVECCOMPRESSEDBYTES == (KYBER_K * 320))
  uint16_t t[4];
  for(j=0;j<KYBER_N/4;j++) {
      t[0] = (a[0] >> 0) | ((uint16_t)a[1] << 8);
      t[1] = (a[1] >> 2) | ((uint16_t)a[2] << 6);
      t[2] = (a[2] >> 4) | ((uint16_t)a[3] << 4);
      t[3] = (a[3] >> 6) | ((uint16_t)a[4] << 2);
      a += 5;

      for(k=0;k<4;k++)
        r->vec[i].coeffs[4*j+k] = -(((uint32_t)(t[k] & 0x3FF)*KYBER_Q + 512) >> 10);
  }
#else
#error "KYBER_POLYVECCOMPRESSEDBYTES needs to be in {320*KYBER_K, 352*KYBER_K}"
#endif
}

/*************************************************
* Name:        polyvec_tobytes
*
* Description: Serialize vector of polynomials
*
* Arguments:   - uint8_t *r: pointer to output byte array
*                            (needs space for KYBER_POLYVECBYTES)
*              - polyvec *a: pointer to input vector of polynomials
**************************************************/
void polyvec_tobytes(uint8_t r[KYBER_POLYVECBYTES], polyvec *a)
{
  unsigned int i;
  for(i=0;i<KYBER_K;i++)
    poly_tobytes(r+i*KYBER_POLYBYTES, &a->vec[i]);
}

/*************************************************
* Name:        polyvec_frombytes
*
* Description: De-serialize vector of polynomials;
*              inverse of polyvec_tobytes
*
* Arguments:   - uint8_t *r:       pointer to output byte array
*              - const polyvec *a: pointer to input vector of polynomials
*                                  (of length KYBER_POLYVECBYTES)
**************************************************/
void polyvec_frombytes(polyvec *r, const uint8_t a[KYBER_POLYVECBYTES])
{
  unsigned int i;
  for(i=0;i<KYBER_K;i++)
    poly_frombytes(&r->vec[i], a+i*KYBER_POLYBYTES);
}

__attribute__((optimize("O0"))) void polyvec_hw_ntt(polyvec *r, int rd)
{
    for(int i=0;i<KYBER_K;i++) {
        write_coeffs_0(&r->vec[i], 0);
        while (sign_end == 0) {}
        sign_end = 0;
    }

    if (rd)
        read_polyvec(r);
}

__attribute__((optimize("O0"))) void polyvec_matrix_mult(polyvec *r, polyvec a[KYBER_K], polyvec *b)
{
    for(int i = 0; i < KYBER_K; i++) {
        //mcycle_start = readmcycle();
        write_coeffs_1(&b->vec[i]);
        //mcycle_end   = readmcycle();
        //delta_mcycle = mcycle_end - mcycle_start;
        //sprintf(info_string, "the time is %ld clock cycles\r\n", delta_mcycle);
        //MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
        for(int j = 0; j < KYBER_K; j++) {
            write_coeffs_0(&a[j].vec[i], 1);
            while (sign_end == 0) {}
            sign_end = 0;
        }
    }
    read_polyvec(r);
}

__attribute__((optimize("O0"))) void polyvec_matrix_multadd(polyvec *r, polyvec a[KYBER_K], polyvec *b, polyvec *c)
{
    write_polyvec(c);
    for(int i = 0; i < KYBER_K; i++) {
        write_coeffs_1(&b->vec[i]);
        for(int j = 0; j < KYBER_K; j++) {
            write_coeffs_0(&a[j].vec[i], 2);
            while (sign_end == 0) {}
            sign_end = 0;
        }
    }
    read_polyvec(r);
}

__attribute__((optimize("O0"))) void polyvec_multadd(poly *r, polyvec *a, polyvec *b, poly *c)
{
    write_coeffs_2(c);
    for(int i = 0; i < KYBER_K; i++) {
        write_coeffs_1(&b->vec[i]);
        write_coeffs_0(&a->vec[i], 2);
        while (sign_end == 0) {}
        sign_end = 0;
    }
    read_coeffs_2(r);
}

/*************************************************
* Name:        polyvec_csubq
*
* Description: Applies conditional subtraction of q to each coefficient
*              of each element of a vector of polynomials
*              for details of conditional subtraction of q see comments in
*              reduce.c
*
* Arguments:   - poly *r: pointer to input/output polynomial
**************************************************/
void polyvec_csubq(polyvec *r)
{
  unsigned int i;
  for(i=0;i<KYBER_K;i++)
    poly_csubq(&r->vec[i]);
}

/*************************************************
* Name:        polyvec_add
*
* Description: Add vectors of polynomials
*
* Arguments: - polyvec *r:       pointer to output vector of polynomials
*            - const polyvec *a: pointer to first input vector of polynomials
*            - const polyvec *b: pointer to second input vector of polynomials
**************************************************/
void polyvec_add(polyvec *r, const polyvec *a, const polyvec *b)
{
  unsigned int i;
  for(i=0;i<KYBER_K;i++)
    poly_add(&r->vec[i], &a->vec[i], &b->vec[i]);
}

