import smtplib
from email.message import EmailMessage

def email_alert(pid):
    msg = EmailMessage()
    msg['Subject'] = f'Process with PID 287 is not running'
    msg['From'] = 'edlavishnu@aol.com'
    msg.set_content(
        "Hello,\n\n"
       f"The process with PID {pid} is not running.\n\n"
        "Regards,\nAWS Monitoring Script"
    )
    msg['To'] = 'edlavishnu2000@gmail.com'
    server = smtplib.SMTP('smtp.aol.com',587)
    server.starttls()
    server.login(
           'edlavishnu@aol.com',
           'xotp pyqk cgwg ayga')
    server.send_message(msg)
    server.quit()
    print("email successfully sent ")
