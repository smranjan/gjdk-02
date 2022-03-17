#!/bin/bash
#sed "s/tagVersion/$1/g" pods_services.yaml > pods_services_01.yaml
sed -i "s/tagVersion/$1/g" k8s/pods_services.yaml