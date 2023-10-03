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

#define CORE_POLY_WR0CS0    0x00000001
#define CORE_POLY_WR0CS1    0x00000003
#define CORE_POLY_WR0CS2    0x00000007
#define CORE_POLY_WRITE1    0x00000008
#define CORE_POLY_WRITE2    0x00000010
#define CORE_POLY_READ      0x00000020
#define CORE_POLY_WRDN      0x00000040

/*
 * Elements of R_q = Z_q[X]/(X^n + 1). Represents polynomial
 * coeffs[0] + X*coeffs[1] + X^2*xoeffs[2] + ... + X^{n-1}*coeffs[n-1]
 */
typedef struct{
  int16_t coeffs[KYBER_N];
} poly;

typedef struct{
    poly vec[KYBER_K];
} polyvec;

void pdma_init(void);

void write_coeffs_0(poly *p, int c);

void write_coeffs_1(poly *p);

void write_coeffs_2(poly *p);

void read_coeffs_2(poly *p);

void write_polyvec(polyvec *p);

void read_polyvec(polyvec *p);

#endif /* SRC_PLATFORM_DRIVERS_FPGA_IP_COREPOLY_CORE_POLY_H_ */
