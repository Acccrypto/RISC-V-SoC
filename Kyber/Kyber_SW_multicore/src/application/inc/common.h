/*******************************************************************************
 * Copyright 2019-2021 Microchip FPGA Embedded Systems Solution.
 *
 * SPDX-License-Identifier: MIT
 *
 * MPFS HAL Embedded Software example
 *
 */
/*******************************************************************************
 *
 * Used for common defines across application code
 *
 */

#ifndef COMMON_H_
#define COMMON_H_

#include <stdint.h>
#include "drivers/mss/mss_mmuart/mss_uart.h"
#include "hart1/indcpa.h"

#define TEST_NUM_KEY 1
#define TEST_NUM_ENC 1
#define TEST_NUM_DEC 1

typedef enum COMMAND_TYPE_
{
    CLEAR_COMMANDS                  = 0x00,       /*!< 0 default behavior */
    START_HART1_U_MODE              = 0x01,       /*!< 1 u mode */
    START_HART2_S_MODE              = 0x02,       /*!< 2 s mode */
}   COMMAND_TYPE;

typedef struct HART_SHARED_DATA_
{
    uint64_t init_marker;
    volatile long mutex_uart0;
    mss_uart_instance_t *g_mss_uart0_lo;
    polyvec a[KYBER_K];
    polyvec e, skpv, pkpv, sp, bp;
    const uint8_t *publicseed, *noiseseed;
    unsigned char *pk, *sk, *c, *cmp;
    const uint8_t *coins, *m;
    poly k;
} HART_SHARED_DATA;

/**
 * extern variables
 */


/**
 * functions
 */

#endif /* COMMON_H_ */