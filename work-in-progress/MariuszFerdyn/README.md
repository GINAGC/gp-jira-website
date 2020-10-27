# Reverse proxy with ICAP to mariusztst.atlassian.net

Includes:

- container Squid based reverse Proxy for a specific website, with ICAP integration (currently remarked)
- container ICAP Server
- certificates mini CA in files

**Current problems**

- This server could not prove that it is rzetelnekursy.pl; its security certificate does not specify Subject Alternative Names. - but accept certs seems to be working
- mariusztst.atlassian.net - never was able to work - maybe because of the previous cert problem
- www.gov.uk.glasswall-icap.com
- Built-in GW Rebuild ICAP service, can be changed by setting **ICAP_URL** in `gwproxy.env`

## Preparing environment:

```bash
sudo apt-get update && sudo apt-get install curl git -y
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo usermod -aG docker $( whoami )
```

You will have to logout and re-login before deploying the solution

## Preparing source code

0. Clone repository and goto the stable-src

```bash
git clone --recursive https://github.com/k8-proxy/gp-jira-website.git
cd gp-jira-website/work-in-progress/MariuszFerdyn/working-rzetelnekursy.pl
git submodule update # Update submodules
wget -O c-icap/Glasswall-Rebuild-SDK-Evaluation/Linux/Library/libglasswall.classic.so https://raw.githubusercontent.com/filetrust/Glasswall-Rebuild-SDK-Evaluation/master/Linux/Library/libglasswall.classic.so # Get latest evaluation build of GW Rebuild engine
```

1. If you are deploying the proxy for other websites, tweak `gwproxy.env`

## Deployment

3. Execute the following
   
   ```bash
   docker-compose build
   docker-compose up -d --force-recreate
   ```

4. Verify that all containers are up
   
   ```bash
   docker-compose ps
   ```  
   
5. Edit c:\windows\system32\drivers\etc\hosts
   
   ```bash
   docker-compose down
   ```

6. Edit c:\windows\system32\drivers\etc\hosts (of course use your ip, or 127.0.0.1)
   
   ```bash
   20.56.152.40 rzetelnekursy.pl
   #20.56.152.40 mariusztst.atlassian.net
   ```

6. Start MMC, Add Certificates snap-in, import rootCA-to-import.cer to Trusted Root Certification Authorities

7. Open browser navigate to https://rzetelnekursy.pl/
   
8. Shutdown
   
   ```bash
   docker-compose down
   ```
9. After Chrome will not alert about certificate we can start tests with mariusztst.atlassian.net
    
## CA

- CA work-in-progress\MariuszFerdyn\ownca2
  
  ```bash
  #Generate own CA (can be ignored - just I created)
  openssl genrsa -out rootCA.key 4096
  openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.crt
  #Create provate key
  openssl genrsa -out mariusztst.atlassian.net.key 2048
  #Two commands used as an alternative
  #openssl req -new -key mariusztst.atlassian.net.key -out mariusztst.atlassian.net.csr
  #openssl req -new -sha256 -key mariusztst.atlassian.net.key -subj "/C=US/ST=CA/O=MyOrg, Inc./CN=mariusztst.atlassian.net" -out mariusztst.atlassian.net.csr
  #Generate request with Subject Alternative name based on file mariusztst.atlassian.net.req.txt
  openssl req -new -sha256 -out mariusztst.atlassian.net.csr -key mariusztst.atlassian.net.key -config mariusztst.atlassian.net.req.txt
  #Check the request
  openssl req -text -noout -in mariusztst.atlassian.net.csr
  #Signe the request
  openssl x509 -req -in mariusztst.atlassian.net.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out mariusztst.atlassian.net.crt -days 500 -sha256
  ```

  After that, you must copy certs to working-rzetelnekursy.pl\squid\certs or notworking-mariusztst.atlassian.net\squid\certs
