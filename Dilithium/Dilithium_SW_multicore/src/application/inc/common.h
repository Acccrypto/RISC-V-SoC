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
#include "hart1/sign.h"

#define TEST_NUM 1000

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
    uint8_t *rho, *rhoprime;
    polyvecl mat[K];
    polyvecl s1;
    polyveck s2;
    polyveck t1, t0;
    _Alignas(8) unsigned char *pk, *sk;
    polyvecl y, z;
    polyveck w1, w0, h;
    _Alignas(8) unsigned char *sm;
    uint16_t nonce;
    int reject;
    _Alignas(8) uint8_t *pw1_buf;
    uint8_t core2_end, core3_end, core4_end;
} HART_SHARED_DATA;

/**
 * extern variables
 */


/**
 * functions
 */

#endif /* COMMON_H_ */
