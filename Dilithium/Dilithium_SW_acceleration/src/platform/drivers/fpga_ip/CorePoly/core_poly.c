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
    pdma_config_ch0.num_bytes = 1024u;
    pdma_config_ch0.enable_done_int = 1u;
    pdma_config_ch0.enable_err_int = 1u;
    pdma_config_ch0.force_order = 0u;
    pdma_config_ch0.repeat = 0u;

    pdma_config_ch1.enable_done_int = 1u;
    pdma_config_ch1.enable_err_int = 1u;
    pdma_config_ch1.force_order = 0u;
    pdma_config_ch1.repeat = 0u;
}

void write_coeffs_0(poly_instance_t *p)
{
    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRITE0);

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

/*void write_coeffs_0(poly_instance_t *p)
{
    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRITE0);

    for (int i = 0; i < N; i++) {
        HW_set_32bit_reg(CORE_POLY_BASE + i*4, p->coeffs[i]);
    }

    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRDN);
}*/

void write_coeffs_0_ntt0(poly_instance_t *p)
{
    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WR0NT0);

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

void write_coeffs_0_pwm(poly_instance_t *p)
{
    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WR0PWM);

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

void write_coeffs_0_madd(poly_instance_t *p)
{
    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WR0ADD);

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

void write_coeffs_1(poly_instance_t *p, int ntt0)
{
    if (ntt0)
        HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WR1NT0);
    else
        HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRITE1);

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

void write_polyveck(polyveck *p)
{
    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRITE2);

    g_done_int_processed = 0u;
    pdma_config_ch1.num_bytes = 1024 * K;
    pdma_config_ch1.src_addr  = (uint64_t) p->vec;
    pdma_config_ch1.dest_addr = (uint64_t) CORE_POLY_BASE;

    MSS_PDMA_setup_transfer(MSS_PDMA_CHANNEL_1, &pdma_config_ch1);
    MSS_PDMA_start_transfer(MSS_PDMA_CHANNEL_1);

    do {
        g_done_int_processed = MSS_PDMA_clear_transfer_complete_status(MSS_PDMA_CHANNEL_1)
                                                                          << MSS_PDMA_CHANNEL_1;
    } while (g_done_int_processed == 0);

    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRDN);
}

/*void write_polyveck(polyveck *p)
{
    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRITE2);

    for (int j = 0; j < K; j++) {
        for (int i = 0; i < N; i++) {
            HW_set_32bit_reg(CORE_POLY_BASE + 1024*j + i*4, p->vec[j].coeffs[i]);
        }
    }

    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRDN);
}*/

void write_polyvecl(polyvecl *p)
{
    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRITE2);

    g_done_int_processed = 0u;
    pdma_config_ch1.num_bytes = 1024 * L;
    pdma_config_ch1.src_addr  = (uint64_t) p->vec;
    pdma_config_ch1.dest_addr = (uint64_t) CORE_POLY_BASE;

    MSS_PDMA_setup_transfer(MSS_PDMA_CHANNEL_1, &pdma_config_ch1);
    MSS_PDMA_start_transfer(MSS_PDMA_CHANNEL_1);

    do {
        g_done_int_processed = MSS_PDMA_clear_transfer_complete_status(MSS_PDMA_CHANNEL_1)
                                                                          << MSS_PDMA_CHANNEL_1;
    } while (g_done_int_processed == 0);

    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRDN);
}

void read_polyveck(polyveck *p, int holdvec)
{
    if (holdvec)
        HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_RDHD);
    else
        HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_READ);

    g_done_int_processed = 0u;
    pdma_config_ch1.num_bytes = 1024 * K;
    pdma_config_ch1.src_addr  = (uint64_t) CORE_POLY_BASE;
    pdma_config_ch1.dest_addr = (uint64_t) p->vec;

    MSS_PDMA_setup_transfer(MSS_PDMA_CHANNEL_1, &pdma_config_ch1);
    MSS_PDMA_start_transfer(MSS_PDMA_CHANNEL_1);

    do {
        g_done_int_processed = MSS_PDMA_clear_transfer_complete_status(MSS_PDMA_CHANNEL_1)
                                                                          << MSS_PDMA_CHANNEL_1;
    } while (g_done_int_processed == 0);

    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRDN);
}

void read_polyvecl(polyvecl *p)
{
    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_READ);

    g_done_int_processed = 0u;
    pdma_config_ch1.num_bytes = 1024 * L;
    pdma_config_ch1.src_addr  = (uint64_t) CORE_POLY_BASE;
    pdma_config_ch1.dest_addr = (uint64_t) p->vec;

    MSS_PDMA_setup_transfer(MSS_PDMA_CHANNEL_1, &pdma_config_ch1);
    MSS_PDMA_start_transfer(MSS_PDMA_CHANNEL_1);

    do {
        g_done_int_processed = MSS_PDMA_clear_transfer_complete_status(MSS_PDMA_CHANNEL_1)
                                                                          << MSS_PDMA_CHANNEL_1;
    } while (g_done_int_processed == 0);

    HW_set_32bit_reg(CORE_POLY_CONF, CORE_POLY_WRDN);
}
