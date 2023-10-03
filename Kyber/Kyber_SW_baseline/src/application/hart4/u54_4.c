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
#if DILITHIUM_MODE == 2
    /**************crypto_sign_keypair**************/

    /* Expand matrix and Sample short vectors s1 and s2 */
    poly_uniform_eta(&hart_share->s2.vec[3], hart_share->rhoprime, L+3);
    poly_uniform_eta(&hart_share->s1.vec[3], hart_share->rhoprime, 3);
    poly_uniform(&hart_share->mat[3].vec[0], hart_share->rho, 768);
    poly_uniform(&hart_share->mat[3].vec[1], hart_share->rho, 769);
    poly_uniform(&hart_share->mat[3].vec[2], hart_share->rho, 770);
    poly_uniform(&hart_share->mat[3].vec[3], hart_share->rho, 771);

    __asm("wfi");

    /* Extract t1 and write public key */
    poly_power2round(&hart_share->t1.vec[3], &hart_share->t0.vec[3], &hart_share->t1.vec[3]);
    polyt1_pack(hart_share->pk + SEEDBYTES + 3*POLYT1_PACKEDBYTES, &hart_share->t1.vec[3]);

    __asm("wfi");

    /* pack_sk */
    int sk_offset = 2*SEEDBYTES + CRHBYTES;
    polyeta_pack(hart_share->sk + sk_offset + 3*POLYETA_PACKEDBYTES, &hart_share->s1.vec[3]);
    sk_offset += L*POLYETA_PACKEDBYTES;
    polyeta_pack(hart_share->sk + sk_offset + 3*POLYETA_PACKEDBYTES, &hart_share->s2.vec[3]);
    sk_offset += K*POLYETA_PACKEDBYTES;
    polyt0_pack(hart_share->sk + sk_offset + 3*POLYT0_PACKEDBYTES, &hart_share->t0.vec[3]);

    __asm("wfi");

    /* unpack_sk */
    sk_offset = 2*SEEDBYTES + CRHBYTES;
    polyeta_unpack(&hart_share->s1.vec[3], hart_share->sk + sk_offset + 3*POLYETA_PACKEDBYTES);
    sk_offset += L*POLYETA_PACKEDBYTES;
    polyeta_unpack_neg(&hart_share->s2.vec[3], hart_share->sk + sk_offset + 3*POLYETA_PACKEDBYTES);
    sk_offset += K*POLYETA_PACKEDBYTES;
    polyt0_unpack(&hart_share->t0.vec[3], hart_share->sk + sk_offset + 3*POLYT0_PACKEDBYTES);

    __asm("wfi");

    /**************crypto_sign_signature**************/

    /* Expand matrix */
    poly_uniform(&hart_share->mat[3].vec[0], hart_share->rho, 768);
    poly_uniform(&hart_share->mat[3].vec[1], hart_share->rho, 769);
    poly_uniform(&hart_share->mat[3].vec[2], hart_share->rho, 770);
    poly_uniform(&hart_share->mat[3].vec[3], hart_share->rho, 771);

    __asm("wfi");

rej:
    /* Sample intermediate vector y */
    poly_uniform_gamma1(&hart_share->y.vec[3], hart_share->rhoprime, L*hart_share->nonce + 3);

    __asm("wfi");

    /* Decompose w */
    poly_decompose(&hart_share->w1.vec[3], &hart_share->w0.vec[3], &hart_share->w1.vec[3]);
    polyw1_pack(&hart_share->sm[3*POLYW1_PACKEDBYTES], &hart_share->w1.vec[3]);

    __asm("wfi");

    if(hart_share->reject)
      goto rej;

    /* Write signature */
    int sig_offset = SEEDBYTES;
    polyz_pack_mod(&hart_share->sm[sig_offset] + 3*POLYZ_PACKEDBYTES, &hart_share->z.vec[3]);

    __asm("wfi");

    /**************crypto_sign_verify**************/

    /* unpack pk and sig */
    polyt1_unpack_neg(&hart_share->t1.vec[3], &hart_share->pk[SEEDBYTES] + 3*POLYT1_PACKEDBYTES);
    polyz_unpack(&hart_share->z.vec[3], hart_share->sm + SEEDBYTES + 3*POLYZ_PACKEDBYTES);
    poly_shiftl(&hart_share->t1.vec[3]);

    __asm("wfi");

    /* Expand matrix */
    poly_uniform(&hart_share->mat[3].vec[0], hart_share->rho, 768);
    poly_uniform(&hart_share->mat[3].vec[1], hart_share->rho, 769);
    poly_uniform(&hart_share->mat[3].vec[2], hart_share->rho, 770);
    poly_uniform(&hart_share->mat[3].vec[3], hart_share->rho, 771);

    __asm("wfi");

    /* Reconstruct w1 */
    poly_use_hint(&hart_share->w1.vec[3], &hart_share->w1.vec[3], &hart_share->h.vec[3]);
    polyw1_pack(&hart_share->pw1_buf[3*POLYW1_PACKEDBYTES], &hart_share->w1.vec[3]);
