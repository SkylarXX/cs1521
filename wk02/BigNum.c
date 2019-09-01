// BigNum.c ... LARGE positive integer values

#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "BigNum.h"

#define BUFSIZE 256

// Initialise a BigNum to N bytes, all zero
void initBigNum (BigNum *bn, int Nbytes)
{
    bn->nbytes = Nbytes;
	bn->bytes = malloc(sizeof(unsigned char) * Nbytes);
	assert(bn->bytes != NULL);
	assert(bn->nbytes != 0);
	memset(bn->bytes,'0', Nbytes);
	/*for(int i = 0; i < Nbytes; i++) {
	    bn->bytes[i] = '0';
	}*/
	
}

// Add two BigNums and store result in a third BigNum
void addBigNums (BigNum bnA, BigNum bnB, BigNum *res)
{

	//choose the bigger one to be the new size
	int size = bnA.nbytes;
	if(bnB.nbytes > size) {

		size = bnB.nbytes;
	}
	//checking the size of *res is enough
	if(res->nbytes < (size + 1) ) {
		res->nbytes = size + 1;
		res->bytes = realloc(res->bytes, (res->nbytes) * sizeof(Byte));
		memset(res->bytes, '0', size + 1);
	}


	int carryOver = 0;
	int total;
	for(int i = 0; i < res->nbytes; i++) {

		Byte numA,numB;
		total = 0;
		if(i < bnA.nbytes && i < bnB.nbytes) {
			numA = bnA.bytes[i];
			numB = bnB.bytes[i];
		} else if (i >= bnA.nbytes && i >= bnB.nbytes) {
		    numA = '0';
		    numB = '0';
		} else {
			if(i > bnA.nbytes) {
				numA = '0';
				numB = bnB.bytes[i];
			} else {
				numA = bnA.bytes[i];
				numB = '0';
			}
		}

		total = (numA - '0') + (numB - '0') + carryOver;

		if(total >= 10) {
			res->bytes[i] = (char)(total - 10) + '0';
			carryOver = 1;
		} else {
			res->bytes[i] = (char)(total + '0');
			carryOver = 0;
		}

	}


}

// Set the value of a BigNum from a string of digits
// Returns 1 if it *was* a string of digits, 0 otherwise
int scanBigNum (char *s, BigNum *bn)
{
	int has_digit = 0;
	//realloc if the string is larger than the array
	if(strlen(s) > bn->nbytes) {
		bn->nbytes = strlen(s);
		bn->bytes = (Byte*)realloc(bn->bytes, bn->nbytes * sizeof(Byte));
		assert(bn->bytes != NULL);
		memset(bn->bytes, '0', bn->nbytes);
	}

	//remove non-number characters
	int j = 0;
	char tmp[BUFSIZE];
	for(int i = 0; i < strlen(s); i++) {
		if(isdigit(s[i])) {
			has_digit = 1;
			tmp[j] = s[i];
			j++;
		}
	}

	//remove ZERO at the front
	int start = 0;
	for(int i = 0; i < strlen(s); i++) {
		if(tmp[i] != '0') {
			start = i;
			break;
		}
	}
	
	//put the nums(from start to j) in array into *bn
	int k = 0;
	while(j > start) {
		bn->bytes[k] = tmp[j - 1 ];
		
		k++;
		j--;
	}

	return has_digit;
}

// Display a BigNum in decimal format
void showBigNum (BigNum bn)
{
    int start = 0;
    int i = 0;
    while(i < bn.nbytes) {
        if(bn.bytes[i] > '0' && bn.bytes[i] <= '9') start = i;
        i++;
    }
	
	while(start >= 0) {
	    printf("%c",bn.bytes[start]);
	    start--;
	}
}

void subtractBigNums (BigNum bnA, BigNum bnB, BigNum *res) {
    return;
}
