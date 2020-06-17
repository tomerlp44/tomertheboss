#!/bin/bash

size_counter=0
cntr_quit=0

for i in $@
do
des_path=$i
cntr_quit=$(( cntr_quit + 1 ))
done


cntr_loop=1
echo $des_path
SERVER=$(hostname)

if [ "$SERVER" == "server1" ]
then
for FILE in $@
do
if [ "$cntr_loop" != "$cntr_quit" ]
then
scp -r $FILE vagrant@192.168.100.11:$des_path
#calc=`du -sb $FILE | awk '{print $1}'`
#echo $calc
#echo $size_counter
#size_counter=$(( size_counter + calc ))
size_counter=$(( size_counter + `du -sb $FILE | awk '{print $1}'` ))
#loop_counter=$(( $loop_counter+1 ))
cntr_loop=$(( $cntr_loop + 1 ))
fi
done

else
  for FILE in $@
  do
  scp -r $FILE vagrant@192.168.100.10:$des_path
  #calc=`du -sb $FILE | awk '{print $1}'`
  echo $calc
  echo $size_counter
  #size_counter=$(( size_counter + calc ))
  size_counter=$(( size_counter + `du -sb $FILE | awk '{print $1}'` ))
  loop_counter=$loop_counter+1
  done


fi

echo $size_counter





