/*
 * masked_utils.h
 *
 *  Created on: 2023年12月13日
 *      Author: wangt
 */

#ifndef MASKED_UTILS_H_
#define MASKED_UTILS_H_

#include "params.h"
#include "drivers/fpga_ip/CorePoly/core_poly.h"

#define NSHARES 2

typedef struct {
    polyvec share[NSHARES];
} polyvec_mask;

typedef struct {
    poly share[NSHARES];
} poly_mask;

void masked_poly(poly_mask* mp, const poly* p);
void masked_polyvec(polyvec_mask* mpv, const polyvec* pv);
void unmasked_poly(poly* p, const poly_mask* mp);
void unmasked_polyvec(polyvec* pv, const polyvec_mask* mpv);

#endif /* SRC_APPLICATION_HART1_MASKED_UTILS_H_ */
