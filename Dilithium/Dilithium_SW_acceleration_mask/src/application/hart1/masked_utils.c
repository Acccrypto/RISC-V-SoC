/*
 * masked_utils.c
 *
 *  Created on: 2023年12月13日
 *      Author: wangt
 */

#include "masked_utils.h"
#include <stdlib.h>

void masked_polyveck(polyveck_mask* mpv, const polyveck* pv) {
    int32_t v;
    int i, j, d;

    for (i = 0; i < K; i++) {
        for (j = 0; j < N; j++)
            mpv->share[0].vec[i].coeffs[j] = pv->vec[i].coeffs[j];

        for (d = 1; d < NSHARES; d++) {
            for (j = 0; j < N; j++) {
                v = (rand() & 0x007fffff) % Q;
                mpv->share[0].vec[i].coeffs[j] = (mpv->share[0].vec[i].coeffs[j] - v) % Q;
                mpv->share[d].vec[i].coeffs[j] = v;
            }
        }
    }
}

void masked_polyvecl(polyvecl_mask* mpv, const polyvecl* pv) {
    int32_t v;
    int i, j, d;

    for (i = 0; i < L; i++) {
        for (j = 0; j < N; j++)
            mpv->share[0].vec[i].coeffs[j] = pv->vec[i].coeffs[j];

        for (d = 1; d < NSHARES; d++) {
            for (j = 0; j < N; j++) {
                v = (rand() & 0x007fffff) % Q;
                mpv->share[0].vec[i].coeffs[j] = (mpv->share[0].vec[i].coeffs[j] - v) % Q;
                mpv->share[d].vec[i].coeffs[j] = v;
            }
        }
    }
}

void unmasked_polyveck(polyveck* pv, const polyveck_mask* mpv) {
    int i, j, d;

    for (i = 0; i < K; i++) {
        for (j = 0; j < N; j++)
            pv->vec[i].coeffs[j] = mpv->share[0].vec[i].coeffs[j];

        for (d = 1; d < NSHARES; d++) {
            for (j = 0; j < N; j++)
                pv->vec[i].coeffs[j] = (pv->vec[i].coeffs[j] + mpv->share[d].vec[i].coeffs[j] + Q) % Q;
        }
    }
}

void unmasked_polyvecl(polyvecl* pv, const polyvecl_mask* mpv) {
    int i, j, d;

    for (i = 0; i < L; i++) {
        for (j = 0; j < N; j++)
            pv->vec[i].coeffs[j] = mpv->share[0].vec[i].coeffs[j];

        for (d = 1; d < NSHARES; d++) {
            for (j = 0; j < N; j++)
                pv->vec[i].coeffs[j] = (pv->vec[i].coeffs[j] + mpv->share[d].vec[i].coeffs[j] + Q) % Q;
        }
    }
}
