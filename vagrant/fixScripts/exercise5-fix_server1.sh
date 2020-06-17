#!/bin/bash
#add fix to exercise5-server1 here
#apply for servers' root user and vagrant as well
apt-get install sshpass
echo "666336tT" > passwordroot.txt
TMP_PASs="vagrant"

ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
ssh-keyscan -H 192.168.100.11 >> ~/.ssh/known_hosts
ssh-keyscan -H server2 >> ~/.ssh/known_hosts

sshpass -f passwordroot.txt ssh-copy-id -i ~/.ssh/id_rsa.pub 192.168.100.11
sshpass -p "$TMP_PASs" ssh-copy-id -i ~/.ssh/id_rsa.pub vagrant@192.168.100.11