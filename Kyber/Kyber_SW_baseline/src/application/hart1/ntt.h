/*
 * ntt.h
 *
 *  Created on: 2023年1月11日
 *      Author: wangt
 */

#ifndef NTT_H_
#define NTT_H_

#include <stdint.h>
#include "params.h"

#define zetas KYBER_NAMESPACE(_zetas)
extern const int16_t zetas[128];

#define zetas_inv KYBER_NAMESPACE(_zetas_inv)
extern const int16_t zetas_inv[128];

#define ntt KYBER_NAMESPACE(_ntt)
void ntt(int16_t poly[256]);

#define invntt KYBER_NAMESPACE(_invntt)
void invntt(int16_t poly[256]);

#define basemul KYBER_NAMESPACE(_basemul)
void basemul(int16_t r[2],
             const int16_t a[2],
             const int16_t b[2],
             int16_t zeta);

#endif /* SRC_APPLICATION_HART2_NTT_H_ */
