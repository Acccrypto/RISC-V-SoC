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
 * Code running on U54 first hart
 *
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <hart1/sign.h>
#include "mpfs_hal/mss_hal.h"
#include "inc/common.h"

#ifndef SIFIVE_HIFIVE_UNLEASHED
#include "drivers/mss/mss_mmuart/mss_uart.h"
#else
#include "drivers/FU540_uart/FU540_uart.h"
#endif

#define TEST_NUM 1000

volatile uint32_t count_sw_ints_h1 = 0U;
uint64_t mcycle_start, mcycle_end, delta_mcycle, delta_mcycle1, delta_mcycle2;

/* Main function for the HART1(U54_1 processor).
 * Application code running on HART1 is placed here
 *
 * The HART1 goes into WFI. HART0 brings it out of WFI when it raises the first
 * Software interrupt to this HART
 */
void u54_1(void)
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

    /* Put this hart into WFI. */
    do
    {
        __asm("wfi");
    }while(0 == (read_csr(mip) & MIP_MSIP));

    /* The hart is out of WFI, clear the SW interrupt. Hear onwards Application
       can enable and use any interrupts as required */
    clear_soft_interrupt();

    __enable_irq();
#if 0
#ifdef  MPFS_HAL_SHARED_MEM_ENABLED
    spinlock(&hart_share->mutex_uart0);
    MSS_UART_polled_tx_string(hart_share->g_mss_uart0_lo,
            "Hello World from u54 core 1 - hart1 running from DDR\r\n");
    spinunlock(&hart_share->mutex_uart0);
#endif

    while (1U)
    {
        icount++;
        if (0x100000U == icount)
        {
            icount = 0U;
            sprintf(info_string,"Hart %d\r\n", hartid);
#ifdef  MPFS_HAL_SHARED_MEM_ENABLED
            spinlock(&hart_share->mutex_uart0);
            MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
            spinunlock(&hart_share->mutex_uart0);
#endif
        }
    }
    /* never return */
#endif

    /******** Dilithium test code ********/
    unsigned char       pk[CRYPTO_PUBLICKEYBYTES], sk[CRYPTO_SECRETKEYBYTES];
    int                 ret_val = 0;
    unsigned char       m[33] = {0xd8, 0x1c, 0x4d, 0x8d, 0x73, 0x4f, 0xcb, 0xfb,
            0xea, 0xde, 0x3d, 0x3f, 0x8a, 0x03, 0x9f, 0xaa, 0x2a, 0x2c, 0x99, 0x57,
            0xe8, 0x35, 0xad, 0x55, 0xb2, 0x2e, 0x75, 0xbf, 0x57, 0xbb, 0x55, 0x6a, 0xc8};
    unsigned char       *sm, *m1;
    size_t              mlen, smlen, mlen1;

    mlen = 33;
    randombytes(m, mlen);
    sm = (unsigned char *)calloc(mlen+CRYPTO_BYTES, sizeof(unsigned char));
    m1 = (unsigned char *)calloc(mlen+CRYPTO_BYTES, sizeof(unsigned char));

    delta_mcycle = 0;
    delta_mcycle1 = 0;
    delta_mcycle2 = 0;
    for (int i = 0; i < TEST_NUM; i++) {
        // Generate the public/private keypair
        mcycle_start = readmcycle();
        ret_val |= crypto_sign_keypair(pk, sk);
        mcycle_end = readmcycle();
        delta_mcycle += (mcycle_end - mcycle_start);
        // Computes signature
        mcycle_start = readmcycle();
        ret_val |= crypto_sign(sm, &smlen, m, mlen, sk);
        mcycle_end = readmcycle();
        delta_mcycle1 += (mcycle_end - mcycle_start);
        // Verify signed message
        mcycle_start = readmcycle();
        ret_val |= crypto_sign_open(m1, &mlen1, sm, smlen, pk);
        mcycle_end = readmcycle();
        delta_mcycle2 += (mcycle_end - mcycle_start);
    }
    delta_mcycle = delta_mcycle / TEST_NUM;
    delta_mcycle1 = delta_mcycle1 / TEST_NUM;
    delta_mcycle2 = delta_mcycle2 / TEST_NUM;

    sprintf(info_string, "crypto_sign_keypair returned <%d>\r\nthe time is %ld clock cycles\r\n", ret_val, delta_mcycle);
    MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));

    sprintf(info_string, "crypto_sign returned <%d>\r\nthe time is %ld clock cycles\r\n", ret_val, delta_mcycle1);
    MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));

    sprintf(info_string, "crypto_sign_open returned <%d>\r\nthe time is %ld clock cycles\r\n", ret_val, delta_mcycle2);
    MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
    if ( mlen != mlen1 ) {
        sprintf(info_string, "crypto_sign_open returned bad 'mlen': Got <%llu>, expected <%llu>\r\n", mlen1, mlen);
        MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
    }
    if ( memcmp(m, m1, mlen) ) {
        sprintf(info_string, "crypto_sign_open returned bad 'm' value\r\n");
        MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
    }

    free(sm);
    free(m1);

    return;
}

/* HART1 Software interrupt handler */
void Software_h1_IRQHandler(void)
{
    uint64_t hart_id = read_csr(mhartid);
    count_sw_ints_h1++;
}
