/*
 * poly.h
 *
 *  Created on: 2023年1月11日
 *      Author: wangt
 */

#ifndef POLY_H_
#define POLY_H_

#include <stdint.h>
#include "params.h"
#include "drivers/fpga_ip/CorePoly/core_poly.h"

#define poly_uniform KYBER_NAMESPACE(_poly_uniform)
void poly_uniform(poly *a, const uint8_t seed[KYBER_SYMBYTES], unsigned int i, unsigned int j);

#define poly_compress KYBER_NAMESPACE(_poly_compress)
void poly_compress(uint8_t r[KYBER_POLYCOMPRESSEDBYTES], poly *a);
#define poly_decompress KYBER_NAMESPACE(_poly_decompress)
void poly_decompress(poly *r, const uint8_t a[KYBER_POLYCOMPRESSEDBYTES]);

#define poly_tobytes KYBER_NAMESPACE(_poly_tobytes)
void poly_tobytes(uint8_t r[KYBER_POLYBYTES], poly *a);
#define poly_frombytes KYBER_NAMESPACE(_poly_frombytes)
void poly_frombytes(poly *r, const uint8_t a[KYBER_POLYBYTES]);

#define poly_frommsg KYBER_NAMESPACE(_poly_frommsg)
void poly_frommsg(poly *r, const uint8_t msg[KYBER_INDCPA_MSGBYTES]);
#define poly_frommsg_addepp KYBER_NAMESPACE(_poly_frommsg_addepp)
void poly_frommsg_addepp(poly *r, const uint8_t msg[KYBER_INDCPA_MSGBYTES], poly *epp);
#define poly_tomsg KYBER_NAMESPACE(_poly_tomsg)
void poly_tomsg(uint8_t msg[KYBER_INDCPA_MSGBYTES], poly *r);

#define poly_getnoise_eta1 KYBER_NAMESPACE(_poly_getnoise_eta1)
void poly_getnoise_eta1(poly *r, const uint8_t seed[KYBER_SYMBYTES], uint8_t nonce);

#define poly_getnoise_eta2 KYBER_NAMESPACE(_poly_getnoise_eta2)
void poly_getnoise_eta2(poly *r, const uint8_t seed[KYBER_SYMBYTES], uint8_t nonce);

#define poly_reduce KYBER_NAMESPACE(_poly_reduce)
void poly_reduce(poly *r);
#define poly_csubq KYBER_NAMESPACE(_poly_csubq)
void poly_csubq(poly *r);

#define poly_add KYBER_NAMESPACE(_poly_add)
void poly_add(poly *r, const poly *a, const poly *b);
#define poly_sub KYBER_NAMESPACE(_poly_sub)
void poly_sub(poly *r, const poly *a, const poly *b);

#endif /* SRC_APPLICATION_HART2_POLY_H_ */
