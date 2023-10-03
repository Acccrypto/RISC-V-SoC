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
#include "mpfs_hal/mss_hal.h"
#include "hal/hal.h"
#include "inc/common.h"
#include "kem.h"
#include "fips202.h"
#include "indcpa.h"

#ifndef SIFIVE_HIFIVE_UNLEASHED
#include "drivers/mss/mss_mmuart/mss_uart.h"
#include "drivers/mss/mss_pdma/mss_pdma.h"
#else
#include "drivers/FU540_uart/FU540_uart.h"
#endif

#define TEST_NUM_KEY 1
#define TEST_NUM_ENC 1
#define TEST_NUM_DEC 1

volatile uint32_t count_sw_ints_h1 = 0U;
uint64_t mcycle_start, mcycle_end, delta_mcycle;
uint64_t total_bytes;
int sign_end = 0;

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
    PLIC_init();
    __enable_irq();

    (void)mss_config_clk_rst(MSS_PERIPH_FIC0, (uint8_t)hartid, PERIPHERAL_ON);
    (void)mss_config_clk_rst(MSS_PERIPH_FIC3, (uint8_t)hartid, PERIPHERAL_ON);
    SYSREG->SOFT_RESET_CR   &= (uint32_t)~(SOFT_RESET_CR_FPGA_MASK);

    PLIC_SetPriority_Threshold(0);
    PLIC_SetPriority(FABRIC_F2H_2_PLIC, 1);
    PLIC_SetPriority(DMA_CH0_DONE_IRQn, 2);
    PLIC_SetPriority(DMA_CH0_ERR_IRQn, 2);
    PLIC_SetPriority(DMA_CH1_DONE_IRQn, 3);
    PLIC_SetPriority(DMA_CH1_ERR_IRQn, 3);

    PLIC_EnableIRQ(FABRIC_F2H_2_PLIC);
    PLIC_EnableIRQ(DMA_CH0_DONE_IRQn);
    PLIC_EnableIRQ(DMA_CH0_ERR_IRQn);
    PLIC_EnableIRQ(DMA_CH1_DONE_IRQn);
    PLIC_EnableIRQ(DMA_CH1_ERR_IRQn);

    /******** Kyber test code ********/
    int                 ret_val;
    unsigned char       pk[KYBER_PUBLICKEYBYTES], sk[KYBER_SECRETKEYBYTES];
    unsigned char       ct[KYBER_CIPHERTEXTBYTES], ss[KYBER_SSBYTES], ss1[KYBER_SSBYTES];

    // Generates public and private key
    ret_val = 0;
    delta_mcycle = 0;
    mcycle_start = readmcycle();
    for (int i = 0; i < TEST_NUM_KEY; i++) {
        ret_val |= crypto_kem_keypair(pk, sk);
    }
    mcycle_end = readmcycle();
    delta_mcycle = (mcycle_end - mcycle_start) / TEST_NUM_KEY;
    //delta_mcycle = delta_mcycle / TEST_NUM_KEY;
    sprintf(info_string, "crypto_kem_keypair returned <%d>\r\nthe time is %ld clock cycles\r\n", ret_val, delta_mcycle);
    MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));

    // Generates cipher text and shared
    delta_mcycle = 0;
    mcycle_start = readmcycle();
    for (int i = 0; i < TEST_NUM_ENC; i++) {
        ret_val |= crypto_kem_enc(ct, ss, pk);
    }
    mcycle_end = readmcycle();
    delta_mcycle = (mcycle_end - mcycle_start) / TEST_NUM_ENC;
    //delta_mcycle = delta_mcycle / TEST_NUM_ENC;
    sprintf(info_string, "crypto_kem_enc returned <%d>\r\nthe time is %ld clock cycles\r\n", ret_val, delta_mcycle);
    MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));

#if 0
    for (int i = 0; i < KYBER_CIPHERTEXTBYTES; i++) {
        if ((i+1) % 8 == 0)
            sprintf(info_string, "%02x\r\n", ct[i]);
        else
            sprintf(info_string, "%02x", ct[i]);
        spinlock(&hart_share->mutex_uart0);
        MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
        spinunlock(&hart_share->mutex_uart0);
    }
#endif

    // Generates shared secret for given cipher text and private key
    delta_mcycle = 0;
    mcycle_start = readmcycle();
    for (int i = 0; i < TEST_NUM_DEC; i++) {
        ret_val |= crypto_kem_dec(ss1, ct, sk);
    }
    mcycle_end = readmcycle();
    delta_mcycle = (mcycle_end - mcycle_start) / TEST_NUM_DEC;
    //delta_mcycle = delta_mcycle / TEST_NUM_DEC;
    sprintf(info_string, "crypto_kem_dec returned <%d>\r\nthe time is %ld clock cycles\r\n", ret_val, delta_mcycle);
    MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
    if ( memcmp(ss, ss1, KYBER_SSBYTES) ) {
        sprintf(info_string, "crypto_kem_dec returned bad 'ss' value\r\n");
        MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
    }

#if 0
    for (int i = 0; i < KYBER_SSBYTES; i++) {
        if ((i+1) % 8 == 0)
            sprintf(info_string, "%02x\r\n", ss1[i]);
        else
            sprintf(info_string, "%02x", ss1[i]);
        MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
    }
#endif

#if 0
    unsigned char       hash_test[10000];
    randombytes(hash_test, 10000);

    total_bytes = 10000;
    mcycle_start = readmcycle();
    //shake128(hash_test, SHAKE128_RATE, hash_test, total_bytes);
    shake256(hash_test, SHAKE256_RATE, hash_test, total_bytes);
    //sha3_256(hash_test, hash_test, total_bytes);
    //sha3_512(hash_test, hash_test, total_bytes);
    mcycle_end = readmcycle();
    delta_mcycle = (mcycle_end - mcycle_start) / total_bytes;
    sprintf(info_string, "\r\nSHA-3 time is %ld clock cycles per byte\r\n", delta_mcycle);
    MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
#endif

}

/* HART1 Software interrupt handler */
void Software_h1_IRQHandler(void)
{
    uint64_t hart_id = read_csr(mhartid);
    count_sw_ints_h1++;
}

uint8_t fabric_f2h_2_plic_IRQHandler(void)
{
    sign_end = 1;

    return EXT_IRQ_KEEP_ENABLED;
}
