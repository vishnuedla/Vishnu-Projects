import psutil
import smtplib
from email.message import EmailMessage
import time
from alert import email_alert

process_id=5985

while True:
# Check status of a specific PID
 try:
   proc = psutil.Process(process_id)
 except psutil.NoSuchProcess:
    print(f"Process with PID {process_id} does not exist.")
    email_alert(process_id)
 else:
    if proc.status() == 'running'or proc.status() == 'sleeping':
     print("Process is running or sleeping.")
 time.sleep(30)
