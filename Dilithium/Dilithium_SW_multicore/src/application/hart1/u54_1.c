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
#include "hal/hal.h"
#include "inc/common.h"

#ifndef SIFIVE_HIFIVE_UNLEASHED
#include "drivers/mss/mss_mmuart/mss_uart.h"
#include "drivers/mss/mss_pdma/mss_pdma.h"
#else
#include "drivers/FU540_uart/FU540_uart.h"
#endif

HART_SHARED_DATA * hart_share;
volatile uint32_t count_sw_ints_h1 = 0U;
const uint8_t *rho, *rhoprime, *key;
uint64_t mcycle_start, mcycle_end, delta_mcycle, delta_mcycle1, delta_mcycle2;
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
    hart_share = (HART_SHARED_DATA *)hls->shared_mem;

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

    /******** Dilithium test code ********/
    int                 ret_val = 0;
    _Alignas(8) unsigned char m[] = {0xd8, 0x1c, 0x4d, 0x8d, 0x73, 0x4f, 0xcb, 0xfb,
            0xea, 0xde, 0x3d, 0x3f, 0x8a, 0x03, 0x9f, 0xaa, 0x2a, 0x2c, 0x99, 0x57,
            0xe8, 0x35, 0xad, 0x55, 0xb2, 0x2e, 0x75, 0xbf, 0x57, 0xbb, 0x55, 0x6a, 0xc8};
    _Alignas(8) unsigned char *m1;
    size_t              mlen, smlen, mlen1;

    mlen = 33;
    //randombytes(m, mlen);
    hart_share->sk = (unsigned char *)calloc(CRYPTO_SECRETKEYBYTES, sizeof(unsigned char));
    hart_share->pk = (unsigned char *)calloc(CRYPTO_PUBLICKEYBYTES, sizeof(unsigned char));
    hart_share->sm = (unsigned char *)calloc(mlen+CRYPTO_BYTES, sizeof(unsigned char));
    m1 = (unsigned char *)calloc(mlen+CRYPTO_BYTES, sizeof(unsigned char));

    pdma_init();

    delta_mcycle = 0;
    delta_mcycle1 = 0;
    delta_mcycle2 = 0;
    for (int i = 0; i < TEST_NUM; i++) {
        // Generate the public/private keypair
        mcycle_start = readmcycle();
        ret_val |= crypto_sign_keypair(hart_share->pk, hart_share->sk);
        mcycle_end = readmcycle();
        delta_mcycle += (mcycle_end - mcycle_start);

        // Computes signature
        mcycle_start = readmcycle();
        ret_val |= crypto_sign(hart_share->sm, &smlen, m, mlen, hart_share->sk);
        mcycle_end = readmcycle();
        delta_mcycle1 += (mcycle_end - mcycle_start);

        // Verify signed message
        mcycle_start = readmcycle();
        ret_val |= crypto_sign_open(m1, &mlen1, hart_share->sm, smlen, hart_share->pk);
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
        sprintf(info_string, "crypto_sign_open returned bad 'mlen': Got <%ld>, expected <%ld>\r\n", mlen1, mlen);
        MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
    }
    if ( memcmp(m, m1, mlen) ) {
        sprintf(info_string, "crypto_sign_open returned bad 'm' value\r\n");
        MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
    }

#if 0
  for (int i = 0; i < mlen+CRYPTO_BYTES; i++) {
      if ((i+1) % 8 == 0 || i == mlen+CRYPTO_BYTES-1)
          sprintf(info_string, "%02x\r\n", hart_share->sm[i]);
      else
          sprintf(info_string, "%02x", hart_share->sm[i]);
      MSS_UART_polled_tx(&g_mss_uart0_lo, info_string, strlen(info_string));
  }
#endif

    free(hart_share->sk);
    free(hart_share->pk);
    free(hart_share->sm);
    free(m1);

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
