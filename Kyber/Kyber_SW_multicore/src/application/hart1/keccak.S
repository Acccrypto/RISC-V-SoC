/*
 * keccak.S
 *
 *  Created on: 2023年4月4日
 *      Author: wangt
 */

.section .text
    .globl loadR
    .globl storeR
    .globl state_init

state_init:
    fmv.d.x f0, zero
    fmv.d.x f1, zero
    fmv.d.x f2, zero
    fmv.d.x f3, zero
    fmv.d.x f4, zero
    fmv.d.x f5, zero
    fmv.d.x f6, zero
    fmv.d.x f7, zero
    fmv.d.x f8, zero
    fmv.d.x f9, zero
    fmv.d.x f10, zero
    fmv.d.x f11, zero
    fmv.d.x f12, zero
    fmv.d.x f13, zero
    fmv.d.x f14, zero
    fmv.d.x f15, zero
    fmv.d.x f16, zero
    fmv.d.x f17, zero
    fmv.d.x f18, zero
    fmv.d.x f19, zero
    fmv.d.x f20, zero
    fmv.d.x f21, zero
    fmv.d.x f22, zero
    fmv.d.x f23, zero
    fmv.d.x f24, zero
    ret

// a0: uint8_t *m, a1: r 
loadR:
    addi t0, zero, 72

    fmv.x.d a2, f0
    c.ld a3, 0(a0)
    fmv.x.d t1, f1
    c.ld a4, 8(a0)
    fmv.x.d t2, f2
    c.ld a5, 16(a0)
    c.xor a2, a3
    xor t1, t1, a4
    xor t2, t2, a5
    fmv.d.x f0, a2
    fmv.d.x f1, t1
    fmv.d.x f2, t2

    fmv.x.d a2, f3
    c.ld a3, 24(a0)
    fmv.x.d t1, f4
    c.ld a4, 32(a0)
    fmv.x.d t2, f5
    c.ld a5, 40(a0)
    c.xor a2, a3
    xor t1, t1, a4
    xor t2, t2, a5
    fmv.d.x f3, a2
    fmv.d.x f4, t1
    fmv.d.x f5, t2

    fmv.x.d a2, f6
    c.ld a3, 48(a0)
    fmv.x.d t1, f7
    c.ld a4, 56(a0)
    fmv.x.d t2, f8
    c.ld a5, 64(a0)
    c.xor a2, a3
    xor t1, t1, a4
    xor t2, t2, a5
    fmv.d.x f6, a2
    fmv.d.x f7, t1
    fmv.d.x f8, t2

    beq a1, t0, LDED
    addi t3, zero, 136

    fmv.x.d a2, f9
    c.ld a3, 72(a0)
    fmv.x.d t1, f10
    c.ld a4, 80(a0)
    fmv.x.d t2, f11
    c.ld a5, 88(a0)
    c.xor a2, a3
    xor t1, t1, a4
    xor t2, t2, a5
    fmv.d.x f9, a2
    fmv.d.x f10, t1
    fmv.d.x f11, t2

    fmv.x.d a2, f12
    c.ld a3, 96(a0)
    fmv.x.d t1, f13
    c.ld a4, 104(a0)
    fmv.x.d t2, f14
    c.ld a5, 112(a0)
    c.xor a2, a3
    xor t1, t1, a4
    xor t2, t2, a5
    fmv.d.x f12, a2
    fmv.d.x f13, t1
    fmv.d.x f14, t2

    fmv.x.d a2, f15
    c.ld a3, 120(a0)
    fmv.x.d a4, f16
    c.ld a5, 128(a0)
    c.xor a2, a3
    c.xor a4, a5
    fmv.d.x f15, a2
    fmv.d.x f16, a4

    beq a1, t3, LDED

    fmv.x.d a2, f17
    c.ld a3, 136(a0)
    fmv.x.d a4, f18
    c.ld a5, 144(a0)
    c.xor a2, a3
    c.xor a4, a5
    fmv.d.x f17, a2
    fmv.d.x f18, a4

    fmv.x.d a2, f19
    c.ld a3, 152(a0)
    fmv.x.d a4, f20
    c.ld a5, 160(a0)
    c.xor a2, a3
    c.xor a4, a5
    fmv.d.x f19, a2
    fmv.d.x f20, a4
LDED:
    ret

// a0: uint8_t *m, a1: r 
storeR:
    addi a2, zero, 72

    fsd f0, 0(a0)
    fsd f1, 8(a0)
    fsd f2, 16(a0)
    fsd f3, 24(a0)
    fsd f4, 32(a0)

    fsd f5, 40(a0)
    fsd f6, 48(a0)
    fsd f7, 56(a0)
    c.fsd f8, 64(a0)

    beq a1, a2, STED
    addi a3, zero, 136

    c.fsd f9, 72(a0)
    c.fsd f10, 80(a0)
    c.fsd f11, 88(a0)
    c.fsd f12, 96(a0)

    c.fsd f13, 104(a0)
    c.fsd f14, 112(a0)
    c.fsd f15, 120(a0)
    fsd f16, 128(a0)

    beq a1, a3, STED

    fsd f17, 136(a0)
    fsd f18, 144(a0)
    fsd f19, 152(a0)
    fsd f20, 160(a0)
