# Cost Optimization scripts

-----

##Prerequisite

----
## Creating user and attach the ec2 permission

1) aws iam create-user --user-name python
2) Attach ec2 policy to python user to have permission of ec2.
    aws iam attach-user-policy \
    --user-name python \
    --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess
3) create secret key to access aws cli 
aws iam create-access-key --user-name python

----
## Configure aws in visual studio code

aws configure
AWS Access Key ID [****************CEP5]:  < Enter  AWS Access Key ID >

AWS Secret Access Key [****************ye7I]: < Enter  Secret Access >

Default region name [us-east-1]: < You can select region >

Default output format [json]:  < select default 



-----

#### Check_stopped_instances.py
How it works:
1) Uses boto3 to query EC2 instance states.
2) Generates a file listing stopped instances.
3) Sends an automated email notification with the report attached.
4) Can be scheduled via cron or deployed on AWS Lambda for serverless. execution.

Note: change the sender , Receive mail id  and create app password use in code.

----

#### Start_stop.py
How it works:
1) Uses boto3 to query EC2 instances and filter them by tags.
2) Defines functions to start or stop instances tagged as "dev".
3) Continuously checks the system time and triggers start/stop actions at specified times.

Note: start_stop.py script will run continuously , when specified time was matched the function will execute.






