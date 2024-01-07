/*
 * polyvec.h
 *
 *  Created on: 2023年1月11日
 *      Author: wangt
 */

#ifndef POLYVEC_H_
#define POLYVEC_H_

#include <stdint.h>
#include "params.h"
#include "poly.h"

#define polyvec_compress KYBER_NAMESPACE(_polyvec_compress)
void polyvec_compress(uint8_t r[KYBER_POLYVECCOMPRESSEDBYTES], polyvec *a);
#define polyvec_decompress KYBER_NAMESPACE(_polyvec_decompress)
void polyvec_decompress(polyvec *r,
                        const uint8_t a[KYBER_POLYVECCOMPRESSEDBYTES]);

#define polyvec_tobytes KYBER_NAMESPACE(_polyvec_tobytes)
void polyvec_tobytes(uint8_t r[KYBER_POLYVECBYTES], polyvec *a);
#define polyvec_frombytes KYBER_NAMESPACE(_polyvec_frombytes)
void polyvec_frombytes(polyvec *r, const uint8_t a[KYBER_POLYVECBYTES]);

#define polyvec_hw_ntt KYBER_NAMESPACE(_polyvec_hw_ntt)
void polyvec_hw_ntt(polyvec *r, int rd);

#define polyvec_matrix_mult KYBER_NAMESPACE(_polyvec_matrix_mult)
void polyvec_matrix_mult(polyvec *r, polyvec a[KYBER_K], polyvec *b);
#define polyvec_matrix_multadd KYBER_NAMESPACE(_polyvec_matrix_multadd)
void polyvec_matrix_multadd(polyvec *r, polyvec a[KYBER_K], polyvec *b, polyvec *c);
#define polyvec_mult KYBER_NAMESPACE(_polyvec_mult)
void polyvec_mult(poly *r, polyvec *a, polyvec *b);

#define polyvec_csubq KYBER_NAMESPACE(_polyvec_csubq)
void polyvec_csubq(polyvec *r);

#define polyvec_add KYBER_NAMESPACE(_polyvec_add)
void polyvec_add(polyvec *r, const polyvec *a, const polyvec *b);

#endif /* SRC_APPLICATION_HART2_POLYVEC_H_ */
