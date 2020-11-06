# Reverse proxy configuration for mariusztst.atlassian.net, os-summit.atlassian.net, glasswall.atlassian.net - 

## Requirements

- **Ubuntu LTS** (Tested on Ubuntu 18.04 LTS)*

- **Git**

- **no-local-dns-changes - this solution is not working needs more investigatios "Origin https://id.atlassian.com.glasswall-icap.com.glasswall-icap.com is not allowed. Behavior used for check: WEB ORIGINS"**

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
    cp -rf gp-jira-website/atlassian.net/no-local-dns-changes/* k8-reverse-proxy/stable-src/
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
  127.0.0.1 id.atlassian.com.glasswall-icap.com
  127.0.0.1 start.atlassian.com.glasswall-icap.com
  127.0.0.1 mariusztst.atlassian.net.glasswall-icap.com
  127.0.0.1 id.atlassian.net.glasswall-icap.com
  127.0.0.1 start.atlassian.net.glasswall-icap.com
  127.0.0.1 os-summit.atlassian.net.glasswall-icap.com
  127.0.0.1 glasswall.atlassian.net.glasswall-icap.com
  127.0.0.1 auth.atlassian.com.glasswall-icap.com
  127.0.0.1 aid-frontend.prod.atl-paas.net.glasswall-icap.com
  127.0.0.1 cpfs-cdn.atlassian.com.glasswall-icap.com
  127.0.0.1 api.media.atlassian.com.glasswall-icap.com
  ```
  
  In case the machine running the project is not your local computer, replace **127.0.0.1** with the project host IP,
  
  make sure that tcp ports **80** and **443** are reachable and not blocked by firewall.
  
  ## Access the proxied site
  
  You can access the proxied site by browsing site without CORS - "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --disable-web-security --disable-gpu --user-data-dir=~/chromeTemp:
- https://mariusztst.atlassian.net.glasswall-icap.com/
- https://glasswall.atlassian.net.glasswall-icap.com/
- https://os-summit.atlassian.net.glasswall-icap.com/

- ** Please remember adding `CA.cer` to your browser/system ssl trust store.

  ## Debug usefull commands
  ```bash
    docker-compose exec nginx /bin/bash
	docker-compose exec squid /bin/bash
	docker-compose down
	docker rmi $(docker images -a -q)
  ```