STED:
    ret


// SPDX-License-Identifier: BSD-2-Clause
/*
 * Keccak-f[1600] RV64ID Implementation - State permutation
 * Copyright (C) 2019 Nick Kossifidis <mick@ics.forth.gr>
 */

#define KECCAK1600_LANE_BITS    64
#define KECCAK1600_NUM_ROUNDS   24  /* 12 + 2^log2(KECCAK1600_LANE_BITS) */

.data

.align 16,0
round_constants:

    .dword 0x8000000080008008
    .dword 0x0000000080000001
    .dword 0x8000000000008080
    .dword 0x8000000080008081
    .dword 0x800000008000000a
    .dword 0x000000000000800a
    .dword 0x8000000000000080
    .dword 0x8000000000008002
    .dword 0x8000000000008003
    .dword 0x8000000000008089
    .dword 0x800000000000008b
    .dword 0x000000008000808b
    .dword 0x000000008000000a
    .dword 0x0000000080008009
    .dword 0x0000000000000088
    .dword 0x000000000000008a
    .dword 0x8000000000008009
    .dword 0x8000000080008081
    .dword 0x0000000080000001
    .dword 0x000000000000808b
    .dword 0x8000000080008000
    .dword 0x800000000000808a
    .dword 0x0000000000008082
    .dword 0x0000000000000001

.text

/*********\
* HELPERS *
\*********/

/*
 * XOR five lanes a0, a1, a2, a3, a4
 */
.macro COLUMN_PARITY _a, _b, _c, _d, _e
    fmv.x.d a3, f\_a
    fmv.x.d a4, f\_b
    fmv.x.d a5, f\_c
    fmv.x.d t2, f\_d
    fmv.x.d t3, f\_e
    c.xor a0, a3
    c.xor a1, a4
    c.xor a2, a5
    xor t0, t0, t2
    xor t1, t1, t3
.endm

/*
 * Left-rotate a lane
 */
.macro ROTL_FOUR_LANE _times0 _times1 _times2 _times3
    slli t3, t0, \_times0
    slli t4, t1, \_times1
    slli t5, t2, \_times2
    slli t6, a5, \_times3
    srli t0, t0, KECCAK1600_LANE_BITS - \_times0
    srli t1, t1, KECCAK1600_LANE_BITS - \_times1
    srli t2, t2, KECCAK1600_LANE_BITS - \_times2
    c.srli a5, KECCAK1600_LANE_BITS - \_times3
    or  t0, t0, t3
    or  t1, t1, t4
    or  t2, t2, t5
    or  a5, a5, t6
.endm

/**********************\
* KECCAK STEP MAPPINGS *
\**********************/

/*
 * A Chi step on the plane
 */

 /*
 * Apply iota by xoring the
 * first lane of the first
 * plane, with the round
 * constant for this round
 *
 * a6 -> Round counter
 * a7 -> Pointer to round_constants
 */
 .macro CHI_IOTA
    fmv.x.d a0, f0
    fmv.x.d a1, f1
    fmv.x.d a2, f2
    fmv.x.d t0, f3
    fmv.x.d t1, f4

    slli    t4, a6, 3

    not a3, a0
    not a4, a1
    not t2, a2
    not t3, t0
    not a5, t1

    add t4, t4, a7

    c.and a3, a1
    c.and a4, a2
    and t2, t2, t0
    and t3, t3, t1
    c.and a5, a0

    ld  t5, 0(t4)

    xor a3, a3, t1
    c.xor a4, a0
    xor t2, t2, a1
    xor t3, t3, a2
    xor a5, a5, t0

    xor a4, a4, t5

    fmv.d.x f1, t2
    fmv.d.x f2, t3
    fmv.d.x f3, a5
    fmv.d.x f4, a3
    fmv.d.x f0, a4
.endm

.macro CHI _a _b _c _d _e
    fmv.x.d a0, f\_a
    fmv.x.d a1, f\_b
    fmv.x.d a2, f\_c
    fmv.x.d t0, f\_d
    fmv.x.d t1, f\_e

    not a3, a0
    not a4, a1
    not t2, a2
    not t3, t0
    not a5, t1

    c.and a3, a1
    c.and a4, a2
    and t2, t2, t0
    and t3, t3, t1
    c.and a5, a0

    xor a3, a3, t1
    c.xor a4, a0
    xor t2, t2, a1
    xor t3, t3, a2
    xor a5, a5, t0

    fmv.d.x f\_a, a4
    fmv.d.x f\_b, t2
    fmv.d.x f\_c, t3
    fmv.d.x f\_d, a5
    fmv.d.x f\_e, a3