#elif DILITHIUM_MODE == 3
    /**************crypto_sign_keypair**************/

    /* Expand matrix and Sample short vectors s1 and s2 */
    poly_uniform_eta(&hart_share->s2.vec[3], hart_share->rhoprime, L+3);
    poly_uniform_eta(&hart_share->s1.vec[3], hart_share->rhoprime, 3);
    poly_uniform_eta(&hart_share->s1.vec[4], hart_share->rhoprime, 4);
    poly_uniform(&hart_share->mat[3].vec[0], hart_share->rho, 768);
    poly_uniform(&hart_share->mat[3].vec[1], hart_share->rho, 769);
    poly_uniform(&hart_share->mat[3].vec[2], hart_share->rho, 770);
    poly_uniform(&hart_share->mat[3].vec[3], hart_share->rho, 771);
    poly_uniform(&hart_share->mat[3].vec[4], hart_share->rho, 772);
    poly_uniform(&hart_share->mat[5].vec[3], hart_share->rho, 1283);
    poly_uniform(&hart_share->mat[5].vec[4], hart_share->rho, 1284);

    __asm("wfi");

    /* Extract t1 and write public key */
    poly_power2round(&hart_share->t1.vec[3], &hart_share->t0.vec[3], &hart_share->t1.vec[3]);
    polyt1_pack(hart_share->pk + SEEDBYTES + 3*POLYT1_PACKEDBYTES, &hart_share->t1.vec[3]);

    __asm("wfi");

    /* pack_sk */
    int sk_offset = 2*SEEDBYTES + CRHBYTES;
    polyeta_pack(hart_share->sk + sk_offset + 3*POLYETA_PACKEDBYTES, &hart_share->s1.vec[3]);
    sk_offset += L*POLYETA_PACKEDBYTES;
    polyeta_pack(hart_share->sk + sk_offset + 3*POLYETA_PACKEDBYTES, &hart_share->s2.vec[3]);
    sk_offset += K*POLYETA_PACKEDBYTES;
    polyt0_pack(hart_share->sk + sk_offset + 3*POLYT0_PACKEDBYTES, &hart_share->t0.vec[3]);
    polyt0_pack(hart_share->sk + sk_offset + 5*POLYT0_PACKEDBYTES, &hart_share->t0.vec[5]);

    __asm("wfi");

    /* unpack_sk */
    sk_offset = 2*SEEDBYTES + CRHBYTES;
    polyeta_unpack(&hart_share->s1.vec[3], hart_share->sk + sk_offset + 3*POLYETA_PACKEDBYTES);
    sk_offset += L*POLYETA_PACKEDBYTES;
    polyeta_unpack_neg(&hart_share->s2.vec[3], hart_share->sk + sk_offset + 3*POLYETA_PACKEDBYTES);
    sk_offset += K*POLYETA_PACKEDBYTES;
    polyt0_unpack(&hart_share->t0.vec[3], hart_share->sk + sk_offset + 3*POLYT0_PACKEDBYTES);
    polyt0_unpack(&hart_share->t0.vec[5], hart_share->sk + sk_offset + 5*POLYT0_PACKEDBYTES);

    __asm("wfi");

    /**************crypto_sign_signature**************/

    /* Expand matrix */
    poly_uniform(&hart_share->mat[3].vec[0], hart_share->rho, 768);
    poly_uniform(&hart_share->mat[3].vec[1], hart_share->rho, 769);
    poly_uniform(&hart_share->mat[3].vec[2], hart_share->rho, 770);
    poly_uniform(&hart_share->mat[3].vec[3], hart_share->rho, 771);
    poly_uniform(&hart_share->mat[3].vec[4], hart_share->rho, 772);
    poly_uniform(&hart_share->mat[5].vec[3], hart_share->rho, 1283);
    poly_uniform(&hart_share->mat[5].vec[4], hart_share->rho, 1284);

    __asm("wfi");

