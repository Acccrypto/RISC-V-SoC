/*
 * ntt.h
 *
 *  Created on: 2023年1月7日
 *      Author: wangt
 */

#ifndef APPLICATION_HART1_NTT_H_
#define APPLICATION_HART1_NTT_H_

#include <hart1/params.h>
#include <stdint.h>

#define ntt DILITHIUM_NAMESPACE(_ntt)
void ntt(int32_t a[N]);

#define invntt_tomont DILITHIUM_NAMESPACE(_invntt_tomont)
void invntt_tomont(int32_t a[N]);

#endif /* APPLICATION_HART1_NTT_H_ */
