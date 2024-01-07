/*
 * masked_utils.c
 *
 *  Created on: 2023年12月13日
 *      Author: wangt
 */

#include "masked_utils.h"
#include <stdlib.h>

void masked_poly(poly_mask* mp, const poly* p) {
    int32_t v;
    int16_t v0, v1;
    int j, d;

    for (j = 0; j < KYBER_N; j++)
        mp->share[0].coeffs[j] = p->coeffs[j];

    for (d = 1; d < NSHARES; d++) {
        for (j = 0; j < KYBER_N; j+=2) {
            v = rand();
            v0 = (v & 0x00000fff) % KYBER_Q;
            v1 = (v >> 19) % KYBER_Q;
            mp->share[0].coeffs[j] = (mp->share[0].coeffs[j] - v0) % KYBER_Q;
            mp->share[d].coeffs[j] = v0;
            mp->share[0].coeffs[j+1] = (mp->share[0].coeffs[j+1] - v1) % KYBER_Q;
            mp->share[d].coeffs[j+1] = v1;
        }
    }
}

void masked_polyvec(polyvec_mask* mpv, const polyvec* pv) {
    int32_t v;
    int16_t v0, v1;
    int i, j, d;

    for (i = 0; i < KYBER_K; i++) {
        for (j = 0; j < KYBER_N; j++)
            mpv->share[0].vec[i].coeffs[j] = pv->vec[i].coeffs[j];

        for (d = 1; d < NSHARES; d++) {
            for (j = 0; j < KYBER_N; j+=2) {
                v = rand();
                v0 = (v & 0x00000fff) % KYBER_Q;
                v1 = (v >> 19) % KYBER_Q;
                mpv->share[0].vec[i].coeffs[j] = (mpv->share[0].vec[i].coeffs[j] - v0) % KYBER_Q;
                mpv->share[d].vec[i].coeffs[j] = v0;
                mpv->share[0].vec[i].coeffs[j+1] = (mpv->share[0].vec[i].coeffs[j+1] - v1) % KYBER_Q;
                mpv->share[d].vec[i].coeffs[j+1] = v1;
            }
        }
    }
}

void unmasked_poly(poly* p, const poly_mask* mp) {
    int j, d;

    for (j = 0; j < KYBER_N; j++)
        p->coeffs[j] = mp->share[0].coeffs[j];

    for (d = 1; d < NSHARES; d++) {
        for (j = 0; j < KYBER_N; j++)
            p->coeffs[j] = (p->coeffs[j] + mp->share[d].coeffs[j] + KYBER_Q) % KYBER_Q;
    }
}

void unmasked_polyvec(polyvec* pv, const polyvec_mask* mpv) {
    int i, j, d;

    for (i = 0; i < KYBER_K; i++) {
        for (j = 0; j < KYBER_N; j++)
            pv->vec[i].coeffs[j] = mpv->share[0].vec[i].coeffs[j];

        for (d = 1; d < NSHARES; d++) {
            for (j = 0; j < KYBER_N; j++)
                pv->vec[i].coeffs[j] = (pv->vec[i].coeffs[j] + mpv->share[d].vec[i].coeffs[j] + KYBER_Q) % KYBER_Q;
        }
    }
}
