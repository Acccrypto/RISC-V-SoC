/*
 * core_poly.c
 *
 *  Created on: 2023年3月5日
 *      Author: wangt
 */

#include "core_poly.h"
#include "drivers/mss/mss_mmuart/mss_uart.h"
#include "drivers/mss/mss_pdma/mss_pdma.h"

mss_pdma_channel_config_t pdma_config_ch0, pdma_config_ch1;
uint8_t g_done_int_processed;

void pdma_init(void)
{
    pdma_config_ch0.dest_addr = (uint64_t) CORE_POLY_BASE;
    pdma_config_ch0.num_bytes = 512u;
    pdma_config_ch0.enable_done_int = 1u;
    pdma_config_ch0.enable_err_int = 1u;
    pdma_config_ch0.force_order = 0u;
    pdma_config_ch0.repeat = 0u;

    pdma_config_ch1.enable_done_int = 1u;
    pdma_config_ch1.enable_err_int = 1u;
    pdma_config_ch1.force_order = 0u;
    pdma_config_ch1.repeat = 0u;
}

void write_coeffs_0(poly *p, int c)
{
    if (c == 0)
        HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WR0CS0);
    else if (c == 1)
        HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WR0CS1);
    else if (c == 2)
        HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WR0CS2);

    g_done_int_processed = 0u;
    pdma_config_ch0.src_addr  = (uint64_t) p->coeffs;

    MSS_PDMA_setup_transfer(MSS_PDMA_CHANNEL_0, &pdma_config_ch0);
    MSS_PDMA_start_transfer(MSS_PDMA_CHANNEL_0);

    do {
        g_done_int_processed = MSS_PDMA_clear_transfer_complete_status(MSS_PDMA_CHANNEL_0)
                                                                          << MSS_PDMA_CHANNEL_0;
    } while (g_done_int_processed == 0);

    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRDN);
}

void write_coeffs_1(poly *p)
{
    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRITE1);

    g_done_int_processed = 0u;
    pdma_config_ch0.src_addr  = (uint64_t) p->coeffs;

    MSS_PDMA_setup_transfer(MSS_PDMA_CHANNEL_0, &pdma_config_ch0);
    MSS_PDMA_start_transfer(MSS_PDMA_CHANNEL_0);

    do {
        g_done_int_processed = MSS_PDMA_clear_transfer_complete_status(MSS_PDMA_CHANNEL_0)
                                                                          << MSS_PDMA_CHANNEL_0;
    } while (g_done_int_processed == 0);

    /*uint32_t tmp;
    for (int i = 0; i < 256; i+=2) {
        tmp = p->coeffs[i] + ((uint32_t)p->coeffs[i+1] << 16);
        HW_set_32bit_reg(CORE_POLY_BASE + i*2, tmp);
    }*/

    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRDN);
}

void write_coeffs_2(poly *p)
{
    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRITE2);

    g_done_int_processed = 0u;
    pdma_config_ch1.src_addr  = (uint64_t) p->coeffs;
    pdma_config_ch1.dest_addr = (uint64_t) CORE_POLY_BASE;
    pdma_config_ch1.num_bytes = 512;

    MSS_PDMA_setup_transfer(MSS_PDMA_CHANNEL_1, &pdma_config_ch1);
    MSS_PDMA_start_transfer(MSS_PDMA_CHANNEL_1);

    do {
        g_done_int_processed = MSS_PDMA_clear_transfer_complete_status(MSS_PDMA_CHANNEL_1)
                                                                          << MSS_PDMA_CHANNEL_1;
    } while (g_done_int_processed == 0);

    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRDN);
}

void read_coeffs_2(poly *p)
{
    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_READ);

    g_done_int_processed = 0u;
    pdma_config_ch1.src_addr  = (uint64_t) CORE_POLY_BASE;
    pdma_config_ch1.dest_addr = (uint64_t) p->coeffs;
    pdma_config_ch1.num_bytes = 512;

    MSS_PDMA_setup_transfer(MSS_PDMA_CHANNEL_1, &pdma_config_ch1);
    MSS_PDMA_start_transfer(MSS_PDMA_CHANNEL_1);

    do {
        g_done_int_processed = MSS_PDMA_clear_transfer_complete_status(MSS_PDMA_CHANNEL_1)
                                                                          << MSS_PDMA_CHANNEL_1;
    } while (g_done_int_processed == 0);

    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRDN);
}

void write_polyvec(polyvec *p)
{
    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRITE2);

    g_done_int_processed = 0u;
    pdma_config_ch1.src_addr  = (uint64_t) p->vec;
    pdma_config_ch1.dest_addr = (uint64_t) CORE_POLY_BASE;
    pdma_config_ch1.num_bytes = 512 * KYBER_K;

    MSS_PDMA_setup_transfer(MSS_PDMA_CHANNEL_1, &pdma_config_ch1);
    MSS_PDMA_start_transfer(MSS_PDMA_CHANNEL_1);

    do {
        g_done_int_processed = MSS_PDMA_clear_transfer_complete_status(MSS_PDMA_CHANNEL_1)
                                                                          << MSS_PDMA_CHANNEL_1;
    } while (g_done_int_processed == 0);

    /*uint32_t tmp;
    for (int j = 0; j < KYBER_K; j++) {
        for (int i = 0; i < 256; i+=2) {
            tmp = p->vec[j].coeffs[i] + ((uint32_t)p->vec[j].coeffs[i+1] << 16);
            HW_set_32bit_reg(CORE_POLY_BASE + i*2, tmp);
        }
    }*/

    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRDN);
}

void read_polyvec(polyvec *p)
{
    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_READ);

    g_done_int_processed = 0u;
    pdma_config_ch1.src_addr  = (uint64_t) CORE_POLY_BASE;
    pdma_config_ch1.dest_addr = (uint64_t) p->vec;
    pdma_config_ch1.num_bytes = 512 * KYBER_K;

    MSS_PDMA_setup_transfer(MSS_PDMA_CHANNEL_1, &pdma_config_ch1);
    MSS_PDMA_start_transfer(MSS_PDMA_CHANNEL_1);

    do {
        g_done_int_processed = MSS_PDMA_clear_transfer_complete_status(MSS_PDMA_CHANNEL_1)
                                                                          << MSS_PDMA_CHANNEL_1;
    } while (g_done_int_processed == 0);

    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRDN);
}
