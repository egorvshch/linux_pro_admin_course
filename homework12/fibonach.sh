#!/bin/bash

# Static input for N
N=$1

# First and Second Number of the Fibonacci Series
a=0
b=1 

echo "The Fibonacci series is : "

for (( i=0; i<N; i++ ))
do
#	echo -n "$a "
	fn=$((a + b))
	a=$b
	b=$fn
done 
echo "$a"
