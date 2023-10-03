/*
 * keccak.h
 *
 *  Created on: 2023年4月4日
 *      Author: wangt
 */

#ifndef KECCAK_H_
#define KECCAK_H_

// initialize state with zero
void state_init(void);

// load r bytes from m to fp registers
void loadR(const uint8_t *m, unsigned int r);

// store r bytes from fp registers to m
void storeR(uint8_t *m, unsigned int r);

// The Keccak F1600 Permutation
void KeccakF1600_StatePermute(void);

#endif /* SRC_APPLICATION_HART1_KECCAK_H_ */
