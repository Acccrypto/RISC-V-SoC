/*
 * fips202.c
 *
 *  Created on: 2023年1月8日
 *      Author: wangt
 */

#include <hart1/fips202.h>
#include <stddef.h>
#include <stdint.h>
#include "keccak.h"

/*************************************************
* Name:        keccak_absorb
*
* Description: Absorb step of Keccak;
*              non-incremental, starts by zeroeing the state.
*
* Arguments:   - uint64_t *s: pointer to (uninitialized) output Keccak state
*              - unsigned int r: rate in bytes (e.g., 168 for SHAKE128)
*              - const uint8_t *m: pointer to input to be absorbed into s
*              - size_t mlen: length of input in bytes
*              - uint8_t p: domain-separation byte for different
*                           Keccak-derived functions
**************************************************/
static void keccak_absorb(unsigned int r,
                          const uint8_t *m,
                          size_t mlen,
                          uint8_t p)
{
  size_t i;
  uint8_t t[200] = {0};

  /* Zero state */
  state_init();

  while(mlen >= r) {
    loadR(m, r);
    KeccakF1600_StatePermute();
    mlen -= r;
    m += r;
  }

  for(i=0;i<mlen;i++)
    t[i] = m[i];
  t[i] = p;
  t[r-1] |= 128;
  loadR(t, r);
}

/*************************************************
* Name:        keccak_squeezeblocks
*
* Description: Squeeze step of Keccak. Squeezes full blocks of r bytes each.
*              Modifies the state. Can be called multiple times to keep
*              squeezing, i.e., is incremental.
*
* Arguments:   - uint8_t *h: pointer to output blocks
*              - size_t nblocks: number of blocks to be squeezed (written to h)
*              - uint64_t *s: pointer to input/output Keccak state
*              - unsigned int r: rate in bytes (e.g., 168 for SHAKE128)
**************************************************/
static void keccak_squeezeblocks(uint8_t *out,
                                 size_t nblocks,
                                 unsigned int r)
{
  unsigned int i;
  while(nblocks > 0) {
    KeccakF1600_StatePermute();
    storeR(out, r);
    out += r;
    --nblocks;
  }
}

/*************************************************
* Name:        shake128_absorb
*
* Description: Absorb step of the SHAKE128 XOF.
*              non-incremental, starts by zeroeing the state.
*
* Arguments:   - keccak_state *state: pointer to (uninitialized) output
*                                     Keccak state
*              - const uint8_t *in:   pointer to input to be absorbed into s
*              - size_t inlen:        length of input in bytes
**************************************************/
void shake128_absorb(const uint8_t *in, size_t inlen)
{
  keccak_absorb(SHAKE128_RATE, in, inlen, 0x1F);
}

/*************************************************
* Name:        shake128_squeezeblocks
*
* Description: Squeeze step of SHAKE128 XOF. Squeezes full blocks of
*              SHAKE128_RATE bytes each. Modifies the state. Can be called
*              multiple times to keep squeezing, i.e., is incremental.
*
* Arguments:   - uint8_t *out:    pointer to output blocks
*              - size_t nblocks:  number of blocks to be squeezed
*                                 (written to output)
*              - keccak_state *s: pointer to input/output Keccak state
**************************************************/
void shake128_squeezeblocks(uint8_t *out, size_t nblocks)
{
  keccak_squeezeblocks(out, nblocks, SHAKE128_RATE);
}

/*************************************************
* Name:        shake256_absorb
*
* Description: Absorb step of the SHAKE256 XOF.
*              non-incremental, starts by zeroeing the state.
*
* Arguments:   - keccak_state *s:   pointer to (uninitialized) output Keccak state
*              - const uint8_t *in: pointer to input to be absorbed into s
*              - size_t inlen:      length of input in bytes
**************************************************/
void shake256_absorb(const uint8_t *in, size_t inlen)
{
  keccak_absorb(SHAKE256_RATE, in, inlen, 0x1F);
}

/*************************************************
* Name:        shake256_squeezeblocks
*
* Description: Squeeze step of SHAKE256 XOF. Squeezes full blocks of
*              SHAKE256_RATE bytes each. Modifies the state. Can be called
*              multiple times to keep squeezing, i.e., is incremental.
*
* Arguments:   - uint8_t *out:    pointer to output blocks
*              - size_t nblocks:  number of blocks to be squeezed
*                                 (written to output)
*              - keccak_State *s: pointer to input/output Keccak state
**************************************************/
void shake256_squeezeblocks(uint8_t *out, size_t nblocks)
{
  keccak_squeezeblocks(out, nblocks, SHAKE256_RATE);
}

/*************************************************
* Name:        shake128
*
* Description: SHAKE128 XOF with non-incremental API
*
* Arguments:   - uint8_t *out:      pointer to output
*              - size_t outlen:     requested output length in bytes
*              - const uint8_t *in: pointer to input
*              - size_t inlen:      length of input in bytes
**************************************************/
void shake128(uint8_t *out, size_t outlen, const uint8_t *in, size_t inlen)
{
  unsigned int i;
  size_t nblocks = outlen/SHAKE128_RATE;
  uint8_t t[SHAKE128_RATE];

  shake128_absorb(in, inlen);
  shake128_squeezeblocks(out, nblocks);

  out += nblocks*SHAKE128_RATE;
  outlen -= nblocks*SHAKE128_RATE;

  if(outlen) {
    shake128_squeezeblocks(t, 1);
    for(i=0;i<outlen;i++)
      out[i] = t[i];
  }
}

/*************************************************
* Name:        shake256
*
* Description: SHAKE256 XOF with non-incremental API
*
* Arguments:   - uint8_t *out:      pointer to output
*              - size_t outlen:     requested output length in bytes
*              - const uint8_t *in: pointer to input
*              - size_t inlen:      length of input in bytes
**************************************************/
void shake256(uint8_t *out, size_t outlen, const uint8_t *in, size_t inlen)
{
  unsigned int i;
  size_t nblocks = outlen/SHAKE256_RATE;
  uint8_t t[SHAKE256_RATE];

  shake256_absorb(in, inlen);
  shake256_squeezeblocks(out, nblocks);

  out += nblocks*SHAKE256_RATE;
  outlen -= nblocks*SHAKE256_RATE;

  if(outlen) {
    shake256_squeezeblocks(t, 1);
    for(i=0;i<outlen;i++)
      out[i] = t[i];
  }
}
