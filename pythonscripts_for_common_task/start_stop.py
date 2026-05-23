import boto3
import datetime

client = boto3.client('ec2')

response = client.describe_instances()

reservations = response['Reservations']

#start logic
def start():
 for instances in reservations:
    instance=instances['Instances']
    for list_instances in instance:
        instance_id=list_instances['InstanceId']
        tag_value = list_instances['Tags'][0]['Value']
        if tag_value == "dev": 
         print(f"{instance_id} is dev server , Hence starting the instances")
         instance_start = client.start_instances(
          InstanceIds=[instance_id])
        else:
           print(f"{instance_id}is not dev server")


def stop():
   for instances in reservations:
    instance=instances['Instances']
    for list_instances in instance:
        instance_id=list_instances['InstanceId']
        tag_value = list_instances['Tags'][0]['Value']
        if tag_value == "dev": 
         print(f"{instance_id} is dev server , Hence stopping the instance")
         instance_start = client.stop_instances(
          InstanceIds=[instance_id])
        else:
           print(f"{instance_id}is not dev server")



def time_execution():
 START_TIME="14:52:20" # Enter your prefered time to start the instance
 STOP_TIME= "14:56:89" # Enter your prefered time to Stop the instance
 while True:
  x = datetime.datetime.now()
  print(x)
  time_output =x.strftime("%X")

  if time_output == "14:52:20" :  
    print("time is reached , we need to start dev instances")
    start()
  elif time_output == "14:53:30":
    print("time is reached , we need to stop dev instances")
    stop()


time_execution()







