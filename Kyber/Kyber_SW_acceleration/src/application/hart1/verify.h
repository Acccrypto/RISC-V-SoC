/*
 * verify.h
 *
 *  Created on: 2023年1月11日
 *      Author: wangt
 */

#ifndef VERIFY_H_
#define VERIFY_H_

#include <stddef.h>
#include <stdint.h>
#include "params.h"

#define verify KYBER_NAMESPACE(_verify)
int verify(const uint8_t *a, const uint8_t *b, size_t len);

#define cmov KYBER_NAMESPACE(_cmov)
void cmov(uint8_t *r, const uint8_t *x, size_t len, uint8_t b);

#endif /* SRC_APPLICATION_HART2_VERIFY_H_ */
