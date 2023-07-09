# Notes

Some notes about the content of the folders

## 1_dev_env
- no comments

### Software used
- Docker Desktop + wsl 
- docker 23.0.5
- docker-compose v2.17.3

## 2_k8s_res
Some comments:
- `cuapp.yaml` the file with the maniftests to evaluate
- `helm-ver` this is a plus, it's the Helm Chart usefull to generate an enanched version of the previous file with custom images. Please, to watch the manifests, move inside the folder and  use the command: `helm -n <your-namespace> template . `.
- usually I skip the NodePort option but to test it I used KinD to test it so Loadbalncer wasn't viable solution in my case.
- I don't understand why we don't have Ingress maybe servicemash so in that case clusterIp or a headless service could be a better solutions.

### Software used
- KinD  v0.20.0
- k8s 1.27.3
- k9s v0.27.4
- kubectl 1.25.9 (I known it must be same version of k8s but I had no time, and I knew i was going to use stable k8s api)
- helm v3.12.1


### How to test
To test it apply the yaml to your k8s ns and then you can directly acces to the `http://<your-node-ip>:30007` of you cluster. But a more confortable way in my opinion (to bypass VPC or some network problem as I experimented with KinD) is to use port-forwad with kubectl: `kubectl -n <your-namespace> port-forward service/curp-service 8080`.


## 3_dep_prod
Some comments:
- this project use another GitHub project: https://github.com/gigiozzz/cu331t-codebuild-src
- you can find some considerations about policies inside the tf code
- although buildpsec.yaml is an infrastructure element, I have included it in the [repository of the app source code](https://github.com/gigiozzz/cu331t-codebuild-src) for practical reasons (i will change it usually when i will change the app/Docker) and to a trend thati like (think at the .githubflow or to .gitlab-ci.yaml placed inside the repository of the app source code)
- to run it enter the folder e type the commands below:
```
terraform init
terraform plan
terraform apply
```

### Software used
- aws-cli 2.13.0
- latest codebuild agent script with the image public.ecr.aws/codebuild/amazonlinux2-x86_64-standard:5.0
- terraform v1.5.0
- tf aws provider 4.16