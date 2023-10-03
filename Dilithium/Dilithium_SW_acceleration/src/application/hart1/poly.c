/*
 * poly.c
 *
 *  Created on: 2023年1月7日
 *      Author: wangt
 */
#include "hart1/params.h"
#include <hart1/poly.h>
#include <hart1/rounding.h>
#include <hart1/symmetric.h>
#include <stdint.h>
#include <stdlib.h>

/*************************************************
* Name:        poly_power2round
*
* Description: For all coefficients c of the input polynomial,
*              compute c0, c1 such that c mod Q = c1*2^D + c0
*              with -2^{D-1} < c0 <= 2^{D-1}. Assumes coefficients to be
*              standard representatives.
*
* Arguments:   - poly *a1: pointer to output polynomial with coefficients c1
*              - poly *a0: pointer to output polynomial with coefficients c0
*              - const poly *a: pointer to input polynomial
**************************************************/
void poly_power2round(poly_instance_t *a1, poly_instance_t *a0, const poly_instance_t *a)
{
  unsigned int i;

  for(i = 0; i < N; ++i)
    a1->coeffs[i] = power2round(&a0->coeffs[i], a->coeffs[i]);
}

/*************************************************
* Name:        poly_decompose
*
* Description: For all coefficients c of the input polynomial,
*              compute high and low bits c0, c1 such c mod Q = c1*ALPHA + c0
*              with -ALPHA/2 < c0 <= ALPHA/2 except c1 = (Q-1)/ALPHA where we
*              set c1 = 0 and -ALPHA/2 <= c0 = c mod Q - Q < 0.
*              Assumes coefficients to be standard representatives.
*
* Arguments:   - poly *a1: pointer to output polynomial with coefficients c1
*              - poly *a0: pointer to output polynomial with coefficients c0
*              - const poly *a: pointer to input polynomial
**************************************************/
void poly_decompose(poly_instance_t *a1, poly_instance_t *a0, const poly_instance_t *a)
{
  unsigned int i;

  for(i = 0; i < N; ++i)
    a1->coeffs[i] = decompose(&a0->coeffs[i], a->coeffs[i]);
}

/*************************************************
* Name:        poly_make_hint
*
* Description: Compute hint polynomial. The coefficients of which indicate
*              whether the low bits of the corresponding coefficient of
*              the input polynomial overflow into the high bits.
*
* Arguments:   - poly *h: pointer to output hint polynomial
*              - const poly *a0: pointer to low part of input polynomial
*              - const poly *a1: pointer to high part of input polynomial
*
* Returns number of 1 bits.
**************************************************/
unsigned int poly_make_hint(poly_instance_t *h, const poly_instance_t *a0, const poly_instance_t *a1)
{
  unsigned int i, s = 0;

  for(i = 0; i < N; ++i) {
    h->coeffs[i] = make_hint(a0->coeffs[i], a1->coeffs[i]);
    s += h->coeffs[i];
  }

  return s;
}

/*************************************************
* Name:        poly_use_hint
*
* Description: Use hint polynomial to correct the high bits of a polynomial.
*
* Arguments:   - poly *b: pointer to output polynomial with corrected high bits
*              - const poly *a: pointer to input polynomial
*              - const poly *h: pointer to input hint polynomial
**************************************************/
void poly_use_hint(poly_instance_t *b, const poly_instance_t *a, const poly_instance_t *h)
{
  unsigned int i;

  for(i = 0; i < N; ++i)
    b->coeffs[i] = use_hint(a->coeffs[i], h->coeffs[i]);
}

/*************************************************
* Name:        poly_chknorm
*
* Description: Check infinity norm of polynomial against given bound.
*              Assumes input coefficients were reduced by reduce32().
*
* Arguments:   - const poly *a: pointer to polynomial
*              - int32_t B: norm bound
*
* Returns 0 if norm is strictly smaller than B <= (Q-1)/8 and 1 otherwise.
**************************************************/
int poly_chknorm(const poly_instance_t *a, int32_t B)
{
  unsigned int i;
  int32_t t;

  if(B > (Q-1)/8)
    return 1;

  /* It is ok to leak which coefficient violates the bound since
     the probability for each coefficient is independent of secret
     data but we must not leak the sign of the centralized representative. */
  for(i = 0; i < N; ++i) {
    /* Absolute value */
    t = a->coeffs[i] >> 31;
    t = a->coeffs[i] - (t & 2*a->coeffs[i]);

    if(t >= B) {
      return 1;
    }
  }

  return 0;
}

int poly_chknorm_mod(const poly_instance_t *a, int32_t B)
{
  unsigned int i;

  if(B > (Q-1)/8)
    return 1;

  /* It is ok to leak which coefficient violates the bound since
     the probability for each coefficient is independent of secret
     data but we must not leak the sign of the centralized representative. */
  for(i = 0; i < N; ++i) {
    if((a->coeffs[i] >= B) && (a->coeffs[i] <= Q-B)) {
        return 1;
    }
  }

  return 0;
}

