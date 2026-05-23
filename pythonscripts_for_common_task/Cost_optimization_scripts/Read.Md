# Cost Optimization scripts

-----

#### check_stopped_instances.py
How it works:
1) Uses boto3 to query EC2 instance states.
2) Generates a file listing stopped instances.
3) Sends an automated email notification with the report attached.
4) Can be scheduled via cron or deployed on AWS Lambda for serverless. execution.

