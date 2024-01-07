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
    polyveck share[NSHARES];
} polyveck_mask;

typedef struct {
    polyvecl share[NSHARES];
} polyvecl_mask;

void masked_polyveck(polyveck_mask* mpv, const polyveck* pv);
void masked_polyvecl(polyvecl_mask* mpv, const polyvecl* pv);
void unmasked_polyveck(polyveck* pv, const polyveck_mask* mpv);
void unmasked_polyvecl(polyvecl* pv, const polyvecl_mask* mpv);

#endif /* SRC_APPLICATION_HART1_MASKED_UTILS_H_ */