rej:
    /* Sample intermediate vector y */
    poly_uniform_gamma1(&hart_share->y.vec[3], hart_share->rhoprime, L*hart_share->nonce + 3);

    __asm("wfi");

    /* Decompose w */
    poly_decompose(&hart_share->w1.vec[3], &hart_share->w0.vec[3], &hart_share->w1.vec[3]);
    polyw1_pack(&hart_share->sm[3*POLYW1_PACKEDBYTES], &hart_share->w1.vec[3]);

    __asm("wfi");

    if(hart_share->reject)
      goto rej;

    /* Write signature */
    polyz_pack_mod(&hart_share->sm[SEEDBYTES] + 3*POLYZ_PACKEDBYTES, &hart_share->z.vec[3]);

    __asm("wfi");

    /**************crypto_sign_verify**************/

    /* unpack pk and sig */
    polyt1_unpack_neg(&hart_share->t1.vec[3], &hart_share->pk[SEEDBYTES] + 3*POLYT1_PACKEDBYTES);
    poly_shiftl(&hart_share->t1.vec[3]);
    polyz_unpack(&hart_share->z.vec[3], hart_share->sm + SEEDBYTES + 3*POLYZ_PACKEDBYTES);
    polyz_unpack(&hart_share->z.vec[4], hart_share->sm + SEEDBYTES + 4*POLYZ_PACKEDBYTES);

    __asm("wfi");

    /* Expand matrix */
    poly_uniform(&hart_share->mat[3].vec[0], hart_share->rho, 768);
    poly_uniform(&hart_share->mat[3].vec[1], hart_share->rho, 769);
    poly_uniform(&hart_share->mat[3].vec[2], hart_share->rho, 770);
    poly_uniform(&hart_share->mat[3].vec[3], hart_share->rho, 771);
    poly_uniform(&hart_share->mat[3].vec[4], hart_share->rho, 772);
    poly_uniform(&hart_share->mat[5].vec[3], hart_share->rho, 1283);
    poly_uniform(&hart_share->mat[5].vec[4], hart_share->rho, 1284);

    __asm("wfi");

    /* Reconstruct w1 */
    poly_use_hint(&hart_share->w1.vec[3], &hart_share->w1.vec[3], &hart_share->h.vec[3]);
    polyw1_pack(&hart_share->pw1_buf[3*POLYW1_PACKEDBYTES], &hart_share->w1.vec[3]);
