# Deployment of Blood bank app on kubernetes

# Install the Kind in your local https://kind.sigs.k8s.io/docs/user/quick-start/#installation

Follow below steps to setup the application on kind cluster

create the cluster using below commands
kind create cluster --name cluster name

Create namespace for bloodbank app by applying manifest file

kubectl apply -f namespace.yml

create persistent volume for database using pv.yml , pvc.yml

cd database

first apply pv.yml using below command
 
kubectl apply -f pv.yml

kubectl apply -f pvc.yml

Create the mongodb statefulset.
kubectl apply -f mongodb.yml

create service to expose the mongodb
kubectl apply -f mongoservice.yml

After successfully deploymnet of mongodb now this time to deploy the backend

Move to backend directory  

cd  backend 
first apply pv.yml using below command
kubectl apply -f pv.yml
kubectl apply -f pvc.yml

Create the secret backend deployment and service using below command 
kubectl apply -f secret.yml
kubectl apply -f backend.yml
kubectl apply -f service.yml

Before applying VPA yaml follow below steps:

git clone https://github.com/kubernetes/autoscaler

cd autoscaler

cd vertical-pod-autoscaler

cd deploy

apply the all manifest files in deploy directory.
k apply -f .

kubectl apply -f vpa.yml (autoscaling when resource increase when reaching threshold)
Move to frontend directory

kubectl apply -f Frontend.yml
kubectl apply -f service.yml
kubectl apply -f hpa.yml ( autoscaling CPU  when reaching threshold)


you can do the port forwarding using below to see the website.

kubectl port-forward svc/frontend 8080 : 80


check the localhost:8080
<img width="1920" height="1008" alt="image" src="https://github.com/user-attachments/assets/3c31ec8e-1a6f-476b-97a9-9c61bb939c22" />

<img width="1920" height="1008" alt="image" src="https://github.com/user-attachments/assets/535f1c64-eb1d-4a39-baac-6e40e299e15b" />

<img width="1920" height="1008" alt="image" src="https://github.com/user-attachments/assets/ad127bff-689a-4b61-a9aa-49a571a5548c" />


<img width="1920" height="1008" alt="image" src="https://github.com/user-attachments/assets/9c4fd708-4e7f-4de8-94ba-40f445c3ea83" />


optionally you can apply the ingress 

