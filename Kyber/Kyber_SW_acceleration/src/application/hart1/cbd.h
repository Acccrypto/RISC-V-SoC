/*
 * cbd.h
 *
 *  Created on: 2023年1月11日
 *      Author: wangt
 */

#ifndef CBD_H_
#define CBD_H_

#include <stdint.h>
#include "params.h"
#include "poly.h"

#define cbd_eta1 KYBER_NAMESPACE(_cbd_eta1)
void cbd_eta1(poly *r, const uint8_t buf[KYBER_ETA1*KYBER_N/4]);

#define cbd_eta2 KYBER_NAMESPACE(_cbd_eta2)
void cbd_eta2(poly *r, const uint8_t buf[KYBER_ETA2*KYBER_N/4]);

#endif /* SRC_APPLICATION_HART2_CBD_H_ */
