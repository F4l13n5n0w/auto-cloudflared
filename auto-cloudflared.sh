#!/bin/bash

# Create usage with -f for FDQN for subdomain and also check if FDQN has been configured already. Optional Parameter being -p for port and also what folder you want to host

# Check if cloudflared binary is install if not ask user if they want to install

if ! command -v cloudflared &> /dev/null
    then
        echo "cloudflared could not be found"
        echo -n "Would you like to install cloudflared?  (y/n) "
        read install_binary_decision
        if [[ $install_binary_decision == "y" ]]; then
            echo "Grabbing latest cloudflared binary from GitHub.."; 
            wget -q "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb" && echo "Installing binary :)" && sudo dpkg -i "cloudflared-linux-amd64.deb"
            echo "Cleaning up downloaded binary..." && rm cloudflared-linux-amd64.deb

        else
            echo "¯\_(ツ)_/¯ no leet hax for you ¯\_(ツ)_/¯"
        fi
fi

# accept subdomain into script

# login into cloudflare and click hostname you would like to use to create a tunnel. You can probably verify login if ~/.cloudflared/cert.pem exists


FILE="$HOME/.cloudflared/cert.pem"
if [ -f "$FILE" ]; then
    echo "$FILE exists so you have already logged into CloudFlare:)"
else 
    echo "Please login with your CloudFlare credentials and choose the domain you would like to make a tunnel with!"
    cloudflared tunnel login
fi

# create tunnel
# probably a good idea to have a $name variable


echo -n "What would you like your tunnel name to be? "
read tunnel_name
if cloudflared tunnel list | grep -q $tunnel_name ; then
        echo "Tunnel already created :)"
    else
        cloudflared tunnel create $tunnel_name
fi

# Create DNS record but I can't find a way to do validation for this. I tried using dig to query CNAME of the FDQN but doesn't look like it appears. Something that also really annoys me is I cannot delete DNS CNAME records using cloudflared as well.

echo -n "Please specify the full FDQN you would like to make your create your tunnel on? "
read fqdn
cloudflared tunnel route dns $tunnel_name $fqdn

# Run tunnel and get them to verify web server is working

echo -n "What port would you like to run the web server on? "
read port
cloudflared tunnel run --url localhost:$port $tunnel_name &
python3 -m http.server $port &
wait

# DEBUG: For someone reason doesn't reach code below to look at later
# Would you like to delete the created entries?

# echo -n "Would you like to delete the newly created tunnel? (y/n)"
# read delete_decision
# if [[ $delete_decision == "y" ]]; then
#     cloudflared tunnel delete $tunnel_name
# else
#     "Bye! o/"
#     exit 1
# fi
