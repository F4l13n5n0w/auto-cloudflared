#!/bin/bash

# Create usage with -f for FDQN for subdomain and also check if FDQN has been configured already. Optional Parameter being -p for port 

# Check if cloudflared binary is install if not ask user if they want to install

if ! command -v cloudflared &> /dev/null
    then
        echo "cloudflared could not be found"
        echo -n "Would you like to install cloudflared?  (y/n) "
        read install_binary_decision
        if [[ $install_binary_decision == "y" ]];
        then
            echo "Grabbing latest cloudflared binary from GitHub.."; 
            wget -q "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb" && echo "Installing binary :)" && sudo dpkg -i "cloudflared-linux-amd64.deb"
            echo "Cleaning up downloaded binary..." && rm cloudflared-linux-amd64.deb

        else
            echo "¯\_(ツ)_/¯ no leet hax for you ¯\_(ツ)_/¯"
        fi
fi

# accept subdomain into script

# login into cloudflare and click hostname you would like to use to create a tunnel. You can probably verify login if ~/.cloudflared/cert.pem exists

echo "cloudflared tunnel login"

# create tunnel
# probably a good idea to have a $name variable

echo "cloudflared tunnel create <NAME>"

# create configuration file (this step might be optional might need more research)
# needs $name and $hostname

echo "cloudflared tunnel route dns <NAME> <HOSTNAME>"

# Run tunnel and get them to verify web server is working

echo "cloudflared tunnel run url localhost:<port>"
echo "verify"
