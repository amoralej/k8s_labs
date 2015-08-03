#!/bin/bash

echo "ADD_REGISTRY='--add-registry registry.access.redhat.com --add-registry 10.32.244.206:5000'" >> /etc/sysconfig/docker
echo "INSECURE_REGISTRY='--insecure-registry 10.32.244.206:5000'" >> /etc/sysconfig/docker
systemctl restart docker

