#!/bin/bash
source ~/.bashrc

GITSHA=$(git rev-parse --short HEAD)

case "$1" in
  container)
    sudo -u sathish docker build -t adderservice:$GITSHA .
    sudo -u sathish docker tag adderservice:$GITSHA sathisht2s/adderservice:$GITSHA 
    sudo -i -u sathish docker push sathisht2s/adderservice:$GITSHA 
  ;;
  deploy)
    sed -e s/_NAME_/adderservice/ -e s/_PORT_/8080/  < ../deployment/service-template.yml > svc.yml
    sed -e s/_NAME_/adderservice/ -e s/_PORT_/8080/ -e s/_IMAGE_/sathisht2s\\/adderservice:$GITSHA/ < ../deployment/deployment-template.yml > dep.yml
    sudo -i -u sathish kubectl apply -f $(pwd)/svc.yml
    sudo -i -u sathish kubectl apply -f $(pwd)/dep.yml
  ;;
  *)
    echo 'invalid build command'
    exit 1
  ;;
esac

