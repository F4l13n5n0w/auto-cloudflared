#!/bin/bash

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
        else
            echo "¯\_(ツ)_/¯ no leet hax for you ¯\_(ツ)_/¯"
        fi

    echo ""
fi

# accept subdomain into script

# create tunnel
echo "worked"