/*************************************************
* Name:        rej_uniform
*
* Description: Sample uniformly random coefficients in [0, Q-1] by
*              performing rejection sampling on array of random bytes.
*
* Arguments:   - int32_t *a: pointer to output array (allocated)
*              - unsigned int len: number of coefficients to be sampled
*              - const uint8_t *buf: array of random bytes
*              - unsigned int buflen: length of array of random bytes
*
* Returns number of sampled coefficients. Can be smaller than len if not enough
* random bytes were given.
**************************************************/
/*static unsigned int rej_uniform(int32_t *a,
                                unsigned int len,
                                const uint8_t *buf,
                                unsigned int buflen)
{
  unsigned int ctr, pos;
  uint32_t t;

  ctr = pos = 0;
  while(ctr < len && pos + 3 <= buflen) {
    t  = buf[pos++];
    t |= (uint32_t)buf[pos++] << 8;
    t |= (uint32_t)buf[pos++] << 16;
    t &= 0x7FFFFF;

    if(t < Q)
      a[ctr++] = t;
  }

  return ctr;
}*/

static unsigned int rej_uniform(int32_t *a,
                                unsigned int len,
                                const uint8_t *buf,
                                unsigned int buflen)
{
  unsigned int ctr;
  asm volatile(
       "mv         t6,   %[PE]        \n\t" //t6=Q
       "mv         t5,   %[PD]        \n\t" //t5=buf
       "mv         t3,   %[PC]        \n\t" //t3=len
       "mv         s6,   %[PF]        \n\t" //s6=buflen
       "mv         t4,   %[PB]        \n\t" //t4=a
       "addi       s3,   x0,   -1     \n\t" //s3=0xffffffff
       "slli       t3,   t3,   2      \n\t"
       "addi       s6,   s6,   -2     \n\t"
       "lui        s2,   0xff800      \n\t"
       "add        t1,   x0,   t4     \n\t"
       "xor        s2,   s2,   s3     \n\t" //s2=0x7fffff
       "add        t3,   t3,   t4     \n\t"
       "add        s6,   s6,   t5     \n\t"
       "jal        x0,   mLOOP1%=       \n\t"

       "mLOOP1%=:                        \n\t"
       "lbu        s0,   0(t5)         \n\t"
       "lbu        s1,   1(t5)         \n\t"
       "lbu        s5,   2(t5)         \n\t"
       "slli       s1,   s1,   8       \n\t"
       "slli       s5,   s5,   16      \n\t"
       "or         s0,   s0,   s1      \n\t"
       "or         s0,   s0,   s5      \n\t"
       "and        s0,   s0,   s2      \n\t"
       "sw         s0,   0(t4)         \n\t"
       "addi       t5,   t5,   3       \n\t"
       "bgeu       s0,   t6,   mLOOP1%=  \n\t"
       "addi       t4,   t4,   4       \n\t"
       "bgeu       t4,   t3,   OUT%=    \n\t"
       "bgeu       t5,   s6,   OUT%=   \n\t"
       "jal        x0,   mLOOP1%=       \n\t"

       "OUT%=:                          \n\t"
       "sub        t4,   t4,   t1     \n\t"
       "srli       t1,   t4,   2      \n\t"
       "sw         t1,   (%[PA])      \n\t"
       :
       :[PA]"r"(&ctr),[PB]"r"(a),[PC]"r"(len),[PD]"r"(buf),[PF]"r"(buflen),[PE]"r"(Q)
       :"cc","memory","t1", "t3", "t4", "t5", "t6", "s0", "s1", "s2", "s3","s5","s6"
       );

  return ctr;
}

/*************************************************
* Name:        poly_uniform
*
* Description: Sample polynomial with uniformly random coefficients
*              in [0,Q-1] by performing rejection sampling on the
*              output stream of SHAKE256(seed|nonce) or AES256CTR(seed,nonce).
*
* Arguments:   - poly *a: pointer to output polynomial
*              - const uint8_t seed[]: byte array with seed of length SEEDBYTES
*              - uint16_t nonce: 2-byte nonce
**************************************************/
#define POLY_UNIFORM_NBLOCKS ((768 + STREAM128_BLOCKBYTES - 1)/STREAM128_BLOCKBYTES)
void poly_uniform(poly_instance_t *a,
                  const uint8_t seed[SEEDBYTES],
                  uint16_t nonce)
{
  unsigned int i, ctr, off;
  _Alignas(8) uint8_t buf[POLY_UNIFORM_NBLOCKS*STREAM128_BLOCKBYTES];
  unsigned int buflen = POLY_UNIFORM_NBLOCKS*STREAM128_BLOCKBYTES;

  stream128_init(seed, nonce);
  stream128_squeezeblocks(buf, POLY_UNIFORM_NBLOCKS);

  ctr = rej_uniform(a->coeffs, N, buf, buflen);

  while(ctr < N) {
    off = buflen % 3;
    for(i = 0; i < off; ++i)
      buf[i] = buf[buflen - off + i];

    stream128_squeezeblocks(buf + off, 1);
    buflen = STREAM128_BLOCKBYTES + off;
    ctr += rej_uniform(a->coeffs + ctr, N - ctr, buf, buflen);
  }
}

