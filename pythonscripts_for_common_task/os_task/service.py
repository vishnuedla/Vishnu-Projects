import subprocess

pid = subprocess.getoutput("pidof nginx")
print(pid)
