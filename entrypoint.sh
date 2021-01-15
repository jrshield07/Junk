#!/bin/bash
echo "installing access-manager"
/usr/local/tomcat/bin/catalina.sh run & (sleep 20 && /data/setup.sh)
