#!/bin/bash
echo "Compiling..."
make
echo ""
echo "Start Running Tests..."
TEST_FILES="input/*.s"
TOTAL_CASE=0
PASS_CASE=0
if [ -n "$1" ]; then
 TEST_FILES="input/$1.s"
fi 
for f in $TEST_FILES
do
	pass=1
    base=`basename $f`
    test=${base%.*}
    echo "--------------------------------"
    echo "Running $test:"
    output=`./assembler input/$test.s out/$test.int out/$test.out -log log/$test.txt`
    compare=`diff out/$test.int out/ref/$test\_ref.int`
    if [ -n "$compare" ]; then
        echo "[Difference in $test.int]"
        echo "$compare"
        pass=0
    fi
    compare=`diff out/$test.out out/ref/$test\_ref.out`
    if [ -n "$compare" ]; then
        echo "[Difference in $test.out]"
        echo "$compare"
        pass=0
    fi
    if [ -a log/ref/$test\_ref.txt ]; then
        compare=`diff log/$test.txt log/ref/$test\_ref.txt`
        if [ -n "$compare" ]; then
            echo "[Difference in error log]"
            echo "$compare"
            pass=0
        fi
    fi
    if [ $pass == 1 ]; then
        echo " - Test Passed"
        PASS_CASE=$(($PASS_CASE+1))
    fi
    echo ""
    TOTAL_CASE=$((TOTAL_CASE+1))
done
echo "--------------------------------"
echo "(PASSED: $PASS_CASE/$TOTAL_CASE)"
echo ""