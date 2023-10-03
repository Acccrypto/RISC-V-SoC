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
 * Code running on U54 hart 4
 *
 */
#include <stdio.h>
#include <string.h>
#include "mpfs_hal/mss_hal.h"
#include "inc/common.h"
#include "hart1/poly.h"
#include "hart1/verify.h"

#ifndef SIFIVE_HIFIVE_UNLEASHED
#include "drivers/mss/mss_mmuart/mss_uart.h"
#else
#include "drivers/FU540_uart/FU540_uart.h"
#endif

volatile uint32_t count_sw_ints_h4 = 0U;

/* Main function for the HART4(U54_4 processor).
 * Application code running on HART4 is placed here
 *
 * The HART4 goes into WFI. HART0 brings it out of WFI when it raises the first
 * Software interrupt to this HART
 */
void u54_4(void)
{
    uint8_t info_string[100];
    uint64_t hartid = read_csr(mhartid);
    volatile uint32_t icount = 0U;
    HLS_DATA* hls = (HLS_DATA*)(uintptr_t)get_tp_reg();
#ifdef  MPFS_HAL_SHARED_MEM_ENABLED
    HART_SHARED_DATA * hart_share = (HART_SHARED_DATA *)hls->shared_mem;
#endif

    /* Clear pending software interrupt in case there was any.
       Enable only the software interrupt so that the E51 core can bring this
       core out of WFI by raising a software interrupt. */
    clear_soft_interrupt();
    set_csr(mie, MIP_MSIP);

    /*put this hart into WFI.*/
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
        poly_uniform(&hart_share->a[1].vec[1], hart_share->publicseed, 1, 1);
        poly_getnoise_eta1(&hart_share->e.vec[1], hart_share->noiseseed, 3);

        __asm("wfi");

        /* pack_sk, pack_pk */
        poly_tobytes(hart_share->pk+KYBER_POLYBYTES, &hart_share->pkpv.vec[1]);

        __asm("wfi");
    }

    /**************indcpa_enc1**************/
    for (int i = 0; i < TEST_NUM_ENC; i++) {
        /* Unpack_pk, Expand matrix and Sample k, sp, ep, epp */
        poly_frombytes(&hart_share->pkpv.vec[0], hart_share->pk);
        poly_frombytes(&hart_share->pkpv.vec[1], hart_share->pk+KYBER_POLYBYTES);

        __asm("wfi");
    }

    /**************indcpa_dec**************/
    for (int i = 0; i < TEST_NUM_DEC; i++) {
        /* unpack_ciphertext, unpack_sk */
        poly_frombytes(&hart_share->skpv.vec[1], hart_share->sk+KYBER_POLYBYTES);

        __asm("wfi");

        /**************indcpa_enc2**************/

        /* Unpack_pk, Expand matrix and Sample k, sp, ep, epp */
        poly_frombytes(&hart_share->pkpv.vec[0], hart_share->pk);
        poly_frombytes(&hart_share->pkpv.vec[1], hart_share->pk+KYBER_POLYBYTES);

        __asm("wfi");
    }
#elif KYBER_K == 3
    /**************indcpa_keypair**************/
    for (int i = 0; i < TEST_NUM_KEY; i++) {
        /* Expand matrix and Sample short vectors s and e */
        poly_uniform(&hart_share->a[2].vec[0], hart_share->publicseed, 0, 2);
        poly_uniform(&hart_share->a[2].vec[1], hart_share->publicseed, 1, 2);
        poly_uniform(&hart_share->a[2].vec[2], hart_share->publicseed, 2, 2);

        __asm("wfi");

        /* pack_sk, pack_pk */
        poly_tobytes(hart_share->pk+2*KYBER_POLYBYTES, &hart_share->pkpv.vec[2]);

        __asm("wfi");
    }

    /**************indcpa_enc1**************/
    for (int i = 0; i < TEST_NUM_ENC; i++) {
        /* Unpack_pk, Expand matrix and Sample k, sp, ep, epp */
        poly_getnoise_eta2(&hart_share->e.vec[2], hart_share->coins, 5);
        poly_frombytes(&hart_share->pkpv.vec[0], hart_share->pk);
        poly_frombytes(&hart_share->pkpv.vec[1], hart_share->pk+KYBER_POLYBYTES);
        poly_frombytes(&hart_share->pkpv.vec[2], hart_share->pk+2*KYBER_POLYBYTES);

        __asm("wfi");

        /* pack_ciphertext */
        polyveci_compress(hart_share->c+2*320, &hart_share->bp, 2);

        __asm("wfi");
    }

    /**************indcpa_dec**************/
    for (int i = 0; i < TEST_NUM_DEC; i++) {
        /* unpack_ciphertext, unpack_sk */
        poly_frombytes(&hart_share->skpv.vec[2], hart_share->sk+2*KYBER_POLYBYTES);

        __asm("wfi");

        /**************indcpa_enc2**************/

        /* Unpack_pk, Expand matrix and Sample k, sp, ep, epp */
        poly_getnoise_eta2(&hart_share->e.vec[2], hart_share->coins, 5);
        poly_frombytes(&hart_share->pkpv.vec[0], hart_share->pk);
        poly_frombytes(&hart_share->pkpv.vec[1], hart_share->pk+KYBER_POLYBYTES);
        poly_frombytes(&hart_share->pkpv.vec[2], hart_share->pk+2*KYBER_POLYBYTES);

        __asm("wfi");

        /* pack_ciphertext */
        polyveci_compress(hart_share->cmp+2*320, &hart_share->bp, 2);

        __asm("wfi");
    }
