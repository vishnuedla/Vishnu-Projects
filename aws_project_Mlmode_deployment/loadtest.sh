#!/bin/bash
for i in {1..1000}; do
   curl http://ML-LB-1940805171.ap-south-1.elb.amazonaws.com/predict -H "Content-Type: application/json" -d '{"text":"I want to cancel my subscription"}'

   echo $i
done
