/*
 * symmetric.h
 *
 *  Created on: 2023年1月11日
 *      Author: wangt
 */

#ifndef SYMMETRIC_H_
#define SYMMETRIC_H_

#include "fips202.h"
#include <stddef.h>
#include <stdint.h>
#include "params.h"

#define kyber_shake128_absorb KYBER_NAMESPACE(_kyber_shake128_absorb)
void kyber_shake128_absorb(const uint8_t seed[KYBER_SYMBYTES],
                           uint8_t x,
                           uint8_t y);

#define kyber_shake256_prf KYBER_NAMESPACE(_kyber_shake256_prf)
void kyber_shake256_prf(uint8_t *out,
                        size_t outlen,
                        const uint8_t key[KYBER_SYMBYTES],
                        uint8_t nonce);

#define XOF_BLOCKBYTES SHAKE128_RATE

#define hash_h(OUT, IN, INBYTES) sha3_256(OUT, IN, INBYTES)
#define hash_g(OUT, IN, INBYTES) sha3_512(OUT, IN, INBYTES)
#define xof_absorb(SEED, X, Y) kyber_shake128_absorb(SEED, X, Y)
#define xof_squeezeblocks(OUT, OUTBLOCKS) \
        shake128_squeezeblocks(OUT, OUTBLOCKS)
#define prf(OUT, OUTBYTES, KEY, NONCE) \
        kyber_shake256_prf(OUT, OUTBYTES, KEY, NONCE)
#define kdf(OUT, IN, INBYTES) shake256(OUT, KYBER_SSBYTES, IN, INBYTES)

#endif /* SRC_APPLICATION_HART2_SYMMETRIC_H_ */