#elif KYBER_K == 4
    /**************indcpa_keypair**************/
    for (int i = 0; i < TEST_NUM_KEY; i++) {
        /* Expand matrix and Sample short vectors s and e */
        poly_uniform(&hart_share->a[0].vec[3], hart_share->publicseed, 3, 0);
        poly_uniform(&hart_share->a[3].vec[0], hart_share->publicseed, 0, 3);
        poly_uniform(&hart_share->a[3].vec[1], hart_share->publicseed, 1, 3);
        poly_uniform(&hart_share->a[3].vec[2], hart_share->publicseed, 2, 3);
        poly_uniform(&hart_share->a[3].vec[3], hart_share->publicseed, 3, 3);

        __asm("wfi");

        /* pack_sk, pack_pk */
        poly_tobytes(hart_share->pk+2*KYBER_POLYBYTES, &hart_share->pkpv.vec[2]);
        poly_tobytes(hart_share->pk+3*KYBER_POLYBYTES, &hart_share->pkpv.vec[3]);

        __asm("wfi");
    }

    /**************indcpa_enc1**************/
    for (int i = 0; i < TEST_NUM_ENC; i++) {
        /* Unpack_pk, Expand matrix and Sample k, sp, ep, epp */
        poly_uniform(&hart_share->a[3].vec[0], hart_share->pk+KYBER_POLYVECBYTES, 3, 0);
        poly_uniform(&hart_share->a[3].vec[1], hart_share->pk+KYBER_POLYVECBYTES, 3, 1);
        poly_uniform(&hart_share->a[3].vec[2], hart_share->pk+KYBER_POLYVECBYTES, 3, 2);
        poly_uniform(&hart_share->a[3].vec[3], hart_share->pk+KYBER_POLYVECBYTES, 3, 3);
        poly_frombytes(&hart_share->pkpv.vec[0], hart_share->pk);
        poly_frombytes(&hart_share->pkpv.vec[1], hart_share->pk+KYBER_POLYBYTES);
        poly_frombytes(&hart_share->pkpv.vec[2], hart_share->pk+2*KYBER_POLYBYTES);

        __asm("wfi");

        /* pack_ciphertext */
        polyveci_compress(hart_share->c+2*352, &hart_share->bp, 2);

        __asm("wfi");
    }

    /**************indcpa_dec**************/
    for (int i = 0; i < TEST_NUM_DEC; i++) {
        /* unpack_ciphertext, unpack_sk */
        poly_frombytes(&hart_share->skpv.vec[2], hart_share->sk+2*KYBER_POLYBYTES);
        poly_frombytes(&hart_share->skpv.vec[3], hart_share->sk+3*KYBER_POLYBYTES);

        __asm("wfi");

        /**************indcpa_enc2**************/

        /* Unpack_pk, Expand matrix and Sample k, sp, ep, epp */
        poly_uniform(&hart_share->a[3].vec[0], hart_share->pk+KYBER_POLYVECBYTES, 3, 0);
        poly_uniform(&hart_share->a[3].vec[1], hart_share->pk+KYBER_POLYVECBYTES, 3, 1);
        poly_uniform(&hart_share->a[3].vec[2], hart_share->pk+KYBER_POLYVECBYTES, 3, 2);
        poly_uniform(&hart_share->a[3].vec[3], hart_share->pk+KYBER_POLYVECBYTES, 3, 3);
        poly_frombytes(&hart_share->pkpv.vec[0], hart_share->pk);
        poly_frombytes(&hart_share->pkpv.vec[1], hart_share->pk+KYBER_POLYBYTES);
        poly_frombytes(&hart_share->pkpv.vec[2], hart_share->pk+2*KYBER_POLYBYTES);

        __asm("wfi");

        /* pack_ciphertext */
        polyveci_compress(hart_share->cmp+2*352, &hart_share->bp, 2);

        __asm("wfi");
    }
#endif
}

/* HART4 Software interrupt handler */
void Software_h4_IRQHandler(void)
{
    uint64_t hart_id = read_csr(mhartid);
    count_sw_ints_h4++;
}
