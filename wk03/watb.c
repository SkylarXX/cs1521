// COMP1521 19t2 ... lab 03: where are the bits?
// watb.c: determine bit-field order

#include <stdio.h>
#include <stdlib.h>

struct _bit_fields {
	unsigned int a : 4;
	unsigned int b : 8;
	unsigned int c : 20;
};


union bit_field{
	struct _bit_fields bits;
	unsigned int num;
};

int main(void)
{

    union bit_field y;
    y.bits.c = 1;
    y.bits.b = 0;
    y.bits.a = 0;
    printf("%u\n",y.num);

    
    y.bits.a = 0;
    y.bits.b = 1;
    y.bits.c = 0;
    printf("%u\n",y.num);

    y.bits.c = 0;
    y.bits.b = 0;
    y.bits.a = 1;
    printf("%u\n",y.num);

   return 0;
}
