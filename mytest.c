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
//or
//make abc

int main(int argc, char **argv) {

	freopen("null", "w", stderr); //Uncomment to show stderr.

//TEST translate_num
	char num[] = "0x6fffff";
	long int result = 0;
	int flag;

	//nornmal test.
	flag = translate_num(&result, num, 0, 999999999);
	assert(7340031 == result);
	assert(flag == 0);

	//out of bound.
	flag = translate_num(&result, num, 1, 2);
	assert(7340031 == result);
	assert(flag == -1);

	//invalid output pointer.
	flag = translate_num(NULL, num, 0, 999999999);
	assert(flag == -1);
	printf("PASSED: translate_num.\n");

//TEST add_to_table
	//uniqueTable:
	//tim1 4
	//tim2 8
	//tim3 12
	//tim4 16
	//tim5 20
	//tim6 24

	char* tim1 = "tim1";
	char* tim2 = "tim2";
	char* tim3 = "tim3";
	char* tim4 = "tim4";
	char* tim5 = "tim5";
	char* tim6 = "tim6";

	SymbolTable * uniqueTable = create_table(SYMTBL_UNIQUE_NAME);
	add_to_table(uniqueTable, tim1, 4);
	add_to_table(uniqueTable, tim2, 8);
	add_to_table(uniqueTable, tim3, 12);
	add_to_table(uniqueTable, tim4, 16);
	//normal.
	flag = add_to_table(uniqueTable, tim5, 20);
	assert(uniqueTable->len == 5);
	//name duplicate.
	flag = add_to_table(uniqueTable, tim5, 20);
	assert(flag == -1);
	//address not aligned.
	flag = add_to_table(uniqueTable, tim6, 1);
	assert(flag == -1);
	printf("2 expected errors are supressed above.\n");
	printf("Uncomment line 19 to see error msg.\n");

	flag = add_to_table(uniqueTable, tim6, 24);
	assert(uniqueTable->len == 6);
	assert(uniqueTable->cap == 10);

	//RUNNING valGrind here to expect a memory leak.
	//	./run-valgrind ./mytest
	printf("PASSED: add_to_table.\n");

//TEST free_table
	free_table(uniqueTable);
	//RUNNING valGrind here to expect the memory leak is fixed.
	//	./run-valgrind ./mytest
	printf("PASSED: free_table.\n");

return 0;
}