/*************************************************
* Name:        rej_eta
*
* Description: Sample uniformly random coefficients in [-ETA, ETA] by
*              performing rejection sampling on array of random bytes.
*
* Arguments:   - int32_t *a: pointer to output array (allocated)
*              - unsigned int len: number of coefficients to be sampled
*              - const uint8_t *buf: array of random bytes
*              - unsigned int buflen: length of array of random bytes
*
* Returns number of sampled coefficients. Can be smaller than len if not enough
* random bytes were given.
**************************************************/
static unsigned int rej_eta(int32_t *a,
                            unsigned int len,
                            const uint8_t *buf,
                            unsigned int buflen)
{
  unsigned int ctr, pos;
  uint32_t t0, t1;

  ctr = pos = 0;
  while(ctr < len && pos < buflen) {
    t0 = buf[pos] & 0x0F;
    t1 = buf[pos++] >> 4;

#if ETA == 2
    if(t0 < 15) {
      t0 = t0 - (205*t0 >> 10)*5;
      a[ctr++] = 2 - t0;
    }
    if(t1 < 15 && ctr < len) {
      t1 = t1 - (205*t1 >> 10)*5;
      a[ctr++] = 2 - t1;
    }
#elif ETA == 4
    if(t0 < 9)
      a[ctr++] = 4 - t0;
    if(t1 < 9 && ctr < len)
      a[ctr++] = 4 - t1;
#endif
  }

  return ctr;
}

/*************************************************
* Name:        poly_uniform_eta
*
* Description: Sample polynomial with uniformly random coefficients
*              in [-ETA,ETA] by performing rejection sampling on the
*              output stream from SHAKE256(seed|nonce) or AES256CTR(seed,nonce).
*
* Arguments:   - poly *a: pointer to output polynomial
*              - const uint8_t seed[]: byte array with seed of length SEEDBYTES
*              - uint16_t nonce: 2-byte nonce
**************************************************/
#if ETA == 2
#define POLY_UNIFORM_ETA_NBLOCKS ((136 + STREAM128_BLOCKBYTES - 1)/STREAM128_BLOCKBYTES)
#elif ETA == 4
#define POLY_UNIFORM_ETA_NBLOCKS ((227 + STREAM128_BLOCKBYTES - 1)/STREAM128_BLOCKBYTES)
#endif
void poly_uniform_eta(poly_instance_t *a,
                      const uint8_t seed[SEEDBYTES],
                      uint16_t nonce)
{
  unsigned int ctr;
  _Alignas(8) uint8_t buf[POLY_UNIFORM_ETA_NBLOCKS*STREAM128_BLOCKBYTES];
  unsigned int buflen = POLY_UNIFORM_ETA_NBLOCKS*STREAM128_BLOCKBYTES;

  stream128_init(seed, nonce);
  stream128_squeezeblocks(buf, POLY_UNIFORM_ETA_NBLOCKS);

  ctr = rej_eta(a->coeffs, N, buf, buflen);

  while(ctr < N) {
    stream128_squeezeblocks(buf, 1);
    ctr += rej_eta(a->coeffs + ctr, N - ctr, buf, STREAM128_BLOCKBYTES);
  }
}

/*************************************************
* Name:        poly_uniform_gamma1m1
*
* Description: Sample polynomial with uniformly random coefficients
*              in [-(GAMMA1 - 1), GAMMA1] by unpacking output stream
*              of SHAKE256(seed|nonce) or AES256CTR(seed,nonce).
*
* Arguments:   - poly *a: pointer to output polynomial
*              - const uint8_t seed[]: byte array with seed of length CRHBYTES
*              - uint16_t nonce: 16-bit nonce
**************************************************/
#if GAMMA1 == (1 << 17)
#define POLY_UNIFORM_GAMMA1_NBLOCKS ((576 + STREAM256_BLOCKBYTES - 1)/STREAM256_BLOCKBYTES)
#elif GAMMA1 == (1 << 19)
#define POLY_UNIFORM_GAMMA1_NBLOCKS ((640 + STREAM256_BLOCKBYTES - 1)/STREAM256_BLOCKBYTES)
#endif
void poly_uniform_gamma1(poly_instance_t *a,
                         const uint8_t seed[CRHBYTES],
                         uint16_t nonce)
{
  _Alignas(8) uint8_t buf[POLY_UNIFORM_GAMMA1_NBLOCKS*STREAM256_BLOCKBYTES];

  stream256_init(seed, nonce);
  stream256_squeezeblocks(buf, POLY_UNIFORM_GAMMA1_NBLOCKS);
  polyz_unpack(a, buf);
}

/*************************************************
* Name:        challenge
*
* Description: Implementation of H. Samples polynomial with TAU nonzero
*              coefficients in {-1,1} using the output stream of
*              SHAKE256(seed).
*
* Arguments:   - poly *c: pointer to output polynomial
*              - const uint8_t mu[]: byte array containing seed of length SEEDBYTES
**************************************************/
void poly_challenge(poly_instance_t *c, const uint8_t seed[SEEDBYTES])
{
  unsigned int i, b, pos;
  uint64_t signs;
  _Alignas(8) uint8_t buf[SHAKE256_RATE];

  shake256_absorb(seed, SEEDBYTES);
  shake256_squeezeblocks(buf, 1);

  signs = 0;
  for(i = 0; i < 8; ++i)
    signs |= (uint64_t)buf[i] << 8*i;
  pos = 8;

  for(i = 0; i < N; ++i)
    c->coeffs[i] = 0;
  for(i = N-TAU; i < N; ++i) {
    do {
      if(pos >= SHAKE256_RATE) {
        shake256_squeezeblocks(buf, 1);
        pos = 0;
      }

      b = buf[pos++];
    } while(b > i);

    c->coeffs[i] = c->coeffs[b];
    c->coeffs[b] = 1 - 2*(signs & 1);
    signs >>= 1;
  }
}

