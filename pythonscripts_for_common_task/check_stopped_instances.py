import boto3
import smtplib
from email.message import EmailMessage
import os



def ec2():
    ec2 = boto3.client('ec2')
    response = ec2.describe_instances()

    list_instance = response['Reservations']

    # Write stopped instances to file
    for instance in list_instance:
        status = instance['Instances'][0]['State']['Name']
        instance_id = instance['Instances'][0]['InstanceId']

        if status == "stopped":
            with open("stopped_instances.txt", "a") as file:
                file.write(f"Instance {instance_id} is stopped.\n")
        else:
            with open("stopped_instances.txt", "a") as file:
             file.write(f"No Stopped instances.\n")
            file.close()
            break


    # Prepare email
    msg = EmailMessage()
    msg['Subject'] = 'List of EC2 instances in stopped state'
    msg['From'] = 'SENDERMAIL'
    msg['To'] = 'RECEIVER EMAIL'
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

    try:
        server = smtplib.SMTP('smtp.aol.com', 587)
        server.starttls()
        server.login('SENDERMAIL',
           'APP PASSWORD')
        server.send_message(msg)
        server.quit()
        print("Email successfully sent")
    except Exception as e:
        print(f"Failed to send email: {e}")
    os.remove('stopped_instances.txt')

ec2()

