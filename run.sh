#!/bin/bash

declare -a arr=("skorulis" "alex skorulis" "askoruli")

for i in "${arr[@]}"
do
	FIRST=`echo Q | google "$i" | grep Displaying`
	ruby check_results.rb "$FIRST" "$i"
	sleep 2s
done