/*************************************************
* Name:        polyeta_pack
*
* Description: Bit-pack polynomial with coefficients in [-ETA,ETA].
*
* Arguments:   - uint8_t *r: pointer to output byte array with at least
*                            POLYETA_PACKEDBYTES bytes
*              - const poly *a: pointer to input polynomial
**************************************************/
void polyeta_pack(uint8_t *r, const poly_instance_t *a)
{
  unsigned int i;
  uint8_t t[8];

#if ETA == 2
  for(i = 0; i < N/8; ++i) {
    t[0] = ETA - a->coeffs[8*i+0];
    t[1] = ETA - a->coeffs[8*i+1];
    t[2] = ETA - a->coeffs[8*i+2];
    t[3] = ETA - a->coeffs[8*i+3];
    t[4] = ETA - a->coeffs[8*i+4];
    t[5] = ETA - a->coeffs[8*i+5];
    t[6] = ETA - a->coeffs[8*i+6];
    t[7] = ETA - a->coeffs[8*i+7];

    r[3*i+0]  = (t[0] >> 0) | (t[1] << 3) | (t[2] << 6);
    r[3*i+1]  = (t[2] >> 2) | (t[3] << 1) | (t[4] << 4) | (t[5] << 7);
    r[3*i+2]  = (t[5] >> 1) | (t[6] << 2) | (t[7] << 5);
  }
#elif ETA == 4
  for(i = 0; i < N/2; ++i) {
    t[0] = ETA - a->coeffs[2*i+0];
    t[1] = ETA - a->coeffs[2*i+1];
    r[i] = t[0] | (t[1] << 4);
  }
#endif
}

/*************************************************
* Name:        polyeta_unpack
*
* Description: Unpack polynomial with coefficients in [-ETA,ETA].
*
* Arguments:   - poly *r: pointer to output polynomial
*              - const uint8_t *a: byte array with bit-packed polynomial
**************************************************/
void polyeta_unpack(poly_instance_t *r, const uint8_t *a) {
  unsigned int i;

#if ETA == 2
  for(i = 0; i < N/8; ++i) {
    r->coeffs[8*i+0] =  (a[3*i+0] >> 0) & 7;
    r->coeffs[8*i+1] =  (a[3*i+0] >> 3) & 7;
    r->coeffs[8*i+2] = ((a[3*i+0] >> 6) | (a[3*i+1] << 2)) & 7;
    r->coeffs[8*i+3] =  (a[3*i+1] >> 1) & 7;
    r->coeffs[8*i+4] =  (a[3*i+1] >> 4) & 7;
    r->coeffs[8*i+5] = ((a[3*i+1] >> 7) | (a[3*i+2] << 1)) & 7;
    r->coeffs[8*i+6] =  (a[3*i+2] >> 2) & 7;
    r->coeffs[8*i+7] =  (a[3*i+2] >> 5) & 7;

    r->coeffs[8*i+0] = ETA - r->coeffs[8*i+0];
    r->coeffs[8*i+1] = ETA - r->coeffs[8*i+1];
    r->coeffs[8*i+2] = ETA - r->coeffs[8*i+2];
    r->coeffs[8*i+3] = ETA - r->coeffs[8*i+3];
    r->coeffs[8*i+4] = ETA - r->coeffs[8*i+4];
    r->coeffs[8*i+5] = ETA - r->coeffs[8*i+5];
    r->coeffs[8*i+6] = ETA - r->coeffs[8*i+6];
    r->coeffs[8*i+7] = ETA - r->coeffs[8*i+7];
  }
#elif ETA == 4
  for(i = 0; i < N/2; ++i) {
    r->coeffs[2*i+0] = a[i] & 0x0F;
    r->coeffs[2*i+1] = a[i] >> 4;
    r->coeffs[2*i+0] = ETA - r->coeffs[2*i+0];
    r->coeffs[2*i+1] = ETA - r->coeffs[2*i+1];
  }
#endif
}

void polyeta_unpack_neg(poly_instance_t *r, const uint8_t *a) {
  unsigned int i;

#if ETA == 2
  for(i = 0; i < N/8; ++i) {
    r->coeffs[8*i+0] =  (a[3*i+0] >> 0) & 7;
    r->coeffs[8*i+1] =  (a[3*i+0] >> 3) & 7;
    r->coeffs[8*i+2] = ((a[3*i+0] >> 6) | (a[3*i+1] << 2)) & 7;
    r->coeffs[8*i+3] =  (a[3*i+1] >> 1) & 7;
    r->coeffs[8*i+4] =  (a[3*i+1] >> 4) & 7;
    r->coeffs[8*i+5] = ((a[3*i+1] >> 7) | (a[3*i+2] << 1)) & 7;
    r->coeffs[8*i+6] =  (a[3*i+2] >> 2) & 7;
    r->coeffs[8*i+7] =  (a[3*i+2] >> 5) & 7;

    r->coeffs[8*i+0] = r->coeffs[8*i+0] - ETA;
    r->coeffs[8*i+1] = r->coeffs[8*i+1] - ETA;
    r->coeffs[8*i+2] = r->coeffs[8*i+2] - ETA;
    r->coeffs[8*i+3] = r->coeffs[8*i+3] - ETA;
    r->coeffs[8*i+4] = r->coeffs[8*i+4] - ETA;
    r->coeffs[8*i+5] = r->coeffs[8*i+5] - ETA;
    r->coeffs[8*i+6] = r->coeffs[8*i+6] - ETA;
    r->coeffs[8*i+7] = r->coeffs[8*i+7] - ETA;
  }
#elif ETA == 4
  for(i = 0; i < N/2; ++i) {
    r->coeffs[2*i+0] = a[i] & 0x0F;
    r->coeffs[2*i+1] = a[i] >> 4;
    r->coeffs[2*i+0] = r->coeffs[2*i+0] - ETA;
    r->coeffs[2*i+1] = r->coeffs[2*i+1] - ETA;
  }
#endif
}

