#!/bin/bash
VXINTS="$(ip link show | grep vx | cut -d':' -f2)"
for i in $VXINTS; do ip link del dev $i; done