#elif DILITHIUM_MODE == 5
    /**************crypto_sign_keypair**************/

    /* Expand matrix and Sample short vectors s1 and s2 */
    poly_uniform_eta(&hart_share->s2.vec[6], hart_share->rhoprime, L+6);
    poly_uniform_eta(&hart_share->s2.vec[7], hart_share->rhoprime, L+7);
    poly_uniform_eta(&hart_share->s1.vec[6], hart_share->rhoprime, 6);
    poly_uniform(&hart_share->mat[6].vec[0], hart_share->rho, 1536);
    poly_uniform(&hart_share->mat[6].vec[1], hart_share->rho, 1537);
    poly_uniform(&hart_share->mat[6].vec[2], hart_share->rho, 1538);
    poly_uniform(&hart_share->mat[6].vec[3], hart_share->rho, 1539);
    poly_uniform(&hart_share->mat[6].vec[4], hart_share->rho, 1540);
    poly_uniform(&hart_share->mat[6].vec[5], hart_share->rho, 1541);
    poly_uniform(&hart_share->mat[6].vec[6], hart_share->rho, 1542);
    poly_uniform(&hart_share->mat[7].vec[0], hart_share->rho, 1792);
    poly_uniform(&hart_share->mat[7].vec[1], hart_share->rho, 1793);
    poly_uniform(&hart_share->mat[7].vec[2], hart_share->rho, 1794);
    poly_uniform(&hart_share->mat[7].vec[3], hart_share->rho, 1795);
    poly_uniform(&hart_share->mat[7].vec[4], hart_share->rho, 1796);
    poly_uniform(&hart_share->mat[7].vec[5], hart_share->rho, 1797);
    poly_uniform(&hart_share->mat[7].vec[6], hart_share->rho, 1798);

    __asm("wfi");

    /* Extract t1 and write public key */
    poly_power2round(&hart_share->t1.vec[6], &hart_share->t0.vec[6], &hart_share->t1.vec[6]);
    polyt1_pack(hart_share->pk + SEEDBYTES + 6*POLYT1_PACKEDBYTES, &hart_share->t1.vec[6]);
    poly_power2round(&hart_share->t1.vec[7], &hart_share->t0.vec[7], &hart_share->t1.vec[7]);
    polyt1_pack(hart_share->pk + SEEDBYTES + 7*POLYT1_PACKEDBYTES, &hart_share->t1.vec[7]);

    __asm("wfi");

    /* pack_sk */
    int sk_offset = 2*SEEDBYTES + CRHBYTES;
    polyeta_pack(hart_share->sk + sk_offset + 6*POLYETA_PACKEDBYTES, &hart_share->s1.vec[6]);
    sk_offset += L*POLYETA_PACKEDBYTES;
    polyeta_pack(hart_share->sk + sk_offset + 6*POLYETA_PACKEDBYTES, &hart_share->s2.vec[6]);
    polyeta_pack(hart_share->sk + sk_offset + 7*POLYETA_PACKEDBYTES, &hart_share->s2.vec[7]);
    sk_offset += K*POLYETA_PACKEDBYTES;
    polyt0_pack(hart_share->sk + sk_offset + 6*POLYT0_PACKEDBYTES, &hart_share->t0.vec[6]);
    polyt0_pack(hart_share->sk + sk_offset + 7*POLYT0_PACKEDBYTES, &hart_share->t0.vec[7]);

    __asm("wfi");

    /* unpack_sk */
    sk_offset = 2*SEEDBYTES + CRHBYTES;
    polyeta_unpack(&hart_share->s1.vec[6], hart_share->sk + sk_offset + 6*POLYETA_PACKEDBYTES);
    sk_offset += L*POLYETA_PACKEDBYTES;
    polyeta_unpack_neg(&hart_share->s2.vec[6], hart_share->sk + sk_offset + 6*POLYETA_PACKEDBYTES);
    polyeta_unpack_neg(&hart_share->s2.vec[7], hart_share->sk + sk_offset + 7*POLYETA_PACKEDBYTES);
    sk_offset += K*POLYETA_PACKEDBYTES;
    polyt0_unpack(&hart_share->t0.vec[6], hart_share->sk + sk_offset + 6*POLYT0_PACKEDBYTES);
    polyt0_unpack(&hart_share->t0.vec[7], hart_share->sk + sk_offset + 7*POLYT0_PACKEDBYTES);

    __asm("wfi");

    /**************crypto_sign_signature**************/

    /* Expand matrix */
    poly_uniform(&hart_share->mat[6].vec[0], hart_share->rho, 1536);
    poly_uniform(&hart_share->mat[6].vec[1], hart_share->rho, 1537);
    poly_uniform(&hart_share->mat[6].vec[2], hart_share->rho, 1538);
    poly_uniform(&hart_share->mat[6].vec[3], hart_share->rho, 1539);
    poly_uniform(&hart_share->mat[6].vec[4], hart_share->rho, 1540);
    poly_uniform(&hart_share->mat[6].vec[5], hart_share->rho, 1541);
    poly_uniform(&hart_share->mat[6].vec[6], hart_share->rho, 1542);
    poly_uniform(&hart_share->mat[7].vec[0], hart_share->rho, 1792);
    poly_uniform(&hart_share->mat[7].vec[1], hart_share->rho, 1793);
    poly_uniform(&hart_share->mat[7].vec[2], hart_share->rho, 1794);
    poly_uniform(&hart_share->mat[7].vec[3], hart_share->rho, 1795);
    poly_uniform(&hart_share->mat[7].vec[4], hart_share->rho, 1796);
    poly_uniform(&hart_share->mat[7].vec[5], hart_share->rho, 1797);
    poly_uniform(&hart_share->mat[7].vec[6], hart_share->rho, 1798);

    __asm("wfi");

