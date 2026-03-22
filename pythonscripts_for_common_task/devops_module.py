import yaml

def patter_match(pattern,filename):
  try:
    file=open(filename,'r')
  except FileNotFoundError:
    print("Enter the correct file name and path or entered file is no exist")
  else:
    lines= file.readlines()
    for line in lines:
        if pattern in line:
            print(f"we found the {pattern}  at {filename}")
            print('Exactly line in file is' , f"{line}")
        else:
            continue




def update_image(id,filename):
  try:
    f = open(filename, "r")
  except FileNotFoundError:
      print("Enter the correct file name and path or entered file  is no exist")
  else:
    r = yaml.safe_load(f)
    r["spec"]["template"]["spec"]["containers"][0]["image"]=f"docker.io/vishnu4538/nginxapp:{id}"
    f = open(filename, "w")
    print("changing the image tag ....")
    yaml.dump(r, f)
    f.close()
    f=open(filename,"r")
    r=yaml.safe_load(f)
    print(f"Image changed to {id}")
    print(r)