/*************************************************
* Name:        polyt1_pack
*
* Description: Bit-pack polynomial t1 with coefficients fitting in 10 bits.
*              Input coefficients are assumed to be standard representatives.
*
* Arguments:   - uint8_t *r: pointer to output byte array with at least
*                            POLYT1_PACKEDBYTES bytes
*              - const poly *a: pointer to input polynomial
**************************************************/
void polyt1_pack(uint8_t *r, const poly_instance_t *a)
{
  unsigned int i;

  for(i = 0; i < N/4; ++i) {
    r[5*i+0] = (a->coeffs[4*i+0] >> 0);
    r[5*i+1] = (a->coeffs[4*i+0] >> 8) | (a->coeffs[4*i+1] << 2);
    r[5*i+2] = (a->coeffs[4*i+1] >> 6) | (a->coeffs[4*i+2] << 4);
    r[5*i+3] = (a->coeffs[4*i+2] >> 4) | (a->coeffs[4*i+3] << 6);
    r[5*i+4] = (a->coeffs[4*i+3] >> 2);
  }
}

/*************************************************
* Name:        polyt1_unpack
*
* Description: Unpack polynomial t1 with 10-bit coefficients.
*              Output coefficients are standard representatives.
*
* Arguments:   - poly *r: pointer to output polynomial
*              - const uint8_t *a: byte array with bit-packed polynomial
**************************************************/
void polyt1_unpack_neg(poly_instance_t *r, const uint8_t *a)
{
  unsigned int i;

  for(i = 0; i < N/4; ++i) {
    r->coeffs[4*i+0] = (-(((a[5*i+0] >> 0) | ((uint32_t)a[5*i+1] << 8)) & 0x3FF)) << D;
    r->coeffs[4*i+1] = (-(((a[5*i+1] >> 2) | ((uint32_t)a[5*i+2] << 6)) & 0x3FF)) << D;
    r->coeffs[4*i+2] = (-(((a[5*i+2] >> 4) | ((uint32_t)a[5*i+3] << 4)) & 0x3FF)) << D;
    r->coeffs[4*i+3] = (-(((a[5*i+3] >> 6) | ((uint32_t)a[5*i+4] << 2)) & 0x3FF)) << D;
  }
}

/*************************************************
* Name:        polyt0_pack
*
* Description: Bit-pack polynomial t0 with coefficients in ]-2^{D-1}, 2^{D-1}].
*
* Arguments:   - uint8_t *r: pointer to output byte array with at least
*                            POLYT0_PACKEDBYTES bytes
*              - const poly *a: pointer to input polynomial
**************************************************/
void polyt0_pack(uint8_t *r, const poly_instance_t *a)
{
  unsigned int i;
  uint32_t t[8];

  for(i = 0; i < N/8; ++i) {
    t[0] = (1 << (D-1)) - a->coeffs[8*i+0];
    t[1] = (1 << (D-1)) - a->coeffs[8*i+1];
    t[2] = (1 << (D-1)) - a->coeffs[8*i+2];
    t[3] = (1 << (D-1)) - a->coeffs[8*i+3];
    t[4] = (1 << (D-1)) - a->coeffs[8*i+4];
    t[5] = (1 << (D-1)) - a->coeffs[8*i+5];
    t[6] = (1 << (D-1)) - a->coeffs[8*i+6];
    t[7] = (1 << (D-1)) - a->coeffs[8*i+7];

    r[13*i+ 0]  =  t[0];
    r[13*i+ 1]  =  t[0] >>  8;
    r[13*i+ 1] |=  t[1] <<  5;
    r[13*i+ 2]  =  t[1] >>  3;
    r[13*i+ 3]  =  t[1] >> 11;
    r[13*i+ 3] |=  t[2] <<  2;
    r[13*i+ 4]  =  t[2] >>  6;
    r[13*i+ 4] |=  t[3] <<  7;
    r[13*i+ 5]  =  t[3] >>  1;
    r[13*i+ 6]  =  t[3] >>  9;
    r[13*i+ 6] |=  t[4] <<  4;
    r[13*i+ 7]  =  t[4] >>  4;
    r[13*i+ 8]  =  t[4] >> 12;
    r[13*i+ 8] |=  t[5] <<  1;
    r[13*i+ 9]  =  t[5] >>  7;
    r[13*i+ 9] |=  t[6] <<  6;
    r[13*i+10]  =  t[6] >>  2;
    r[13*i+11]  =  t[6] >> 10;
    r[13*i+11] |=  t[7] <<  3;
    r[13*i+12]  =  t[7] >>  5;
  }
}

