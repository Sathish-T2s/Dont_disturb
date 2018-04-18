#!/bin/bash
source ~/.bashrc

GITSHA=$(git rev-parse --short HEAD)

case "$1" in
  container)
    sudo -u sathish docker build -t eventservice:$GITSHA .
    sudo -u sathish docker tag eventservice:$GITSHA sathisht2s/eventservice:$GITSHA 
    sudo -i -u sathish docker push sathisht2s/eventservice:$GITSHA 
  ;;
  deploy)
    sed -e s/_NAME_/eventservice/ -e s/_PORT_/8082/  < ../deployment/service-template.yml > svc.yml
    sed -e s/_NAME_/eventservice/ -e s/_PORT_/8082/ -e s/_IMAGE_/sathisht2s\\/eventservice:$GITSHA/ < ../deployment/deployment-template.yml > dep.yml
    sudo -i -u sathish kubectl apply -f $(pwd)/svc.yml
    sudo -i -u sathish kubectl apply -f $(pwd)/dep.yml
  ;;
  *)
    echo 'invalid build command'
    exit 1
  ;;
esac