.endm

/*************\
* ENTRY POINT *
\*************/

.align 8,0
.func KeccakF1600_StatePermute
.global KeccakF1600_StatePermute
KeccakF1600_StatePermute:
    li  a6, KECCAK1600_NUM_ROUNDS
    la  a7, round_constants

lp:
    /* C[i] = A[i] ^ A[i + 5] ^ A[i + 10] ^ A[i + 15] ^ A[i + 20] -> a0 - a4*/
    fmv.x.d a0, f0
    fmv.x.d a1, f1
    fmv.x.d a2, f2
    fmv.x.d t0, f3
    fmv.x.d t1, f4
    COLUMN_PARITY 5, 6, 7, 8, 9
    COLUMN_PARITY 10, 11, 12, 13, 14
    COLUMN_PARITY 15, 16, 17, 18, 19
    COLUMN_PARITY 20, 21, 22, 23, 24

    // rotl_lane(C[i], 1) -> t0, t1, t2, t3, a5
    slli a3, a0, 1
    slli t2, a1, 1
    slli t3, a2, 1
    slli t4, t0, 1
    srli a4, a0, 63
    srli a5, a1, 63
    srli t5, a2, 63
    srli t6, t0, 63
    c.or a3, a4
    or t2, t2, a5
    or t3, t3, t5
    or t4, t4, t6

    slli a4, t1, 1
    srli a5, t1, 63
    or t5, a4, a5

    xor a3, t0, a3  // D[4]
    xor a4, t1, t2  // D[0]
    xor a0, a0, t3  // D[1]
    xor a1, a1, t4  // D[2]
    xor a2, a2, t5  // D[3]

    /* Apply theta-rho-pli in-place */

    fmv.x.d t3, f0
    fmv.x.d t6, f1

    fmv.x.d t0, f6
    fmv.x.d t1, f9
    xor t3, t3, a4
    fmv.x.d t2, f22
    fmv.x.d a5, f14

    fmv.d.x f25, t6
    fmv.d.x f0, t3

    xor t0, t0, a0
    xor t1, t1, a3
    xor t2, t2, a1
    c.xor a5, a3

    ROTL_FOUR_LANE 44, 20, 61, 39

    fmv.d.x f1, t0
    fmv.d.x f6, t1
    fmv.d.x f9, t2
    fmv.d.x f22, a5

    fmv.x.d t0, f20
    fmv.x.d t1, f2
    fmv.x.d t2, f12
    fmv.x.d a5, f13

    xor t0, t0, a4
    xor t1, t1, a1
    xor t2, t2, a1
    c.xor a5, a2

    ROTL_FOUR_LANE 18, 62, 43, 25

    fmv.d.x f14, t0
    fmv.d.x f20, t1
    fmv.d.x f2, t2
    fmv.d.x f12, a5

    fmv.x.d t0, f19
    fmv.x.d t1, f23
    fmv.x.d t2, f15
    fmv.x.d a5, f4

    xor t0, t0, a3
    xor t1, t1, a2
    xor t2, t2, a4
    c.xor a5, a3

    ROTL_FOUR_LANE 8, 56, 41, 27

    fmv.d.x f13, t0
    fmv.d.x f19, t1
    fmv.d.x f23, t2
    fmv.d.x f15, a5

    fmv.x.d t0, f24
    fmv.x.d t1, f21
    fmv.x.d t2, f8
    fmv.x.d a5, f16

    xor t0, t0, a3
    xor t1, t1, a0
    xor t2, t2, a2
    c.xor a5, a0

    ROTL_FOUR_LANE 14, 2, 55, 45

    fmv.d.x f4, t0
    fmv.d.x f24, t1
    fmv.d.x f21, t2
    fmv.d.x f8, a5

    fmv.x.d t0, f5
    fmv.x.d t1, f3
    fmv.x.d t2, f18
    fmv.x.d a5, f17

    xor t0, t0, a4
    xor t1, t1, a2
    xor t2, t2, a2
    c.xor a5, a1

    ROTL_FOUR_LANE 36, 28, 21, 15

    fmv.d.x f16, t0
    fmv.d.x f5, t1
    fmv.d.x f3, t2
    fmv.d.x f18, a5

    fmv.x.d t0, f11
    fmv.x.d t1, f7
    fmv.x.d t2, f10
    fmv.x.d a5, f25

    xor t0, t0, a0
    xor t1, t1, a1
    xor t2, t2, a4
    c.xor a5, a0

    ROTL_FOUR_LANE 10, 6, 3, 1

    fmv.d.x f17, t0
    fmv.d.x f11, t1
    fmv.d.x f7, t2
    fmv.d.x f10, a5

    addi a6, a6, -1

    CHI_IOTA
    CHI 5 6 7 8 9
    CHI 10 11 12 13 14
    CHI 15 16 17 18 19
    CHI 20 21 22 23 24

    bne a6, zero, lp

    ret
.endfunc

.end
