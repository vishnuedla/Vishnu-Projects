#!/bin/bash


username=vishnu4538 # docker account  username

#delete image line

sed -i {"/image:/d"} vishnu.yml

sleep 9s

#Adding image line to file $1 is username of docker and $2 is for tag

sed -i "19i\        image: docker.io/$username/nginxapp:$1" vishnu.yml

sleep 9s

git add .

git commit -m "image verion changed to $1"

echo "We have committed tag change to $1"

git push origin main 

echo " we have sucessfully pushed the updated image to $username account with tag version $1"