/*************************************************
* Name:        polyt0_unpack
*
* Description: Unpack polynomial t0 with coefficients in ]-2^{D-1}, 2^{D-1}].
*
* Arguments:   - poly *r: pointer to output polynomial
*              - const uint8_t *a: byte array with bit-packed polynomial
**************************************************/
void polyt0_unpack(poly_instance_t *r, const uint8_t *a)
{
  unsigned int i;

  for(i = 0; i < N/8; ++i) {
    r->coeffs[8*i+0]  = a[13*i+0];
    r->coeffs[8*i+0] |= (uint32_t)a[13*i+1] << 8;
    r->coeffs[8*i+0] &= 0x1FFF;

    r->coeffs[8*i+1]  = a[13*i+1] >> 5;
    r->coeffs[8*i+1] |= (uint32_t)a[13*i+2] << 3;
    r->coeffs[8*i+1] |= (uint32_t)a[13*i+3] << 11;
    r->coeffs[8*i+1] &= 0x1FFF;

    r->coeffs[8*i+2]  = a[13*i+3] >> 2;
    r->coeffs[8*i+2] |= (uint32_t)a[13*i+4] << 6;
    r->coeffs[8*i+2] &= 0x1FFF;

    r->coeffs[8*i+3]  = a[13*i+4] >> 7;
    r->coeffs[8*i+3] |= (uint32_t)a[13*i+5] << 1;
    r->coeffs[8*i+3] |= (uint32_t)a[13*i+6] << 9;
    r->coeffs[8*i+3] &= 0x1FFF;

    r->coeffs[8*i+4]  = a[13*i+6] >> 4;
    r->coeffs[8*i+4] |= (uint32_t)a[13*i+7] << 4;
    r->coeffs[8*i+4] |= (uint32_t)a[13*i+8] << 12;
    r->coeffs[8*i+4] &= 0x1FFF;

    r->coeffs[8*i+5]  = a[13*i+8] >> 1;
    r->coeffs[8*i+5] |= (uint32_t)a[13*i+9] << 7;
    r->coeffs[8*i+5] &= 0x1FFF;

    r->coeffs[8*i+6]  = a[13*i+9] >> 6;
    r->coeffs[8*i+6] |= (uint32_t)a[13*i+10] << 2;
    r->coeffs[8*i+6] |= (uint32_t)a[13*i+11] << 10;
    r->coeffs[8*i+6] &= 0x1FFF;

    r->coeffs[8*i+7]  = a[13*i+11] >> 3;
    r->coeffs[8*i+7] |= (uint32_t)a[13*i+12] << 5;
    r->coeffs[8*i+7] &= 0x1FFF;

    r->coeffs[8*i+0] = (1 << (D-1)) - r->coeffs[8*i+0];
    r->coeffs[8*i+1] = (1 << (D-1)) - r->coeffs[8*i+1];
    r->coeffs[8*i+2] = (1 << (D-1)) - r->coeffs[8*i+2];
    r->coeffs[8*i+3] = (1 << (D-1)) - r->coeffs[8*i+3];
    r->coeffs[8*i+4] = (1 << (D-1)) - r->coeffs[8*i+4];
    r->coeffs[8*i+5] = (1 << (D-1)) - r->coeffs[8*i+5];
    r->coeffs[8*i+6] = (1 << (D-1)) - r->coeffs[8*i+6];
    r->coeffs[8*i+7] = (1 << (D-1)) - r->coeffs[8*i+7];
  }
}

/*************************************************
* Name:        polyz_pack
*
* Description: Bit-pack polynomial with coefficients
*              in [-(GAMMA1 - 1), GAMMA1].
*
* Arguments:   - uint8_t *r: pointer to output byte array with at least
*                            POLYZ_PACKEDBYTES bytes
*              - const poly *a: pointer to input polynomial
**************************************************/
void polyz_pack_mod(uint8_t *r, const poly_instance_t *a)
{
  unsigned int i;
  int32_t t[4];

#if GAMMA1 == (1 << 17)
  for(i = 0; i < N/4; ++i) {
    t[0] = GAMMA1 - a->coeffs[4*i+0];
    if (t[0] < 0)
        t[0] = t[0] + Q;
    t[1] = GAMMA1 - a->coeffs[4*i+1];
    if (t[1] < 0)
        t[1] = t[1] + Q;
    t[2] = GAMMA1 - a->coeffs[4*i+2];
    if (t[2] < 0)
        t[2] = t[2] + Q;
    t[3] = GAMMA1 - a->coeffs[4*i+3];
    if (t[3] < 0)
        t[3] = t[3] + Q;

    r[9*i+0]  = t[0];
    r[9*i+1]  = t[0] >> 8;
    r[9*i+2]  = t[0] >> 16;
    r[9*i+2] |= t[1] << 2;
    r[9*i+3]  = t[1] >> 6;
    r[9*i+4]  = t[1] >> 14;
    r[9*i+4] |= t[2] << 4;
    r[9*i+5]  = t[2] >> 4;
    r[9*i+6]  = t[2] >> 12;
    r[9*i+6] |= t[3] << 6;
    r[9*i+7]  = t[3] >> 2;
    r[9*i+8]  = t[3] >> 10;
  }
#elif GAMMA1 == (1 << 19)
  for(i = 0; i < N/2; ++i) {
    t[0] = GAMMA1 - a->coeffs[2*i+0];
    if (t[0] < 0)
        t[0] = t[0] + Q;
    t[1] = GAMMA1 - a->coeffs[2*i+1];
    if (t[1] < 0)
        t[1] = t[1] + Q;

    r[5*i+0]  = t[0];
    r[5*i+1]  = t[0] >> 8;
    r[5*i+2]  = t[0] >> 16;
    r[5*i+2] |= t[1] << 4;
    r[5*i+3]  = t[1] >> 4;
    r[5*i+4]  = t[1] >> 12;
  }
#endif
}

