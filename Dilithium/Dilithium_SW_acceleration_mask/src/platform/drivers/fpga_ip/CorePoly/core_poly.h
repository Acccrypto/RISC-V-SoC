/*
 * core_poly.h
 *
 *  Created on: 2023年3月5日
 *      Author: wangt
 */

#ifndef CORE_POLY_H_
#define CORE_POLY_H_

#include "hal/hal.h"
#include "hart1/params.h"

#define CORE_POLY_BASE      0x60010000
#define CORE_POLY_CONF      0x6001FFFC

#define CORE_POLY_WRITE0    0x00000001
#define CORE_POLY_WR0NT0    0x00000003
#define CORE_POLY_WR0PWM    0x00000005
#define CORE_POLY_WR0ADD    0x00000009
#define CORE_POLY_WRITE1    0x00000010
#define CORE_POLY_WR1NT0    0x00000012
#define CORE_POLY_WRITE2    0x00000020
#define CORE_POLY_READ      0x00000040
#define CORE_POLY_RDHD      0x000000c0
#define CORE_POLY_WRDN      0x00000100

typedef struct __poly_instance_t
{
    int32_t coeffs[N];
} poly_instance_t;

/* Vectors of polynomials of length K */
typedef struct {
    poly_instance_t vec[K];
} polyveck;

/* Vectors of polynomials of length L */
typedef struct {
    poly_instance_t vec[L];
} polyvecl;

void pdma_init(void);

void write_coeffs_0(poly_instance_t *p);

void write_coeffs_0_ntt0(poly_instance_t *p);

void write_coeffs_0_pwm(poly_instance_t *p);

void write_coeffs_0_madd(poly_instance_t *p);

void write_coeffs_1(poly_instance_t *p, int ntt0);

void write_polyveck(polyveck *p);

void write_polyvecl(polyvecl *p);

void read_polyveck(polyveck *p, int holdvec);

void read_polyvecl(polyvecl *p);

#endif /* SRC_PLATFORM_DRIVERS_FPGA_IP_COREPOLY_CORE_POLY_H_ */
