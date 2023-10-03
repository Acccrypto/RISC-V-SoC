/*
 * symmetric.c
 *
 *  Created on: 2023年1月8日
 *      Author: wangt
 */

#include <hart1/fips202.h>
#include <hart1/params.h>
#include <hart1/symmetric.h>
#include <stdint.h>
#include <string.h>

void dilithium_shake128_stream_init(const uint8_t seed[SEEDBYTES],
                                    uint16_t nonce)
{
  uint8_t t[SEEDBYTES+2];
  memcpy(t, seed, SEEDBYTES);
  t[SEEDBYTES] = nonce;
  t[SEEDBYTES+1] = nonce >> 8;

  shake128_absorb(t, SEEDBYTES+2);
}

void dilithium_shake256_stream_init(const uint8_t seed[CRHBYTES],
                                    uint16_t nonce)
{
  uint8_t t[CRHBYTES+2];
  memcpy(t, seed, CRHBYTES);
  t[CRHBYTES] = nonce;
  t[CRHBYTES+1] = nonce >> 8;

  shake256_absorb(t, CRHBYTES+2);
}