/*************************************************
* Name:        polyz_unpack
*
* Description: Unpack polynomial z with coefficients
*              in [-(GAMMA1 - 1), GAMMA1].
*
* Arguments:   - poly *r: pointer to output polynomial
*              - const uint8_t *a: byte array with bit-packed polynomial
**************************************************/
void polyz_unpack(poly_instance_t *r, const uint8_t *a)
{
  unsigned int i;

#if GAMMA1 == (1 << 17)
  for(i = 0; i < N/4; ++i) {
    r->coeffs[4*i+0]  = a[9*i+0];
    r->coeffs[4*i+0] |= (uint32_t)a[9*i+1] << 8;
    r->coeffs[4*i+0] |= (uint32_t)a[9*i+2] << 16;
    r->coeffs[4*i+0] &= 0x3FFFF;

    r->coeffs[4*i+1]  = a[9*i+2] >> 2;
    r->coeffs[4*i+1] |= (uint32_t)a[9*i+3] << 6;
    r->coeffs[4*i+1] |= (uint32_t)a[9*i+4] << 14;
    r->coeffs[4*i+1] &= 0x3FFFF;

    r->coeffs[4*i+2]  = a[9*i+4] >> 4;
    r->coeffs[4*i+2] |= (uint32_t)a[9*i+5] << 4;
    r->coeffs[4*i+2] |= (uint32_t)a[9*i+6] << 12;
    r->coeffs[4*i+2] &= 0x3FFFF;

    r->coeffs[4*i+3]  = a[9*i+6] >> 6;
    r->coeffs[4*i+3] |= (uint32_t)a[9*i+7] << 2;
    r->coeffs[4*i+3] |= (uint32_t)a[9*i+8] << 10;
    r->coeffs[4*i+3] &= 0x3FFFF;

    r->coeffs[4*i+0] = GAMMA1 - r->coeffs[4*i+0];
    r->coeffs[4*i+1] = GAMMA1 - r->coeffs[4*i+1];
    r->coeffs[4*i+2] = GAMMA1 - r->coeffs[4*i+2];
    r->coeffs[4*i+3] = GAMMA1 - r->coeffs[4*i+3];
  }
#elif GAMMA1 == (1 << 19)
  for(i = 0; i < N/2; ++i) {
    r->coeffs[2*i+0]  = a[5*i+0];
    r->coeffs[2*i+0] |= (uint32_t)a[5*i+1] << 8;
    r->coeffs[2*i+0] |= (uint32_t)a[5*i+2] << 16;
    r->coeffs[2*i+0] &= 0xFFFFF;

    r->coeffs[2*i+1]  = a[5*i+2] >> 4;
    r->coeffs[2*i+1] |= (uint32_t)a[5*i+3] << 4;
    r->coeffs[2*i+1] |= (uint32_t)a[5*i+4] << 12;
    r->coeffs[2*i+0] &= 0xFFFFF;

    r->coeffs[2*i+0] = GAMMA1 - r->coeffs[2*i+0];
    r->coeffs[2*i+1] = GAMMA1 - r->coeffs[2*i+1];
  }
#endif
}

/*************************************************
* Name:        polyw1_pack
*
* Description: Bit-pack polynomial w1 with coefficients in [0,15] or [0,43].
*              Input coefficients are assumed to be standard representatives.
*
* Arguments:   - uint8_t *r: pointer to output byte array with at least
*                            POLYW1_PACKEDBYTES bytes
*              - const poly *a: pointer to input polynomial
**************************************************/
void polyw1_pack(uint8_t *r, const poly_instance_t *a)
{
  unsigned int i;

#if GAMMA2 == (Q-1)/88
  for(i = 0; i < N/4; ++i) {
    r[3*i+0]  = a->coeffs[4*i+0];
    r[3*i+0] |= a->coeffs[4*i+1] << 6;
    r[3*i+1]  = a->coeffs[4*i+1] >> 2;
    r[3*i+1] |= a->coeffs[4*i+2] << 4;
    r[3*i+2]  = a->coeffs[4*i+2] >> 4;
    r[3*i+2] |= a->coeffs[4*i+3] << 2;
  }
#elif GAMMA2 == (Q-1)/32
  for(i = 0; i < N/2; ++i)
    r[i] = a->coeffs[2*i+0] | (a->coeffs[2*i+1] << 4);
#endif
}

void polyt1_unpack(poly_instance_t *r, const uint8_t *a)
{
  unsigned int i;

  for(i = 0; i < N/4; ++i) {
    r->coeffs[4*i+0] = ((a[5*i+0] >> 0) | ((uint32_t)a[5*i+1] << 8)) & 0x3FF;
    r->coeffs[4*i+1] = ((a[5*i+1] >> 2) | ((uint32_t)a[5*i+2] << 6)) & 0x3FF;
    r->coeffs[4*i+2] = ((a[5*i+2] >> 4) | ((uint32_t)a[5*i+3] << 4)) & 0x3FF;
    r->coeffs[4*i+3] = ((a[5*i+3] >> 6) | ((uint32_t)a[5*i+4] << 2)) & 0x3FF;
  }
}

void pack_pk(uint8_t pk[CRYPTO_PUBLICKEYBYTES],
             const uint8_t rho[SEEDBYTES],
             const polyveck *t1)
{
  unsigned int i;

  for(i = 0; i < SEEDBYTES; ++i)
    pk[i] = rho[i];
  pk += SEEDBYTES;

  for(i = 0; i < K; ++i)
    polyt1_pack(pk + i*POLYT1_PACKEDBYTES, &t1->vec[i]);
}

