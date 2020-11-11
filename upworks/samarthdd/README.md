#Atlassian Jira Glasswall Proxy Site

##Steps 

    1.Launch Rancher

        docker run -d --restart=unless-stopped -p 8080:80 -p 8443:443 --privileged rancher/rancher:latest
    
    2.Setup AWS cloud credentials
        
        Under profile, select "Cloud Credentials" and click on "Add Cloud Credentails". Populate the details of region, access key, secret key, credentails name and save it.
        
    3.Create an ec2 node template.
        Under profile, select "Node templates" and click on "Add template". Choose Amazon ec2 type for node template and fill it.
        
    4.Create a K8s cluster.
        Go to Clusters in rancher UI.

        Click on Add cluster. Provide a cluster name and Name prefix for nodes.

    5.Copy k8 custer config and setup cluster
        export KUBECONFIG=kubeconfig
        kubectl get nodes
        
    6.Run following commands
        mkdir jira_proxy
        cd jira_proxy/
        https://github.com/k8-proxy/s-k8-proxy-rebuild
        https://github.com/k8-proxy/k8-reverse-proxy
        
    7. Add certificate
    
        git clone https://github.com/k8-proxy/gp-engineering-website
        wget https://github.com/filetrust/sdk-rebuild-eval/raw/master/libs/rebuild/linux/libglasswall.classic.so -O k8-reverse-proxy/stable-src/c-icap/Glasswall-Rebuild-SDK-Evaluation/Linux/Library/libglasswall.classic.so
    8. Copy openssl.cnf and govproxy.env to gp-engineering-website/
    
    9.Run below command and create cert
        cp -rf gp-engineering-website/* k8-reverse-proxy/stable-src/
        cd k8-reverse-proxy/stable-src/
        ./gencert.sh
        mv full.pem nginx/
    
    10.Push images to dockerhub

        docker login
        
        docker build nginx -t <docker registry>/reverse-proxy-nginx:0.0.1
        docker push <docker registry>/reverse-proxy-nginx:0.0.1
        
        docker build squid -t <docker registry>/reverse-proxy-squid:0.0.1
        docker push <docker registry>/reverse-proxy-squid:0.0.1
        
        wget -O c-icap/Glasswall-Rebuild-SDK-Evaluation/Linux/Library/libglasswall.classic.so https://github.com/filetrust/Glasswall-Rebuild-SDK-Evaluation/releases/download/1.117/libglasswall.classic.so # Get latest evaluation build of GW Rebuild engine
        docker build c-icap -t <docker registry>/reverse-proxy-c-icap:0.0.1
        docker push <docker registry>/reverse-proxy-c-icap:0.0.1
        
     11. Copy the values.yaml to s-k8-proxy-rebuild/stable_src/chart/ 
     
     12.cd s-k8-proxy-rebuild/stable_src/
       
     13.Run helm command and deploy proxy site.
        
        helm upgrade --install \
        --set image.nginx.repository=samarth7/reverse-proxy-nginx \
        --set image.nginx.tag=0.0.1 \
        --set image.squid.repository=samarth7/reverse-proxy-squid \
        --set image.squid.tag=0.0.1 \
        --set image.icap.repository=samarth7/reverse-proxy-c-icap \
        --set image.icap.tag=0.0.1 \
        reverse-proxy chart/
        
        kubectl get pods
        
     14.Add proxy IP address to /etc/hosts
     
        Get IP from commond
            kubectl get ing
            
        Add following
            18.188.203.127  samarthdd.atlassian.net.glasswall-icap.com                            
            18.188.203.127  os-summit.atlassian.net.glasswall-icap.com
            18.188.203.127  api.media.atlassian.com.glasswall-icap.com
            18.188.203.127  id.atlassian.com.glasswall-icap.com
                
        
      
    
    
