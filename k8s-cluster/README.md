# How to create single node k8s

<img src="https://d39w7f4ix9f5s9.cloudfront.net/dims4/default/f41a71b/2147483647/strip/true/crop/1200x542+0+44/resize/1440x650!/quality/90/?url=http%3A%2F%2Famazon-blogs-brightspot.s3.amazonaws.com%2F40%2Fb0%2F16d665224675bf7ecf4431d1e9ca%2Faws-logo-smile-1200x630.png" alt="aws" width="500"/>

_____

- Open createInstance.sh and createSG.sh
- Cutomize default values and run ```./createInstance.sh and ./createSG.sh``` or send your custom values inline:
```
./createSG.sh GROUP_NAME DESC
./createInstance.sh KEY_NAME
```
At end of running createInstance.sh script the output shows you an INSTANCE_ID. use it for removing instance.


- To remove instance:
```
aws ec2 terminate-instances --instance-ids INSTANCE_ID
```

- type ./createAMI.sh --help for more information

________

- Login to your instance using ssh:
```
ssh ubuntu@{INSTANCE_IP}
```

- Switch to root user:
```
sudo su
```

- Change directory to k8s installation
```
cd /root/k8s/
```

- Check cluster health
```
kubectl --kubeconfig ./kube_config_cluster.yml get nodes
```

_____

### Adding more nodesto cluster:

- open cluster.yml and add nodes and options
- Download rke release: https://github.com/rancher/rke/releases
- ./rke up
### Done!
______
Full doc:
https://github.com/rancher/rke
