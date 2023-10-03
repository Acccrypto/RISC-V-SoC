/*
 * polyvec.c
 *
 *  Created on: 2023年1月8日
 *      Author: wangt
 */

#include <hart1/polyvec.h>
#include "sign.h"

extern int sign_end;

void polyvec_matrix_expand(polyvecl mat[K], const uint8_t rho[SEEDBYTES]) {
  unsigned int i, j;

  for(i = 0; i < K; ++i)
    for(j = 0; j < L; ++j)
      poly_uniform(&mat[i].vec[j], rho, (i << 8) + j);
}

void polyvecl_uniform_eta(polyvecl *v, const uint8_t seed[SEEDBYTES], uint16_t nonce) {
  unsigned int i;

  for(i = 0; i < L; ++i)
    poly_uniform_eta(&v->vec[i], seed, nonce++);
}

void polyveck_uniform_eta(polyveck *v, const uint8_t seed[SEEDBYTES], uint16_t nonce) {
  unsigned int i;

  for(i = 0; i < K; ++i)
    poly_uniform_eta(&v->vec[i], seed, nonce++);
}

void polyveck_power2round(polyveck *v1, polyveck *v0, const polyveck *v) {
  unsigned int i;

  for(i = 0; i < K; ++i)
    poly_power2round(&v1->vec[i], &v0->vec[i], &v->vec[i]);
}

void polyvecl_uniform_gamma1(polyvecl *v, const uint8_t seed[SEEDBYTES], uint16_t nonce) {
  unsigned int i;

  for(i = 0; i < L; ++i)
    poly_uniform_gamma1(&v->vec[i], seed, L*nonce + i);
}

void polyveck_decompose(polyveck *v1, polyveck *v0, const polyveck *v) {
  unsigned int i;

  for(i = 0; i < K; ++i)
    poly_decompose(&v1->vec[i], &v0->vec[i], &v->vec[i]);
}

void polyveck_pack_w1(uint8_t r[K*POLYW1_PACKEDBYTES], const polyveck *w1) {
  unsigned int i;

  for(i = 0; i < K; ++i)
    polyw1_pack(&r[i*POLYW1_PACKEDBYTES], &w1->vec[i]);
}

void polyveck_use_hint(polyveck *w, const polyveck *u, const polyveck *h) {
  unsigned int i;

  for(i = 0; i < K; ++i)
    poly_use_hint(&w->vec[i], &u->vec[i], &h->vec[i]);
}

__attribute__((optimize("O0"))) void polyvec_matrix_mult(polyveck *t, polyvecl mat[K], polyvecl *v, int rd) {
    unsigned int i, j;

    for (i = 0; i < L; i++) {
        //mcycle_start = readmcycle();
        write_coeffs_0(&mat[0].vec[i]);
        //mcycle_end = readmcycle();
        //delta_mcycle = mcycle_end - mcycle_start;
        //sprintf(info_string, "test time is %ld clock cycles\r\n", delta_mcycle);
        //MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
        write_coeffs_1(&v->vec[i], 0);
        while (sign_end == 0) {}
        sign_end = 0;

        for (j = 1; j < K; j++) {
            write_coeffs_0_pwm(&mat[j].vec[i]);
            while (sign_end == 0) {}
            sign_end = 0;
        }
    }

    if (rd)
        read_polyveck(t, 0);
}

/**************************************************************/
/************ Vectors of polynomials of length L **************/
/**************************************************************/
__attribute__((optimize("O0"))) void polyvecl_mult(polyvecl *r, poly_instance_t *a, polyvecl *v) {
    unsigned int i;

    write_coeffs_0(&v->vec[0]);
    write_coeffs_1(a, 1);
    while (sign_end == 0) {}
    sign_end = 0;

    for (i = 1; i < L; i++) {
        write_coeffs_0_ntt0(&v->vec[i]);
        while (sign_end == 0) {}
        sign_end = 0;
    }

    read_polyvecl(r);
}

