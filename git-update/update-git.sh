#!/bin/bash
cd /ffks/gateway-helper-scripts
sudo git pull

cd /etc/fastd/ffks_vpn/nodes
sudo git pull
sudo systemctl reload fastd@ffks_vpn.service
