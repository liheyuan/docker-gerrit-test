#!/bin/bash
NODE_NAME="node-gerrit"
docker-machine start $NODE_NAME
docker-machine regenerate-certs -f $NODE_NAME 
