import boto3
import os
import smtplib
import os
from email.message import EmailMessage

ec2 = boto3.client('ec2')
response = ec2.describe_instances()


reservations = response['Reservations']

for instances in reservations:
    instance=instances['Instances']
    for list_instances in instance:
        instance_id=list_instances['InstanceId']  
        instance_id=list_instances['InstanceId']
        status= list_instances['State']['Name']
        if status == "stopped":
          file=open("stopped_instances.txt","a")
          file.write(f"Instance {instance_id} is stopped.\n")

file.close()
#sending mail
msg = EmailMessage()
msg['Subject'] = f'list of ec2 instances are in stopped state'
msg['From'] = 'SENDER_MAIL'
msg.set_content(
        "Hello,\n\n"
        "Please find attached the list of EC2 instances that are currently in stopped state.\n\n"
        "Regards,\nAWS Monitoring Script"
    )
with open("stopped_instances.txt", "rb") as f:
 msg.add_attachment(
     f.read(),
    maintype='application',
    subtype='octet-stream',
     filename='stopped_instances.txt'
        )
msg['To'] = 'RECEIVER_MAIL'
server = smtplib.SMTP('smtp.aol.com',587)
server.starttls()
server.login(
           'SENDER_MAIL',
           'APP PASSWORD')
server.send_message(msg)
server.quit()
print("email successfully sent ")

# remove stopped instaces file 
os.remove('stopped_instances.txt')










