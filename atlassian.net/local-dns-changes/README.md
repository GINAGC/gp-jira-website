# Reverse proxy configuration for mariusztst.atlassian.net, os-summit.atlassian.net, glasswall.atlassian.net - 

## Requirements

- **Ubuntu LTS** (Tested on Ubuntu 18.04 LTS)*

- **Git**

- **local-dns-changes is mandatory - this solution uses the same source and destination domain**

> *WSL (Windows Subsystem Linux) is not supported

## Installation

- Execute the following to install the dependencies mentioned above
  
  ```bash
    sudo apt install -y curl git
    curl https://get.docker.com | bash -
    sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo usermod -aG docker $(whoami)
  ```
  
  You need to logout and re-login after this step

- Prepare the repositories
  
  ```bash
    git clone --recursive https://github.com/k8-proxy/k8-reverse-proxy.git
    git clone https://github.com/k8-proxy/gp-jira-website
    wget https://github.com/filetrust/Glasswall-Rebuild-SDK-Evaluation/releases/download/1.117/libglasswall.classic.so -O k8-reverse-proxy/stable-src/c-icap/Glasswall-Rebuild-SDK-Evaluation/Linux/Library/libglasswall.classic.so
    cp -rf gp-jira-website/* k8-reverse-proxy/stable-src/
    cd k8-reverse-proxy/stable-src/
  ```

- copy SSL credentials
  
  ```bash
    cp -f full.pem nginx/
	cp -f squid.pem squid/
  ```

- Start the deployment 
  
  ```bash
    docker-compose up -d --force-recreate --build
  ```
  
  You will need to use this command after every change to any of the files.
  
  ## Client configuration

- Add hosts records to your client system hosts file ( i.e **Windows**: C:\Windows\System32\drivers\etc\hosts , **Linux, macOS and  Unix-like:** /etc/hosts ) as follows
  
  ```
  127.0.0.1 mariusztst.atlassian.net
  127.0.0.1 os-summit.atlassian.net
  127.0.0.1 glasswall.atlassian.net
  127.0.0.1 api.media.atlassian.com
  ```
  
  In case the machine running the project is not your local computer, replace **127.0.0.1** with the project host IP,
  
  make sure that tcp ports **80** and **443** are reachable and not blocked by firewall.
  
  ## Access the proxied site
  
  You can access the proxied site by browsing:
- https://mariusztst.atlassian.net/
- https://os-summit.atlassian.net/
- https://glasswall.atlassian.net/

- ** Please remember adding `CA.crt` to your browser/system ssl trust store.