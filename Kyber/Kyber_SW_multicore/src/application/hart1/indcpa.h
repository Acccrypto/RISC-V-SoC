/*
 * indcpa.h
 *
 *  Created on: 2023年1月11日
 *      Author: wangt
 */

#ifndef INDCPA_H_
#define INDCPA_H_

#include <stdint.h>
#include "params.h"
#include "polyvec.h"
#include "symmetric.h"

void randombytes(uint8_t *rd, int len);
void waitforhart(void);

#define gen_matrix KYBER_NAMESPACE(_gen_matrix)
void gen_matrix(polyvec *a, const uint8_t seed[KYBER_SYMBYTES], int transposed);
#define indcpa_keypair KYBER_NAMESPACE(_indcpa_keypair)
void indcpa_keypair(uint8_t pk[KYBER_INDCPA_PUBLICKEYBYTES],
                    uint8_t sk[KYBER_INDCPA_SECRETKEYBYTES]);

#define indcpa_enc KYBER_NAMESPACE(_indcpa_enc)
void indcpa_enc(uint8_t c[KYBER_INDCPA_BYTES],
                const uint8_t m[KYBER_INDCPA_MSGBYTES],
                const uint8_t pk[KYBER_INDCPA_PUBLICKEYBYTES],
                const uint8_t coins[KYBER_SYMBYTES]);

#define indcpa_dec KYBER_NAMESPACE(_indcpa_dec)
void indcpa_dec(uint8_t m[KYBER_INDCPA_MSGBYTES],
                const uint8_t c[KYBER_INDCPA_BYTES],
                const uint8_t sk[KYBER_INDCPA_SECRETKEYBYTES]);

#endif /* SRC_APPLICATION_HART2_INDCPA_H_ */