void pack_sk(uint8_t sk[CRYPTO_SECRETKEYBYTES],
             const uint8_t rho[SEEDBYTES],
             const uint8_t tr[CRHBYTES],
             const uint8_t key[SEEDBYTES],
             const polyveck *t0,
             const polyvecl *s1,
             const polyveck *s2)
{
  unsigned int i;

  for(i = 0; i < SEEDBYTES; ++i)
    sk[i] = rho[i];
  sk += SEEDBYTES;

  for(i = 0; i < SEEDBYTES; ++i)
    sk[i] = key[i];
  sk += SEEDBYTES;

  for(i = 0; i < CRHBYTES; ++i)
    sk[i] = tr[i];
  sk += CRHBYTES;

  for(i = 0; i < L; ++i)
    polyeta_pack(sk + i*POLYETA_PACKEDBYTES, &s1->vec[i]);
  sk += L*POLYETA_PACKEDBYTES;

  for(i = 0; i < K; ++i)
    polyeta_pack(sk + i*POLYETA_PACKEDBYTES, &s2->vec[i]);
  sk += K*POLYETA_PACKEDBYTES;

  for(i = 0; i < K; ++i)
    polyt0_pack(sk + i*POLYT0_PACKEDBYTES, &t0->vec[i]);
}

void unpack_sk(uint8_t rho[SEEDBYTES],
               uint8_t tr[CRHBYTES],
               uint8_t key[SEEDBYTES],
               polyveck *t0,
               polyvecl *s1,
               polyveck *s2,
               const uint8_t sk[CRYPTO_SECRETKEYBYTES])
{
  unsigned int i;

  for(i = 0; i < SEEDBYTES; ++i)
    rho[i] = sk[i];
  sk += SEEDBYTES;

  for(i = 0; i < SEEDBYTES; ++i)
    key[i] = sk[i];
  sk += SEEDBYTES;

  for(i = 0; i < CRHBYTES; ++i)
    tr[i] = sk[i];
  sk += CRHBYTES;

  for(i=0; i < L; ++i)
    polyeta_unpack(&s1->vec[i], sk + i*POLYETA_PACKEDBYTES);
  sk += L*POLYETA_PACKEDBYTES;

  for(i=0; i < K; ++i)
    polyeta_unpack_neg(&s2->vec[i], sk + i*POLYETA_PACKEDBYTES);
  sk += K*POLYETA_PACKEDBYTES;

  for(i=0; i < K; ++i)
    polyt0_unpack(&t0->vec[i], sk + i*POLYT0_PACKEDBYTES);
}

void pack_sig(uint8_t sig[CRYPTO_BYTES],
              const uint8_t c[SEEDBYTES],
              const polyvecl *z,
              const polyveck *h)
{
  unsigned int i, j, k;

  for(i=0; i < SEEDBYTES; ++i)
    sig[i] = c[i];
  sig += SEEDBYTES;

  for(i = 0; i < L; ++i)
      polyz_pack_mod(sig + i*POLYZ_PACKEDBYTES, &z->vec[i]);
  sig += L*POLYZ_PACKEDBYTES;

  /* Encode h */
  for(i = 0; i < OMEGA + K; ++i)
    sig[i] = 0;

  k = 0;
  for(i = 0; i < K; ++i) {
    for(j = 0; j < N; ++j)
      if(h->vec[i].coeffs[j] != 0)
        sig[k++] = j;

    sig[OMEGA + i] = k;
  }
}

void unpack_pk(uint8_t rho[SEEDBYTES],
               polyveck *t1,
               const uint8_t pk[CRYPTO_PUBLICKEYBYTES])
{
  unsigned int i;

  for(i = 0; i < SEEDBYTES; ++i)
    rho[i] = pk[i];
  pk += SEEDBYTES;

  for(i = 0; i < K; ++i)
    polyt1_unpack_neg(&t1->vec[i], pk + i*POLYT1_PACKEDBYTES);
}

int unpack_sig(uint8_t c[SEEDBYTES],
               polyvecl *z,
               polyveck *h,
               const uint8_t sig[CRYPTO_BYTES])
{
  unsigned int i, j, k;

  for(i = 0; i < SEEDBYTES; ++i)
    c[i] = sig[i];
  sig += SEEDBYTES;

  for(i = 0; i < L; ++i)
    polyz_unpack(&z->vec[i], sig + i*POLYZ_PACKEDBYTES);
  sig += L*POLYZ_PACKEDBYTES;

  /* Decode h */
  k = 0;
  for(i = 0; i < K; ++i) {
    for(j = 0; j < N; ++j)
      h->vec[i].coeffs[j] = 0;

    if(sig[OMEGA + i] < k || sig[OMEGA + i] > OMEGA)
      return 1;

    for(j = k; j < sig[OMEGA + i]; ++j) {
      /* Coefficients are ordered for strong unforgeability */
      if(j > k && sig[j] <= sig[j-1]) return 1;
      h->vec[i].coeffs[sig[j]] = 1;
    }

    k = sig[OMEGA + i];
  }

  /* Extra indices are zero for strong unforgeability */
  for(j = k; j < OMEGA; ++j)
    if(sig[j])
      return 1;

  return 0;
}
