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
 * Code running on E51
 *
 */

#include <stdio.h>
#include <string.h>
#include "mpfs_hal/mss_hal.h"
#include "inc/common.h"
#include "hart1/params.h"

#ifndef SIFIVE_HIFIVE_UNLEASHED
#include "drivers/mss/mss_mmuart/mss_uart.h"
#else
#include "drivers/FU540_uart/FU540_uart.h"
#endif

static volatile uint32_t count_sw_ints_h0 = 0U;

#ifndef  MPFS_HAL_SHARED_MEM_ENABLED
#endif

/* Main function for the HART0(E51 processor).
 * Application code running on HART0 is placed here.
 */
void e51(void)
{
    int8_t info_string[100];
    uint64_t mcycle_start = 0U;
    uint64_t mcycle_end = 0U;
    uint64_t delta_mcycle = 0U;
    uint64_t hartid = read_csr(mhartid);
    uint8_t rx_buff[1];
    uint8_t rx_size = 0;
    uint8_t debug_hart0 = 0U;
    int kyber_name;

    (void)mss_config_clk_rst(MSS_PERIPH_CFM, (uint8_t) MPFS_HAL_FIRST_HART, PERIPHERAL_ON);

    /* Turn on UART0 clock */
    SYSREG->SUBBLK_CLOCK_CR |= SUBBLK_CLOCK_CR_MMUART0_MASK;
    /* Remove soft reset */
    SYSREG->SOFT_RESET_CR   &= ~SOFT_RESET_CR_MMUART0_MASK;
    //mss_config_clk_rst(MSS_PERIPH_MMUART0, (uint8_t) 0, PERIPHERAL_ON);

    HLS_DATA* hls = (HLS_DATA*)(uintptr_t)get_tp_reg();
    /* This mutex is used to serialize accesses to UART0 when all harts want to
     * TX/RX on UART0. This mutex is shared across all harts. */
    HART_SHARED_DATA * hart_share = (HART_SHARED_DATA *)hls->shared_mem;
    /* set point for sharing across harts */
    hart_share->g_mss_uart0_lo = &g_mss_uart0_lo;

    MSS_UART_init( hart_share->g_mss_uart0_lo,
            MSS_UART_115200_BAUD,
            MSS_UART_DATA_8_BITS | MSS_UART_NO_PARITY | MSS_UART_ONE_STOP_BIT);

    if (KYBER_K == 2)  kyber_name = 512;
    else if (KYBER_K == 3)  kyber_name = 768;
    else kyber_name = 1024;
    sprintf(info_string, "\r\nKyber-%u begins from Hart %u\r\n\r\n", kyber_name, hls->my_hart_id);
    spinlock(&hart_share->mutex_uart0);
    MSS_UART_polled_tx(hart_share->g_mss_uart0_lo, (const uint8_t*)info_string,(uint32_t)strlen(info_string));
    spinunlock(&hart_share->mutex_uart0);

    raise_soft_interrupt(1u);

}

/* HART0 Software interrupt handler */
void Software_h0_IRQHandler(void)
{
    uint64_t hart_id = read_csr(mhartid);
    count_sw_ints_h0++;
}
