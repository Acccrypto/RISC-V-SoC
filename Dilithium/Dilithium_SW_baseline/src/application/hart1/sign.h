/*
 * sign.h
 *
 *  Created on: 2023年1月8日
 *      Author: wangt
 */

#ifndef APPLICATION_HART1_SIGN_H_
#define APPLICATION_HART1_SIGN_H_

#include <hart1/params.h>
#include <hart1/poly.h>
#include <hart1/polyvec.h>
#include <stddef.h>
#include <stdint.h>

void randombytes(uint8_t *rd, int len);

#define challenge DILITHIUM_NAMESPACE(_challenge)
void challenge(poly *c, const uint8_t seed[SEEDBYTES]);

#define crypto_sign_keypair DILITHIUM_NAMESPACE(_keypair)
int crypto_sign_keypair(uint8_t *pk, uint8_t *sk);

#define crypto_sign_signature DILITHIUM_NAMESPACE(_signature)
int crypto_sign_signature(uint8_t *sig, size_t *siglen,
                          const uint8_t *m, size_t mlen,
                          const uint8_t *sk);

#define crypto_sign DILITHIUM_NAMESPACE()
int crypto_sign(uint8_t *sm, size_t *smlen,
                const uint8_t *m, size_t mlen,
                const uint8_t *sk);

#define crypto_sign_verify DILITHIUM_NAMESPACE(_verify)
int crypto_sign_verify(const uint8_t *sig, size_t siglen,
                       const uint8_t *m, size_t mlen,
                       const uint8_t *pk);

#define crypto_sign_open DILITHIUM_NAMESPACE(_open)
int crypto_sign_open(uint8_t *m, size_t *mlen,
                     const uint8_t *sm, size_t smlen,
                     const uint8_t *pk);

#endif /* APPLICATION_HART1_SIGN_H_ */
