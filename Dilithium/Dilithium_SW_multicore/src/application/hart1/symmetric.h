/*
 * symmetric.h
 *
 *  Created on: 2023年1月8日
 *      Author: wangt
 */

#ifndef APPLICATION_HART1_SYMMETRIC_H_
#define APPLICATION_HART1_SYMMETRIC_H_

#include <hart1/fips202.h>
#include <hart1/params.h>
#include <stdint.h>

#define dilithium_shake128_stream_init DILITHIUM_NAMESPACE(_dilithium_shake128_stream_init)
void dilithium_shake128_stream_init(const uint8_t seed[SEEDBYTES],
                                    uint16_t nonce);

#define dilithium_shake256_stream_init DILITHIUM_NAMESPACE(_dilithium_shake256_stream_init)
void dilithium_shake256_stream_init(const uint8_t seed[CRHBYTES],
                                    uint16_t nonce);

#define STREAM128_BLOCKBYTES SHAKE128_RATE
#define STREAM256_BLOCKBYTES SHAKE256_RATE

#define crh(OUT, IN, INBYTES) shake256(OUT, CRHBYTES, IN, INBYTES)
#define stream128_init(SEED, NONCE) \
        dilithium_shake128_stream_init(SEED, NONCE)
#define stream128_squeezeblocks(OUT, OUTBLOCKS) \
        shake128_squeezeblocks(OUT, OUTBLOCKS)
#define stream256_init(SEED, NONCE) \
        dilithium_shake256_stream_init(SEED, NONCE)
#define stream256_squeezeblocks(OUT, OUTBLOCKS) \
        shake256_squeezeblocks(OUT, OUTBLOCKS)

#endif /* APPLICATION_HART1_SYMMETRIC_H_ */
