#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "src/utils.h"
#include "src/tables.h"
#include "src/translate_utils.h"
#include "src/translate.h"
#include "assembler.h"

//RUN TEST WITH:
//gcc -o mytest src/translate_utils.c mytest.c


int main(int argc, char **argv) {

//TEST translate_num
	char num[] = "0x6fffff";
	long int result = 0;
	int flag;

	flag = translate_num(&result, num, 0, 999999999);
	assert(7340031 == result);
	assert(flag == 0);

	flag = translate_num(NULL, num, 0, 999999999);
	assert(flag == -1);
	printf("PASSED: translate_num.\n");



return 0;
}