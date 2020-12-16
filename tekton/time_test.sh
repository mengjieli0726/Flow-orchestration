#!/bin/bash
count=$1
yaml_file=$2
crname=$3
start_time=`date +%s.%4N`
for(( i = 0; i < $count; i++ ))
do
{
   kubectl create -f $yaml_file
}&
done
while true
do
   num=`kubectl get pods |tail -n +2|grep $crname |grep Running |wc -l`
   if [[ "$num" -ge $count ]]; then
     end_time=`date +%s.%4N`
     break
   elif [[ "$num" -gt 0 ]]; then
      first_pod=`date +%s.%4N`
   fi
done
echo "Start applying: ${start_time}" #>> /tmp/result.txt
echo "All finished: ${end_time}" #>> /tmp/result.txt
echo "First pod Running: ${first_pod}"
process_time=`echo ${end_time}-${start_time}|bc`
echo "All pod Running: $process_time"  #>> /tmp/result.txt
pod_time_diff=`echo ${end_time}-${first_pod}|bc`
echo "pod time start time diff: $pod_time_diff"
