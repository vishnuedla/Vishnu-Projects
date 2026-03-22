import yaml


#example for created nested dict and used in yaml module to generate the yaml file

#child dictonary

metadate={
     "labels":{
         "app": "webappp",
         "name": "webappp"
     }    
}

spec={
    "template":{
        "spec": {
            "container":{
                         "image":"docker.io/vishnu4538/nginxapp:8" ,
                          "name": "website" ,
                          "port": [80 , 9000, 700]
            }
        }
    }
}


# main dictonary for abov child dictonary 
data={

    "metadate":metadate,
    "spec": spec

}

print(data)

f=open("demo.yaml","w")
yaml.safe_dump(data,f)

f=open("demo.yaml", "r")
r=yaml.safe_load(f)

print(r["spec"]["template"]["spec"]["container"]["image"])