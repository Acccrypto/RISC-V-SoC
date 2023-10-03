/*
 * rounding.h
 *
 *  Created on: 2023年1月8日
 *      Author: wangt
 */

#ifndef APPLICATION_HART1_ROUNDING_H_
#define APPLICATION_HART1_ROUNDING_H_

#include <hart1/params.h>
#include <stdint.h>

#define power2round DILITHIUM_NAMESPACE(_power2round)
int32_t power2round(int32_t *a0, int32_t a);

#define decompose DILITHIUM_NAMESPACE(_decompose)
int32_t decompose(int32_t *a0, int32_t a);

#define make_hint DILITHIUM_NAMESPACE(_make_hint)
unsigned int make_hint(int32_t a0, int32_t a1);

#define use_hint DILITHIUM_NAMESPACE(_use_hint)
int32_t use_hint(int32_t a, unsigned int hint);

#endif /* APPLICATION_HART1_ROUNDING_H_ */
