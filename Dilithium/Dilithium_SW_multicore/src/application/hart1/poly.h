/*
 * poly.h
 *
 *  Created on: 2023年1月7日
 *      Author: wangt
 */

#ifndef APPLICATION_HART1_POLY_H_
#define APPLICATION_HART1_POLY_H_

#include <hart1/params.h>
#include <stdint.h>
#include "drivers/fpga_ip/CorePoly/core_poly.h"

#define poly_shiftl DILITHIUM_NAMESPACE(_poly_shiftl)
void poly_shiftl(poly_instance_t *a);

#define poly_power2round DILITHIUM_NAMESPACE(_poly_power2round)
void poly_power2round(poly_instance_t *a1, poly_instance_t *a0, const poly_instance_t *a);
#define poly_decompose DILITHIUM_NAMESPACE(_poly_decompose)
void poly_decompose(poly_instance_t *a1, poly_instance_t *a0, const poly_instance_t *a);
#define poly_make_hint DILITHIUM_NAMESPACE(_poly_make_hint)
unsigned int poly_make_hint(poly_instance_t *h, const poly_instance_t *a0, const poly_instance_t *a1);
#define poly_use_hint DILITHIUM_NAMESPACE(_poly_use_hint)
void poly_use_hint(poly_instance_t *b, const poly_instance_t *a, const poly_instance_t *h);

#define poly_chknorm DILITHIUM_NAMESPACE(_poly_chknorm)
int poly_chknorm(const poly_instance_t *a, int32_t B);
#define poly_chknorm_mod DILITHIUM_NAMESPACE(_poly_chknorm_mod)
int poly_chknorm_mod(const poly_instance_t *a, int32_t B);
#define poly_uniform DILITHIUM_NAMESPACE(_poly_uniform)
void poly_uniform(poly_instance_t *a,
                  const uint8_t seed[SEEDBYTES],
                  uint16_t nonce);
#define poly_uniform_eta DILITHIUM_NAMESPACE(_poly_uniform_eta)
void poly_uniform_eta(poly_instance_t *a,
                      const uint8_t seed[SEEDBYTES],
                      uint16_t nonce);
#define poly_uniform_gamma1 DILITHIUM_NAMESPACE(_poly_uniform_gamma1)
void poly_uniform_gamma1(poly_instance_t *a,
                         const uint8_t seed[CRHBYTES],
                         uint16_t nonce);
#define poly_challenge DILITHIUM_NAMESPACE(_poly_challenge)
void poly_challenge(poly_instance_t *c, const uint8_t seed[SEEDBYTES]);

#define polyeta_pack DILITHIUM_NAMESPACE(_polyeta_pack)
void polyeta_pack(uint8_t *r, const poly_instance_t *a);
#define polyeta_unpack DILITHIUM_NAMESPACE(_polyeta_unpack)
void polyeta_unpack(poly_instance_t *r, const uint8_t *a);
#define polyeta_unpack_neg DILITHIUM_NAMESPACE(_polyeta_unpack_neg)
void polyeta_unpack_neg(poly_instance_t *r, const uint8_t *a);

#define polyt1_pack DILITHIUM_NAMESPACE(_polyt1_pack)
void polyt1_pack(uint8_t *r, const poly_instance_t *a);
#define polyt1_unpack_neg DILITHIUM_NAMESPACE(_polyt1_unpack_neg)
void polyt1_unpack_neg(poly_instance_t *r, const uint8_t *a);

#define polyt0_pack DILITHIUM_NAMESPACE(_polyt0_pack)
void polyt0_pack(uint8_t *r, const poly_instance_t *a);
#define polyt0_unpack DILITHIUM_NAMESPACE(_polyt0_unpack)
void polyt0_unpack(poly_instance_t *r, const uint8_t *a);

#define polyz_pack_mod DILITHIUM_NAMESPACE(_polyz_pack_mod)
void polyz_pack_mod(uint8_t *r, const poly_instance_t *a);
#define polyz_unpack DILITHIUM_NAMESPACE(_polyz_unpack)
void polyz_unpack(poly_instance_t *r, const uint8_t *a);

#define polyw1_pack DILITHIUM_NAMESPACE(_polyw1_pack)
void polyw1_pack(uint8_t *r, const poly_instance_t *a);

#endif /* APPLICATION_HART1_POLY_H_ */
