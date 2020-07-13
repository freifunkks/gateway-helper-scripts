#!/bin/bash

###########################################
### HIER MÜSSEN ALLE GWS DEFINIERT SEIN ###
GWS="10 17"
###########################################



function getvxlanid {
if [ "$REALHOSTNAMENUMBER" -lt "$gw" ]; then
	vxhost1="$REALHOSTNAMENUMBER"
	vxhost2="$gw"
else
	vxhost1="$gw"
	vxhost2="$REALHOSTNAMENUMBER"
fi
vxlanid="1${vxhost1}${vxhost2}"
}

function connect {
echo "connecting t-gw-$REALHOSTNAMENUMBER to t-gw-$gw via $vxlanid"
ip -6 link add vx${vxlanid} type vxlan id $vxlanid dstport 4789 local fcff:fdfd:fdfd:fdfd:${REALHOSTNAMENUMBER}::${REALHOSTNAMENUMBER} remote fcff:fdfd:fdfd:fdfd:${gw}::${gw} dev wgffksgws0 ttl 2
ip link set address 56:ae:94:${gw}:75:${REALHOSTNAMENUMBER} dev vx${vxlanid}
ip link set up dev vx${vxlanid}
batctl if add vx${vxlanid}
}

for gw in $GWS; do
	HOSTNAME="t-gw-$gw"
	REALHOSTNAME="$(hostname)"
	REALHOSTNAMENUMBER="$(echo $REALHOSTNAME|rev|cut -d'-' -f1|rev)"
	#echo "My local Hostname should be: $REALHOSTNAME; Connecting to: $HOSTNAME"
	#echo "Local: $REALHOSTNAMENUMBER Remote: $gw"

	getvxlanid
	#echo "VXLAN ID: 1${vxhost1}${vxhost2}"
	#echo "$vxlanid : vx${vxlanid}"

	if [ "$HOSTNAME" != "$REALHOSTNAME" ]; then
		#echo "CONNECTING $HOSTNAME"
		connect
#	else
#		true
#		#echo "NOT CONNECTING $HOSTNAME"
	fi
done
