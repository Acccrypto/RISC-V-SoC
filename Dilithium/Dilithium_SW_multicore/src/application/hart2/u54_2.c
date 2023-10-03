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
 * Code running on U54 second hart
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

extern HART_SHARED_DATA * hart_share;
volatile uint32_t count_sw_ints_h2 = 0U;

/* Main function for the HART2(U54_2 processor).
 * Application code running on HART2 is placed here
 *
 * The HART2 goes into WFI. HART0 brings it out of WFI when it raises the first
 * Software interrupt to this HART
 */
void u54_2(void)
{
    uint8_t info_string[100];
    uint64_t hartid = read_csr(mhartid);
    volatile uint32_t icount = 0U;

    /*Clear pending software interrupt in case there was any.
     Enable only the software interrupt so that the E51 core can bring this core
     out of WFI by raising a software interrupt.*/
    clear_soft_interrupt();
    set_csr(mie, MIP_MSIP);

    /* put this hart into WFI. */
    do
    {
        __asm("wfi");
    }while(0 == (read_csr(mip) & MIP_MSIP));

    /* The hart is out of WFI, clear the SW interrupt. Hear onwards Application
       can enable and use any interrupts as required */
    clear_soft_interrupt();
    __enable_irq();

    for (int i = 0; i < TEST_NUM; i++) {
#if DILITHIUM_MODE == 2
        /**************crypto_sign_keypair**************/

        /* Expand matrix and Sample short vectors s1 and s2 */
        poly_uniform_eta(&hart_share->s2.vec[1], hart_share->rhoprime, L+1);
        poly_uniform_eta(&hart_share->s1.vec[1], hart_share->rhoprime, 1);
        poly_uniform(&hart_share->mat[1].vec[0], hart_share->rho, 256);
        poly_uniform(&hart_share->mat[1].vec[1], hart_share->rho, 257);
        poly_uniform(&hart_share->mat[1].vec[2], hart_share->rho, 258);
        poly_uniform(&hart_share->mat[1].vec[3], hart_share->rho, 259);

        hart_share->core2_end = 1;

        __asm("wfi");

        /* Extract t1 and write public key */
        poly_power2round(&hart_share->t1.vec[1], &hart_share->t0.vec[1], &hart_share->t1.vec[1]);
        polyt1_pack(hart_share->pk + SEEDBYTES + POLYT1_PACKEDBYTES, &hart_share->t1.vec[1]);

        hart_share->core2_end = 1;

        __asm("wfi");

        /* pack_sk */
        int sk_offset = 2*SEEDBYTES + CRHBYTES;
        polyeta_pack(hart_share->sk + sk_offset + POLYETA_PACKEDBYTES, &hart_share->s1.vec[1]);
        sk_offset += L*POLYETA_PACKEDBYTES;
        polyeta_pack(hart_share->sk + sk_offset + POLYETA_PACKEDBYTES, &hart_share->s2.vec[1]);
        sk_offset += K*POLYETA_PACKEDBYTES;
        polyt0_pack(hart_share->sk + sk_offset + POLYT0_PACKEDBYTES, &hart_share->t0.vec[1]);

        hart_share->core2_end = 1;

        __asm("wfi");

        /* unpack_sk */
        sk_offset = 2*SEEDBYTES + CRHBYTES;
        polyeta_unpack(&hart_share->s1.vec[1], hart_share->sk + sk_offset + POLYETA_PACKEDBYTES);
        sk_offset += L*POLYETA_PACKEDBYTES;
        polyeta_unpack_neg(&hart_share->s2.vec[1], hart_share->sk + sk_offset + POLYETA_PACKEDBYTES);
        sk_offset += K*POLYETA_PACKEDBYTES;
        polyt0_unpack(&hart_share->t0.vec[1], hart_share->sk + sk_offset + POLYT0_PACKEDBYTES);

        hart_share->core2_end = 1;

        __asm("wfi");

        /**************crypto_sign_signature**************/

        /* Expand matrix */
        poly_uniform(&hart_share->mat[1].vec[0], hart_share->rho, 256);
        poly_uniform(&hart_share->mat[1].vec[1], hart_share->rho, 257);
        poly_uniform(&hart_share->mat[1].vec[2], hart_share->rho, 258);
        poly_uniform(&hart_share->mat[1].vec[3], hart_share->rho, 259);

        hart_share->core2_end = 1;

        __asm("wfi");

    rej:
        /* Sample intermediate vector y */
        poly_uniform_gamma1(&hart_share->y.vec[1], hart_share->rhoprime, L*hart_share->nonce + 1);

        hart_share->core2_end = 1;

        __asm("wfi");

        /* Decompose w */
        poly_decompose(&hart_share->w1.vec[1], &hart_share->w0.vec[1], &hart_share->w1.vec[1]);
        polyw1_pack(&hart_share->sm[POLYW1_PACKEDBYTES+CRHBYTES], &hart_share->w1.vec[1]);

        hart_share->core2_end = 1;

        __asm("wfi");

        if(hart_share->reject)
          goto rej;

        /* Write signature */
        int sig_offset = SEEDBYTES;
        polyz_pack_mod(&hart_share->sm[sig_offset] + POLYZ_PACKEDBYTES, &hart_share->z.vec[1]);

        hart_share->core2_end = 1;

        __asm("wfi");

        /**************crypto_sign_verify**************/

        /* unpack pk and sig */
        polyt1_unpack_neg(&hart_share->t1.vec[1], &hart_share->pk[SEEDBYTES] + POLYT1_PACKEDBYTES);
        polyz_unpack(&hart_share->z.vec[1], hart_share->sm + SEEDBYTES + POLYZ_PACKEDBYTES);
        poly_shiftl(&hart_share->t1.vec[1]);

        hart_share->core2_end = 1;

        __asm("wfi");

        /* Expand matrix */
        poly_uniform(&hart_share->mat[1].vec[0], hart_share->rho, 256);
        poly_uniform(&hart_share->mat[1].vec[1], hart_share->rho, 257);
        poly_uniform(&hart_share->mat[1].vec[2], hart_share->rho, 258);
        poly_uniform(&hart_share->mat[1].vec[3], hart_share->rho, 259);

        hart_share->core2_end = 1;

        __asm("wfi");

        /* Reconstruct w1 */
        poly_use_hint(&hart_share->w1.vec[1], &hart_share->w1.vec[1], &hart_share->h.vec[1]);
        polyw1_pack(&hart_share->pw1_buf[POLYW1_PACKEDBYTES + CRHBYTES], &hart_share->w1.vec[1]);

        hart_share->core2_end = 1;

        __asm("wfi");
#elif DILITHIUM_MODE == 3
        /**************crypto_sign_keypair**************/

        /* Expand matrix and Sample short vectors s1 and s2 */
        poly_uniform_eta(&hart_share->s2.vec[1], hart_share->rhoprime, L+1);
        poly_uniform_eta(&hart_share->s2.vec[5], hart_share->rhoprime, L+5);
        poly_uniform_eta(&hart_share->s1.vec[1], hart_share->rhoprime, 1);
        poly_uniform(&hart_share->mat[1].vec[0], hart_share->rho, 256);
        poly_uniform(&hart_share->mat[1].vec[1], hart_share->rho, 257);
        poly_uniform(&hart_share->mat[1].vec[2], hart_share->rho, 258);
        poly_uniform(&hart_share->mat[1].vec[3], hart_share->rho, 259);
        poly_uniform(&hart_share->mat[1].vec[4], hart_share->rho, 260);
        poly_uniform(&hart_share->mat[4].vec[2], hart_share->rho, 1026);
        poly_uniform(&hart_share->mat[4].vec[3], hart_share->rho, 1027);
        poly_uniform(&hart_share->mat[4].vec[4], hart_share->rho, 1028);

        hart_share->core2_end = 1;

        __asm("wfi");

        /* Extract t1 and write public key */
        poly_power2round(&hart_share->t1.vec[1], &hart_share->t0.vec[1], &hart_share->t1.vec[1]);
        polyt1_pack(hart_share->pk + SEEDBYTES + POLYT1_PACKEDBYTES, &hart_share->t1.vec[1]);
        poly_power2round(&hart_share->t1.vec[4], &hart_share->t0.vec[4], &hart_share->t1.vec[4]);
        polyt1_pack(hart_share->pk + SEEDBYTES + 4*POLYT1_PACKEDBYTES, &hart_share->t1.vec[4]);

        hart_share->core2_end = 1;

        __asm("wfi");

        /* pack_sk */
        int sk_offset = 2*SEEDBYTES + CRHBYTES;
        polyeta_pack(hart_share->sk + sk_offset + POLYETA_PACKEDBYTES, &hart_share->s1.vec[1]);
        sk_offset += L*POLYETA_PACKEDBYTES;
        polyeta_pack(hart_share->sk + sk_offset + POLYETA_PACKEDBYTES, &hart_share->s2.vec[1]);
        polyeta_pack(hart_share->sk + sk_offset + 4*POLYETA_PACKEDBYTES, &hart_share->s2.vec[4]);
        polyeta_pack(hart_share->sk + sk_offset + 5*POLYETA_PACKEDBYTES, &hart_share->s2.vec[5]);
        sk_offset += K*POLYETA_PACKEDBYTES;
        polyt0_pack(hart_share->sk + sk_offset + POLYT0_PACKEDBYTES, &hart_share->t0.vec[1]);

        hart_share->core2_end = 1;

        __asm("wfi");

        /* unpack_sk */
        sk_offset = 2*SEEDBYTES + CRHBYTES;
        polyeta_unpack(&hart_share->s1.vec[1], hart_share->sk + sk_offset + POLYETA_PACKEDBYTES);
        sk_offset += L*POLYETA_PACKEDBYTES;
        polyeta_unpack_neg(&hart_share->s2.vec[1], hart_share->sk + sk_offset + POLYETA_PACKEDBYTES);
        polyeta_unpack_neg(&hart_share->s2.vec[4], hart_share->sk + sk_offset + 4*POLYETA_PACKEDBYTES);
        polyeta_unpack_neg(&hart_share->s2.vec[5], hart_share->sk + sk_offset + 5*POLYETA_PACKEDBYTES);
        sk_offset += K*POLYETA_PACKEDBYTES;
        polyt0_unpack(&hart_share->t0.vec[1], hart_share->sk + sk_offset + POLYT0_PACKEDBYTES);

        hart_share->core2_end = 1;

        __asm("wfi");

        /**************crypto_sign_signature**************/

        /* Expand matrix */
        poly_uniform(&hart_share->mat[1].vec[0], hart_share->rho, 256);
        poly_uniform(&hart_share->mat[1].vec[1], hart_share->rho, 257);
        poly_uniform(&hart_share->mat[1].vec[2], hart_share->rho, 258);
        poly_uniform(&hart_share->mat[1].vec[3], hart_share->rho, 259);
        poly_uniform(&hart_share->mat[1].vec[4], hart_share->rho, 260);
        poly_uniform(&hart_share->mat[4].vec[3], hart_share->rho, 1027);
        poly_uniform(&hart_share->mat[4].vec[4], hart_share->rho, 1028);
        poly_uniform(&hart_share->mat[5].vec[0], hart_share->rho, 1280);

        hart_share->core2_end = 1;

        __asm("wfi");

    rej:
        /* Sample intermediate vector y */
        poly_uniform_gamma1(&hart_share->y.vec[1], hart_share->rhoprime, L*hart_share->nonce + 1);

        hart_share->core2_end = 1;

        __asm("wfi");

        /* Decompose w */
        poly_decompose(&hart_share->w1.vec[1], &hart_share->w0.vec[1], &hart_share->w1.vec[1]);
        polyw1_pack(&hart_share->sm[POLYW1_PACKEDBYTES+CRHBYTES], &hart_share->w1.vec[1]);
        poly_decompose(&hart_share->w1.vec[4], &hart_share->w0.vec[4], &hart_share->w1.vec[4]);
        polyw1_pack(&hart_share->sm[4*POLYW1_PACKEDBYTES+CRHBYTES], &hart_share->w1.vec[4]);

        hart_share->core2_end = 1;

        __asm("wfi");

        if(hart_share->reject)
          goto rej;

        /* Write signature */
        polyz_pack_mod(&hart_share->sm[SEEDBYTES] + POLYZ_PACKEDBYTES, &hart_share->z.vec[1]);
        polyz_pack_mod(&hart_share->sm[SEEDBYTES] + 4*POLYZ_PACKEDBYTES, &hart_share->z.vec[4]);

        hart_share->core2_end = 1;

        __asm("wfi");

        /**************crypto_sign_verify**************/

        /* unpack pk and sig */
        polyt1_unpack_neg(&hart_share->t1.vec[1], &hart_share->pk[SEEDBYTES] + POLYT1_PACKEDBYTES);
        poly_shiftl(&hart_share->t1.vec[1]);
        polyt1_unpack_neg(&hart_share->t1.vec[4], &hart_share->pk[SEEDBYTES] + 4*POLYT1_PACKEDBYTES);
        poly_shiftl(&hart_share->t1.vec[4]);
        polyz_unpack(&hart_share->z.vec[1], hart_share->sm + SEEDBYTES + POLYZ_PACKEDBYTES);

        hart_share->core2_end = 1;

        __asm("wfi");

        /* Expand matrix */
        poly_uniform(&hart_share->mat[1].vec[0], hart_share->rho, 256);
        poly_uniform(&hart_share->mat[1].vec[1], hart_share->rho, 257);
        poly_uniform(&hart_share->mat[1].vec[2], hart_share->rho, 258);
        poly_uniform(&hart_share->mat[1].vec[3], hart_share->rho, 259);
        poly_uniform(&hart_share->mat[1].vec[4], hart_share->rho, 260);
        poly_uniform(&hart_share->mat[4].vec[3], hart_share->rho, 1027);
        poly_uniform(&hart_share->mat[4].vec[4], hart_share->rho, 1028);
        poly_uniform(&hart_share->mat[5].vec[0], hart_share->rho, 1280);

        hart_share->core2_end = 1;

        __asm("wfi");

        /* Reconstruct w1 */
        poly_use_hint(&hart_share->w1.vec[1], &hart_share->w1.vec[1], &hart_share->h.vec[1]);
        polyw1_pack(&hart_share->pw1_buf[POLYW1_PACKEDBYTES + CRHBYTES], &hart_share->w1.vec[1]);
        poly_use_hint(&hart_share->w1.vec[4], &hart_share->w1.vec[4], &hart_share->h.vec[4]);
        polyw1_pack(&hart_share->pw1_buf[4*POLYW1_PACKEDBYTES + CRHBYTES], &hart_share->w1.vec[4]);

        hart_share->core2_end = 1;

        __asm("wfi");
#elif DILITHIUM_MODE == 5
        /**************crypto_sign_keypair**************/

        /* Expand matrix and Sample short vectors s1 and s2 */
        poly_uniform_eta(&hart_share->s2.vec[2], hart_share->rhoprime, L+2);
        poly_uniform_eta(&hart_share->s2.vec[3], hart_share->rhoprime, L+3);
        poly_uniform_eta(&hart_share->s1.vec[2], hart_share->rhoprime, 2);
        poly_uniform_eta(&hart_share->s1.vec[3], hart_share->rhoprime, 3);
        poly_uniform(&hart_share->mat[2].vec[0], hart_share->rho, 512);
        poly_uniform(&hart_share->mat[2].vec[1], hart_share->rho, 513);
        poly_uniform(&hart_share->mat[2].vec[2], hart_share->rho, 514);
        poly_uniform(&hart_share->mat[2].vec[3], hart_share->rho, 515);
        poly_uniform(&hart_share->mat[2].vec[4], hart_share->rho, 516);
        poly_uniform(&hart_share->mat[2].vec[5], hart_share->rho, 517);
        poly_uniform(&hart_share->mat[2].vec[6], hart_share->rho, 518);
        poly_uniform(&hart_share->mat[3].vec[0], hart_share->rho, 768);
        poly_uniform(&hart_share->mat[3].vec[1], hart_share->rho, 769);
        poly_uniform(&hart_share->mat[3].vec[2], hart_share->rho, 770);
        poly_uniform(&hart_share->mat[3].vec[3], hart_share->rho, 771);
        poly_uniform(&hart_share->mat[3].vec[4], hart_share->rho, 772);
        poly_uniform(&hart_share->mat[3].vec[5], hart_share->rho, 773);
        poly_uniform(&hart_share->mat[3].vec[6], hart_share->rho, 774);

        hart_share->core2_end = 1;

        __asm("wfi");

        /* Extract t1 and write public key */
        poly_power2round(&hart_share->t1.vec[2], &hart_share->t0.vec[2], &hart_share->t1.vec[2]);
        polyt1_pack(hart_share->pk + SEEDBYTES + 2*POLYT1_PACKEDBYTES, &hart_share->t1.vec[2]);
        poly_power2round(&hart_share->t1.vec[3], &hart_share->t0.vec[3], &hart_share->t1.vec[3]);
        polyt1_pack(hart_share->pk + SEEDBYTES + 3*POLYT1_PACKEDBYTES, &hart_share->t1.vec[3]);

        hart_share->core2_end = 1;

        __asm("wfi");

        /* pack_sk */
        int sk_offset = 2*SEEDBYTES + CRHBYTES;
        polyeta_pack(hart_share->sk + sk_offset + 2*POLYETA_PACKEDBYTES, &hart_share->s1.vec[2]);
        polyeta_pack(hart_share->sk + sk_offset + 3*POLYETA_PACKEDBYTES, &hart_share->s1.vec[3]);
        sk_offset += L*POLYETA_PACKEDBYTES;
        polyeta_pack(hart_share->sk + sk_offset + 2*POLYETA_PACKEDBYTES, &hart_share->s2.vec[2]);
        polyeta_pack(hart_share->sk + sk_offset + 3*POLYETA_PACKEDBYTES, &hart_share->s2.vec[3]);
        sk_offset += K*POLYETA_PACKEDBYTES;
        polyt0_pack(hart_share->sk + sk_offset + 2*POLYT0_PACKEDBYTES, &hart_share->t0.vec[2]);
        polyt0_pack(hart_share->sk + sk_offset + 3*POLYT0_PACKEDBYTES, &hart_share->t0.vec[3]);

        hart_share->core2_end = 1;

        __asm("wfi");

        /**************crypto_sign_signature**************/

        /* unpack_sk */
        sk_offset = 2*SEEDBYTES + CRHBYTES;
        polyeta_unpack(&hart_share->s1.vec[2], hart_share->sk + sk_offset + 2*POLYETA_PACKEDBYTES);
        polyeta_unpack(&hart_share->s1.vec[3], hart_share->sk + sk_offset + 3*POLYETA_PACKEDBYTES);
        sk_offset += L*POLYETA_PACKEDBYTES;
        polyeta_unpack_neg(&hart_share->s2.vec[2], hart_share->sk + sk_offset + 2*POLYETA_PACKEDBYTES);
        polyeta_unpack_neg(&hart_share->s2.vec[3], hart_share->sk + sk_offset + 3*POLYETA_PACKEDBYTES);
        sk_offset += K*POLYETA_PACKEDBYTES;
        polyt0_unpack(&hart_share->t0.vec[2], hart_share->sk + sk_offset + 2*POLYT0_PACKEDBYTES);
        polyt0_unpack(&hart_share->t0.vec[3], hart_share->sk + sk_offset + 3*POLYT0_PACKEDBYTES);

        hart_share->core2_end = 1;

        __asm("wfi");

        /* Expand matrix */
        poly_uniform(&hart_share->mat[2].vec[0], hart_share->rho, 512);
        poly_uniform(&hart_share->mat[2].vec[1], hart_share->rho, 513);
        poly_uniform(&hart_share->mat[2].vec[2], hart_share->rho, 514);
        poly_uniform(&hart_share->mat[2].vec[3], hart_share->rho, 515);
        poly_uniform(&hart_share->mat[2].vec[4], hart_share->rho, 516);
        poly_uniform(&hart_share->mat[2].vec[5], hart_share->rho, 517);
        poly_uniform(&hart_share->mat[2].vec[6], hart_share->rho, 518);
        poly_uniform(&hart_share->mat[3].vec[0], hart_share->rho, 768);
        poly_uniform(&hart_share->mat[3].vec[1], hart_share->rho, 769);
        poly_uniform(&hart_share->mat[3].vec[2], hart_share->rho, 770);
        poly_uniform(&hart_share->mat[3].vec[3], hart_share->rho, 771);
        poly_uniform(&hart_share->mat[3].vec[4], hart_share->rho, 772);
        poly_uniform(&hart_share->mat[3].vec[5], hart_share->rho, 773);
        poly_uniform(&hart_share->mat[3].vec[6], hart_share->rho, 774);

        hart_share->core2_end = 1;

        __asm("wfi");

    rej:
        /* Sample intermediate vector y */
        poly_uniform_gamma1(&hart_share->y.vec[2], hart_share->rhoprime, L*hart_share->nonce + 2);
        poly_uniform_gamma1(&hart_share->y.vec[3], hart_share->rhoprime, L*hart_share->nonce + 3);

        hart_share->core2_end = 1;

        __asm("wfi");

        /* Decompose w */
        poly_decompose(&hart_share->w1.vec[2], &hart_share->w0.vec[2], &hart_share->w1.vec[2]);
        polyw1_pack(&hart_share->sm[2*POLYW1_PACKEDBYTES+CRHBYTES], &hart_share->w1.vec[2]);
        poly_decompose(&hart_share->w1.vec[3], &hart_share->w0.vec[3], &hart_share->w1.vec[3]);
        polyw1_pack(&hart_share->sm[3*POLYW1_PACKEDBYTES+CRHBYTES], &hart_share->w1.vec[3]);

        hart_share->core2_end = 1;

        __asm("wfi");

        if(hart_share->reject)
          goto rej;

        /* Write signature */
        polyz_pack_mod(&hart_share->sm[SEEDBYTES] + 2*POLYZ_PACKEDBYTES, &hart_share->z.vec[2]);
        polyz_pack_mod(&hart_share->sm[SEEDBYTES] + 3*POLYZ_PACKEDBYTES, &hart_share->z.vec[3]);

        hart_share->core2_end = 1;

        __asm("wfi");

        /**************crypto_sign_verify**************/

        /* unpack pk and sig */
        polyt1_unpack_neg(&hart_share->t1.vec[2], &hart_share->pk[SEEDBYTES] + 2*POLYT1_PACKEDBYTES);
        poly_shiftl(&hart_share->t1.vec[2]);
        polyt1_unpack_neg(&hart_share->t1.vec[3], &hart_share->pk[SEEDBYTES] + 3*POLYT1_PACKEDBYTES);
        poly_shiftl(&hart_share->t1.vec[3]);
        polyz_unpack(&hart_share->z.vec[2], hart_share->sm + SEEDBYTES + 2*POLYZ_PACKEDBYTES);
        polyz_unpack(&hart_share->z.vec[3], hart_share->sm + SEEDBYTES + 3*POLYZ_PACKEDBYTES);

        hart_share->core2_end = 1;

        __asm("wfi");

        /* Expand matrix */
        poly_uniform(&hart_share->mat[2].vec[0], hart_share->rho, 512);
        poly_uniform(&hart_share->mat[2].vec[1], hart_share->rho, 513);
        poly_uniform(&hart_share->mat[2].vec[2], hart_share->rho, 514);
        poly_uniform(&hart_share->mat[2].vec[3], hart_share->rho, 515);
        poly_uniform(&hart_share->mat[2].vec[4], hart_share->rho, 516);
        poly_uniform(&hart_share->mat[2].vec[5], hart_share->rho, 517);
        poly_uniform(&hart_share->mat[2].vec[6], hart_share->rho, 518);
        poly_uniform(&hart_share->mat[3].vec[0], hart_share->rho, 768);
        poly_uniform(&hart_share->mat[3].vec[1], hart_share->rho, 769);
        poly_uniform(&hart_share->mat[3].vec[2], hart_share->rho, 770);
        poly_uniform(&hart_share->mat[3].vec[3], hart_share->rho, 771);
        poly_uniform(&hart_share->mat[3].vec[4], hart_share->rho, 772);
        poly_uniform(&hart_share->mat[3].vec[5], hart_share->rho, 773);
        poly_uniform(&hart_share->mat[3].vec[6], hart_share->rho, 774);

        hart_share->core2_end = 1;

        __asm("wfi");

        /* Reconstruct w1 */
        poly_use_hint(&hart_share->w1.vec[2], &hart_share->w1.vec[2], &hart_share->h.vec[2]);
        polyw1_pack(&hart_share->pw1_buf[2*POLYW1_PACKEDBYTES + CRHBYTES], &hart_share->w1.vec[2]);
        poly_use_hint(&hart_share->w1.vec[3], &hart_share->w1.vec[3], &hart_share->h.vec[3]);
        polyw1_pack(&hart_share->pw1_buf[3*POLYW1_PACKEDBYTES + CRHBYTES], &hart_share->w1.vec[3]);

        hart_share->core2_end = 1;

        __asm("wfi");
#endif
    }
}

/* HART2 Software interrupt handler */
void Software_h2_IRQHandler(void)
{
    uint64_t hart_id = read_csr(mhartid);
    count_sw_ints_h2++;
}
