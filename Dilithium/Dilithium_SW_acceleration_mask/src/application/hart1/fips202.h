/*
 * fips202.h
 *
 *  Created on: 2023年1月8日
 *      Author: wangt
 */

#ifndef APPLICATION_HART1_FIPS202_H_
#define APPLICATION_HART1_FIPS202_H_

#include <stddef.h>
#include <stdint.h>

#define SHAKE128_RATE 168
#define SHAKE256_RATE 136

#define FIPS202_NAMESPACE(s) pqcrystals_dilithium_fips202_ref##s

typedef struct {
  uint64_t s[25];
  unsigned int pos;
} keccak_state;

#define shake128_init FIPS202_NAMESPACE(_shake128_init)
void shake128_init(keccak_state *state);
#define shake128_absorb FIPS202_NAMESPACE(_shake128_absorb)
void shake128_absorb(keccak_state *state, const uint8_t *in, size_t inlen);
#define shake128_finalize FIPS202_NAMESPACE(_shake128_finalize)
void shake128_finalize(keccak_state *state);
#define shake128_squeezeblocks FIPS202_NAMESPACE(_shake128_squeezeblocks)
void shake128_squeezeblocks(uint8_t *out, size_t nblocks, keccak_state *state);
#define shake128_squeeze FIPS202_NAMESPACE(_shake128_squeeze)
void shake128_squeeze(uint8_t *out, size_t outlen, keccak_state *state);

#define shake256_init FIPS202_NAMESPACE(_shake256_init)
void shake256_init(keccak_state *state);
#define shake256_absorb FIPS202_NAMESPACE(_shake256_absorb)
void shake256_absorb(keccak_state *state, const uint8_t *in, size_t inlen);
#define shake256_finalize FIPS202_NAMESPACE(_shake256_finalize)
void shake256_finalize(keccak_state *state);
#define shake256_squeezeblocks FIPS202_NAMESPACE(_shake256_squeezeblocks)
void shake256_squeezeblocks(uint8_t *out, size_t nblocks,  keccak_state *state);
#define shake256_squeeze FIPS202_NAMESPACE(_shake256_squeeze)
void shake256_squeeze(uint8_t *out, size_t outlen, keccak_state *state);

#define shake128 FIPS202_NAMESPACE(_shake128)
void shake128(uint8_t *out, size_t outlen, const uint8_t *in, size_t inlen);
#define shake256 FIPS202_NAMESPACE(_shake256)
void shake256(uint8_t *out, size_t outlen, const uint8_t *in, size_t inlen);

#endif /* APPLICATION_HART1_FIPS202_H_ */
