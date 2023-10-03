/*******************************************************************************
 * Copyright 2019-2020 Microchip FPGA Embedded Systems Solution.
 *
 * SPDX-License-Identifier: MIT
 *
 * MPFS HAL Embedded Software example
 *
 */
/*******************************************************************************
 *
 * Code running on U54 second hart
 *
 */
#include <stdio.h>
#include <string.h>
#include "mpfs_hal/mss_hal.h"
#include "inc/common.h"

#ifndef SIFIVE_HIFIVE_UNLEASHED
#include "drivers/mss/mss_mmuart/mss_uart.h"
#else
#include "drivers/FU540_uart/FU540_uart.h"
#endif

volatile uint32_t count_sw_ints_h2 = 0U;

/* Main function for the HART2(U54_2 processor).
 * Application code running on HART2 is placed here
 *
 * The HART2 goes into WFI. HART0 brings it out of WFI when it raises the first
 * Software interrupt to this HART
 */
void u54_2(void)
{
    uint64_t mcycle_start = 0U;
    uint64_t mcycle_end = 0U;
    uint64_t delta_mcycle = 0U;
    uint8_t info_string[100];
    uint64_t hartid = read_csr(mhartid);
    volatile uint32_t icount = 0U;
    HLS_DATA* hls = (HLS_DATA*)(uintptr_t)get_tp_reg();
#ifdef  MPFS_HAL_SHARED_MEM_ENABLED
    HART_SHARED_DATA * hart_share = (HART_SHARED_DATA *)hls->shared_mem;
#endif

    /*Clear pending software interrupt in case there was any.
     Enable only the software interrupt so that the E51 core can bring this core
     out of WFI by raising a software interrupt.*/
    clear_soft_interrupt();
    set_csr(mie, MIP_MSIP);

    /* put this hart into WFI. */
    do
    {
        __asm("wfi");
    }while(0 == (read_csr(mip) & MIP_MSIP));

    /* The hart is out of WFI, clear the SW interrupt. Hear onwards Application
       can enable and use any interrupts as required */
    clear_soft_interrupt();
    __enable_irq();
#if KYBER_K == 2
    /**************indcpa_keypair**************/
    for (int i = 0; i < TEST_NUM_KEY; i++) {
        /* Expand matrix and Sample short vectors s and e */
        poly_uniform(&hart_share->a[0].vec[1], hart_share->publicseed, 1, 0);
        poly_getnoise_eta1(&hart_share->skpv.vec[1], hart_share->noiseseed, 1);

        __asm("wfi");

        /* pack_sk, pack_pk */
        poly_tobytes(hart_share->sk+KYBER_POLYBYTES, &hart_share->skpv.vec[1]);

        __asm("wfi");
    }

    /**************indcpa_enc1**************/
    for (int i = 0; i < TEST_NUM_ENC; i++) {
        /* Unpack_pk, Expand matrix and Sample k, sp, ep, epp */
        poly_getnoise_eta1(&hart_share->sp.vec[0], hart_share->coins, 0);
        poly_getnoise_eta1(&hart_share->sp.vec[1], hart_share->coins, 1);
        poly_getnoise_eta2(&hart_share->e.vec[1], hart_share->coins, 3);

        __asm("wfi");

        /* pack_ciphertext */
        polyveci_compress(hart_share->c, &hart_share->bp, 0);

        __asm("wfi");
    }

    /**************indcpa_dec**************/
    for (int i = 0; i < TEST_NUM_DEC; i++) {
        /* unpack_ciphertext, unpack_sk */
        poly_decompress(&hart_share->k, hart_share->c+KYBER_POLYVECCOMPRESSEDBYTES);

        __asm("wfi");

        /**************indcpa_enc2**************/

        /* Unpack_pk, Expand matrix and Sample k, sp, ep, epp */
        poly_getnoise_eta1(&hart_share->sp.vec[0], hart_share->coins, 0);
        poly_getnoise_eta1(&hart_share->sp.vec[1], hart_share->coins, 1);
        poly_getnoise_eta2(&hart_share->e.vec[1], hart_share->coins, 3);

        __asm("wfi");

        /* pack_ciphertext */
        polyveci_compress(hart_share->cmp, &hart_share->bp, 0);

        __asm("wfi");
    }
#elif KYBER_K == 3
    /**************indcpa_keypair**************/
    for (int i = 0; i < TEST_NUM_KEY; i++) {
        /* Expand matrix and Sample short vectors s and e */
        poly_uniform(&hart_share->a[0].vec[0], hart_share->publicseed, 0, 0);
        poly_uniform(&hart_share->a[0].vec[1], hart_share->publicseed, 1, 0);
        poly_uniform(&hart_share->a[0].vec[2], hart_share->publicseed, 2, 0);

        __asm("wfi");

        /* pack_sk, pack_pk */
        poly_tobytes(hart_share->sk+2*KYBER_POLYBYTES, &hart_share->skpv.vec[2]);
        poly_tobytes(hart_share->pk, &hart_share->pkpv.vec[0]);

        __asm("wfi");
    }

    /**************indcpa_enc1**************/
    for (int i = 0; i < TEST_NUM_ENC; i++) {
        /* Unpack_pk, Expand matrix and Sample k, sp, ep, epp */
        poly_uniform(&hart_share->a[0].vec[1], hart_share->pk+KYBER_POLYVECBYTES, 0, 1);
        poly_uniform(&hart_share->a[0].vec[2], hart_share->pk+KYBER_POLYVECBYTES, 0, 2);
        poly_uniform(&hart_share->a[1].vec[0], hart_share->pk+KYBER_POLYVECBYTES, 1, 0);
        poly_uniform(&hart_share->a[1].vec[1], hart_share->pk+KYBER_POLYVECBYTES, 1, 1);

        __asm("wfi");

        /* pack_ciphertext */
        polyveci_compress(hart_share->c, &hart_share->bp, 0);

        __asm("wfi");
    }

    /**************indcpa_dec**************/
    for (int i = 0; i < TEST_NUM_DEC; i++) {
        /* unpack_ciphertext, unpack_sk */
        polyveci_decompress(&hart_share->bp, hart_share->c+2*320, 2);
        poly_decompress(&hart_share->k, hart_share->c+KYBER_POLYVECCOMPRESSEDBYTES);

        __asm("wfi");

        /**************indcpa_enc2**************/

        /* Unpack_pk, Expand matrix and Sample k, sp, ep, epp */
        poly_uniform(&hart_share->a[0].vec[1], hart_share->pk+KYBER_POLYVECBYTES, 0, 1);
        poly_uniform(&hart_share->a[0].vec[2], hart_share->pk+KYBER_POLYVECBYTES, 0, 2);
        poly_uniform(&hart_share->a[1].vec[0], hart_share->pk+KYBER_POLYVECBYTES, 1, 0);
        poly_uniform(&hart_share->a[1].vec[1], hart_share->pk+KYBER_POLYVECBYTES, 1, 1);

        __asm("wfi");

        /* pack_ciphertext */
        polyveci_compress(hart_share->cmp, &hart_share->bp, 0);

        __asm("wfi");
    }
#elif KYBER_K == 4
    /**************indcpa_keypair**************/
    for (int i = 0; i < TEST_NUM_KEY; i++) {
        /* Expand matrix and Sample short vectors s and e */
        poly_uniform(&hart_share->a[0].vec[1], hart_share->publicseed, 1, 0);
        poly_uniform(&hart_share->a[1].vec[0], hart_share->publicseed, 0, 1);
        poly_uniform(&hart_share->a[1].vec[1], hart_share->publicseed, 1, 1);
        poly_uniform(&hart_share->a[1].vec[2], hart_share->publicseed, 2, 1);
        poly_uniform(&hart_share->a[1].vec[3], hart_share->publicseed, 3, 1);

        __asm("wfi");

        /* pack_sk, pack_pk */
        poly_tobytes(hart_share->sk+2*KYBER_POLYBYTES, &hart_share->skpv.vec[2]);
        poly_tobytes(hart_share->sk+3*KYBER_POLYBYTES, &hart_share->skpv.vec[3]);

        __asm("wfi");
    }

    /**************indcpa_enc1**************/
    for (int i = 0; i < TEST_NUM_ENC; i++) {
        /* Unpack_pk, Expand matrix and Sample k, sp, ep, epp */
        poly_uniform(&hart_share->a[1].vec[0], hart_share->pk+KYBER_POLYVECBYTES, 1, 0);
        poly_uniform(&hart_share->a[1].vec[1], hart_share->pk+KYBER_POLYVECBYTES, 1, 1);
        poly_uniform(&hart_share->a[1].vec[2], hart_share->pk+KYBER_POLYVECBYTES, 1, 2);
        poly_uniform(&hart_share->a[1].vec[3], hart_share->pk+KYBER_POLYVECBYTES, 1, 3);
        poly_getnoise_eta2(&hart_share->e.vec[0], hart_share->coins, 4);
        poly_getnoise_eta2(&hart_share->e.vec[1], hart_share->coins, 5);
        poly_getnoise_eta1(&hart_share->sp.vec[3], hart_share->coins, 3);

        __asm("wfi");

        /* pack_ciphertext */
        polyveci_compress(hart_share->c, &hart_share->bp, 0);

        __asm("wfi");
    }

    /**************indcpa_dec**************/
    for (int i = 0; i < TEST_NUM_DEC; i++) {
        /* unpack_ciphertext, unpack_sk */
        polyveci_decompress(&hart_share->bp, hart_share->c+2*352, 2);
        polyveci_decompress(&hart_share->bp, hart_share->c+3*352, 3);

        __asm("wfi");

        /**************indcpa_enc2**************/

        /* Unpack_pk, Expand matrix and Sample k, sp, ep, epp */
        poly_uniform(&hart_share->a[1].vec[0], hart_share->pk+KYBER_POLYVECBYTES, 1, 0);
        poly_uniform(&hart_share->a[1].vec[1], hart_share->pk+KYBER_POLYVECBYTES, 1, 1);
        poly_uniform(&hart_share->a[1].vec[2], hart_share->pk+KYBER_POLYVECBYTES, 1, 2);
        poly_uniform(&hart_share->a[1].vec[3], hart_share->pk+KYBER_POLYVECBYTES, 1, 3);
        poly_getnoise_eta2(&hart_share->e.vec[0], hart_share->coins, 4);
        poly_getnoise_eta2(&hart_share->e.vec[1], hart_share->coins, 5);
        poly_getnoise_eta1(&hart_share->sp.vec[3], hart_share->coins, 3);

        __asm("wfi");

        /* pack_ciphertext */
        polyveci_compress(hart_share->cmp, &hart_share->bp, 0);

        __asm("wfi");
    }
#endif
}

/* HART2 Software interrupt handler */
void Software_h2_IRQHandler(void)
{
    uint64_t hart_id = read_csr(mhartid);
    count_sw_ints_h2++;
}
