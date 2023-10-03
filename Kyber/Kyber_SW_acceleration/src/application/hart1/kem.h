/*
 * kem.h
 *
 *  Created on: 2023年1月11日
 *      Author: wangt
 */

#ifndef KEM_H_
#define KEM_H_

#include "params.h"

#define crypto_kem_keypair KYBER_NAMESPACE(_keypair)
int crypto_kem_keypair(unsigned char *pk, unsigned char *sk);

#define crypto_kem_enc KYBER_NAMESPACE(_enc)
int crypto_kem_enc(unsigned char *ct,
                   unsigned char *ss,
                   const unsigned char *pk);

#define crypto_kem_dec KYBER_NAMESPACE(_dec)
int crypto_kem_dec(unsigned char *ss,
                   const unsigned char *ct,
                   const unsigned char *sk);

#endif /* SRC_APPLICATION_HART2_KEM_H_ */