rej:
    /* Sample intermediate vector y */
    poly_uniform_gamma1(&hart_share->y.vec[6], hart_share->rhoprime, L*hart_share->nonce + 6);

    __asm("wfi");

    /* Decompose w */
    poly_decompose(&hart_share->w1.vec[6], &hart_share->w0.vec[6], &hart_share->w1.vec[6]);
    polyw1_pack(&hart_share->sm[6*POLYW1_PACKEDBYTES], &hart_share->w1.vec[6]);
    poly_decompose(&hart_share->w1.vec[7], &hart_share->w0.vec[7], &hart_share->w1.vec[7]);
    polyw1_pack(&hart_share->sm[7*POLYW1_PACKEDBYTES], &hart_share->w1.vec[7]);

    __asm("wfi");

    if(hart_share->reject)
      goto rej;

    /* Write signature */
    polyz_pack_mod(&hart_share->sm[SEEDBYTES] + 6*POLYZ_PACKEDBYTES, &hart_share->z.vec[6]);

    __asm("wfi");

    /**************crypto_sign_verify**************/

    /* unpack pk and sig */
    polyt1_unpack_neg(&hart_share->t1.vec[6], &hart_share->pk[SEEDBYTES] + 6*POLYT1_PACKEDBYTES);
    poly_shiftl(&hart_share->t1.vec[6]);
    polyt1_unpack_neg(&hart_share->t1.vec[7], &hart_share->pk[SEEDBYTES] + 7*POLYT1_PACKEDBYTES);
    poly_shiftl(&hart_share->t1.vec[7]);
    polyz_unpack(&hart_share->z.vec[6], hart_share->sm + SEEDBYTES + 6*POLYZ_PACKEDBYTES);
    polyz_unpack(&hart_share->z.vec[7], hart_share->sm + SEEDBYTES + 7*POLYZ_PACKEDBYTES);

    __asm("wfi");

    /* Expand matrix */
    poly_uniform(&hart_share->mat[6].vec[0], hart_share->rho, 1536);
    poly_uniform(&hart_share->mat[6].vec[1], hart_share->rho, 1537);
    poly_uniform(&hart_share->mat[6].vec[2], hart_share->rho, 1538);
    poly_uniform(&hart_share->mat[6].vec[3], hart_share->rho, 1539);
    poly_uniform(&hart_share->mat[6].vec[4], hart_share->rho, 1540);
    poly_uniform(&hart_share->mat[6].vec[5], hart_share->rho, 1541);
    poly_uniform(&hart_share->mat[6].vec[6], hart_share->rho, 1542);
    poly_uniform(&hart_share->mat[7].vec[0], hart_share->rho, 1792);
    poly_uniform(&hart_share->mat[7].vec[1], hart_share->rho, 1793);
    poly_uniform(&hart_share->mat[7].vec[2], hart_share->rho, 1794);
    poly_uniform(&hart_share->mat[7].vec[3], hart_share->rho, 1795);
    poly_uniform(&hart_share->mat[7].vec[4], hart_share->rho, 1796);
    poly_uniform(&hart_share->mat[7].vec[5], hart_share->rho, 1797);
    poly_uniform(&hart_share->mat[7].vec[6], hart_share->rho, 1798);

    __asm("wfi");

    /* Reconstruct w1 */
    poly_use_hint(&hart_share->w1.vec[6], &hart_share->w1.vec[6], &hart_share->h.vec[6]);
    polyw1_pack(&hart_share->pw1_buf[6*POLYW1_PACKEDBYTES], &hart_share->w1.vec[6]);
    poly_use_hint(&hart_share->w1.vec[7], &hart_share->w1.vec[7], &hart_share->h.vec[7]);
    polyw1_pack(&hart_share->pw1_buf[7*POLYW1_PACKEDBYTES], &hart_share->w1.vec[7]);
#endif
}

/* HART4 Software interrupt handler */
void Software_h4_IRQHandler(void)
{
    uint64_t hart_id = read_csr(mhartid);
    count_sw_ints_h4++;
}
