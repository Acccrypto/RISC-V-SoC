/*
 * polyvec.h
 *
 *  Created on: 2023年1月8日
 *      Author: wangt
 */

#ifndef APPLICATION_HART1_POLYVEC_H_
#define APPLICATION_HART1_POLYVEC_H_

#include <hart1/params.h>
#include "poly.h"
#include "drivers/fpga_ip/CorePoly/core_poly.h"
#include <stdint.h>

#define polyvec_matrix_mult DILITHIUM_NAMESPACE(_polyvec_matrix_mult)
void polyvec_matrix_mult(polyveck *t, polyvecl mat[K], polyvecl *v, int rd);

#define polyvecl_mult DILITHIUM_NAMESPACE(_polyvecl_mult)
void polyvecl_mult(polyvecl *r, poly_instance_t *a, polyvecl *v);

#define polyvecl_chknorm DILITHIUM_NAMESPACE(_polyvecl_chknorm)
int polyvecl_chknorm(const polyvecl *v, int32_t B);
#define polyvecl_chknorm_mod DILITHIUM_NAMESPACE(_polyvecl_chknorm_mod)
int polyvecl_chknorm_mod(const polyvecl *v, int32_t B);

#define polyveck_mult DILITHIUM_NAMESPACE(_polyveck_mult)
void polyveck_mult(polyveck *r, poly_instance_t *a, polyveck *v);
#define polyveck_mult_cp DILITHIUM_NAMESPACE(_polyveck_mult_cp)
void polyveck_mult_cp(polyveck *r, polyveck *v);
#define polyveck_multadd_cp DILITHIUM_NAMESPACE(_polyveck_multadd_cp)
void polyveck_multadd_cp(polyveck *r, polyveck *w, polyveck *v);

#define polyveck_chknorm_mod DILITHIUM_NAMESPACE(_polyveck_chknorm_mod)
int polyveck_chknorm_mod(const polyveck *v, int32_t B);

#define polyveck_make_hint DILITHIUM_NAMESPACE(_polyveck_make_hint)
unsigned int polyveck_make_hint(polyveck *h,
                                const polyveck *v0,
                                const polyveck *v1);

#endif /* APPLICATION_HART1_POLYVEC_H_ */