/*************************************************
* Name:        polyvecl_chknorm
*
* Description: Check infinity norm of polynomials in vector of length L.
*              Assumes input polyvecl to be reduced by polyvecl_reduce().
*
* Arguments:   - const polyvecl *v: pointer to vector
*              - int32_t B: norm bound
*
* Returns 0 if norm of all polynomials is strictly smaller than B <= (Q-1)/8
* and 1 otherwise.
**************************************************/
int polyvecl_chknorm(const polyvecl *v, int32_t bound)  {
  unsigned int i;

  for(i = 0; i < L; ++i)
    if(poly_chknorm(&v->vec[i], bound))
      return 1;

  return 0;
}

int polyvecl_chknorm_mod(const polyvecl *v, int32_t bound)  {
  unsigned int i;

  for(i = 0; i < L; ++i)
    if(poly_chknorm_mod(&v->vec[i], bound))
      return 1;

  return 0;
}

/**************************************************************/
/************ Vectors of polynomials of length K **************/
/**************************************************************/
__attribute__((optimize("O0"))) void polyveck_mult(polyveck *r, poly_instance_t *a, polyveck *v) {
    unsigned int i;

    write_coeffs_0(&v->vec[0]);
    write_coeffs_1(a, 1);
    while (sign_end == 0) {}
    sign_end = 0;

    for (i = 1; i < K; i++) {
        write_coeffs_0_ntt0(&v->vec[i]);
        while (sign_end == 0) {}
        sign_end = 0;
    }

    read_polyveck(r, 0);
}

__attribute__((optimize("O0"))) void polyveck_mult_cp(polyveck *r, polyveck *v) {
    unsigned int i;

    for (i = 0; i < K; i++) {
        write_coeffs_0_ntt0(&v->vec[i]);
        while (sign_end == 0) {}
        sign_end = 0;
    }

    read_polyveck(r, 0);
}

// r = v * cp, w = w + v * cp
__attribute__((optimize("O0"))) void polyveck_multadd_cp(polyveck *r, polyveck *w, polyveck *v) {
    unsigned int i;

    for (i = 0; i < K; i++) {
        write_coeffs_0_ntt0(&v->vec[i]);
        while (sign_end == 0) {}
        sign_end = 0;
    }

    read_polyveck(r, 1);

    for(i = 0; i < K; ++i) {
        write_coeffs_0_madd(&w->vec[i]);
        while (sign_end == 0) {}
        sign_end = 0;
    }

    read_polyveck(w, 0);
}

/*************************************************
* Name:        polyveck_chknorm
*
* Description: Check infinity norm of polynomials in vector of length K.
*              Assumes input polyveck to be reduced by polyveck_reduce().
*
* Arguments:   - const polyveck *v: pointer to vector
*              - int32_t B: norm bound
*
* Returns 0 if norm of all polynomials are strictly smaller than B <= (Q-1)/8
* and 1 otherwise.
**************************************************/
int polyveck_chknorm_mod(const polyveck *v, int32_t bound)  {
  unsigned int i;

  for(i = 0; i < K; ++i)
    if(poly_chknorm_mod(&v->vec[i], bound))
      return 1;

  return 0;
}

/*************************************************
* Name:        polyveck_make_hint
*
* Description: Compute hint vector.
*
* Arguments:   - polyveck *h: pointer to output vector
*              - const polyveck *v0: pointer to low part of input vector
*              - const polyveck *v1: pointer to high part of input vector
*
* Returns number of 1 bits.
**************************************************/
unsigned int polyveck_make_hint(polyveck *h,
                                const polyveck *v0,
                                const polyveck *v1)
{
  unsigned int i, s = 0;

  for(i = 0; i < K; ++i)
    s += poly_make_hint(&h->vec[i], &v0->vec[i], &v1->vec[i]);

  return s;
}
