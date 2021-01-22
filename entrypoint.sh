#!/bin/bash
echo "installing access-manager"
chmod 750 /forgerock/openam/security/keystores/*
/usr/local/tomcat/bin/catalina.sh run & (sleep 50 && /data/setup.sh)
