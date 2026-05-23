# Cost Optimization scripts

-----

##Prerequisite
----
## Creating user and attach the ec2 permission

1) aws iam create-user --user-name python
2) Attach ec2 policy to python user to have permission of ec2.

## Configure aws in visual studio code

aws configure
AWS Access Key ID [****************CEP5]:  < Enter  AWS Access Key ID >

AWS Secret Access Key [****************ye7I]: < Enter  Secret Access >

Default region name [us-east-1]: < You can select region >

Default output format [json]:  < select default 

----

#### check_stopped_instances.py
How it works:
1) Uses boto3 to query EC2 instance states.
2) Generates a file listing stopped instances.
3) Sends an automated email notification with the report attached.
4) Can be scheduled via cron or deployed on AWS Lambda for serverless. execution.

