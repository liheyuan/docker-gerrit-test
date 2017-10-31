#!/bin/bash
NODE_GERRIT_NAME="node-gerrit"
NODE_LDAP_NAME="node-ldap"
DOCKER_NAME="sbmvt-gerrit"
VOLUME_DATA='/var/lib/boot2docker/docker_data/gerrit'
LDAP_IP=$(docker-machine ip $NODE_LDAP_NAME)
WEB_IP=$(docker-machine ip $NODE_GERRIT_NAME)
LDAP_ACCOUNT_DN="dc=coder4,dc=com"
LDAP_ACCOUNT_PATTERN='(cn=${username})'
LDAP_SSHUSER_PATTERN='${cn}'
LDAP_FULLNAME_PATTERN='${cn}'
LDAP_QUERY_USERNAME='cn=admin,dc=coder4,dc=com'
LDAP_QUERY_PASSWORD='admin'
# env
eval $(docker-machine env $NODE_GERRIT_NAME)
last_id=$(docker ps -l -q)
docker rm -f $last_id

docker run \
    --rm \
    --name $DOCKER_NAME \
    -v "$VOLUME_DATA":/var/gerrit/review_site \
    -p 8080:8080 \
    -p 29418:29418 \
    -e AUTH_TYPE=LDAP \
    -e LDAP_SERVER=ldap://$LDAP_IP \
    -e LDAP_ACCOUNTBASE=$LDAP_ACCOUNT_DN \
    -e LDAP_ACCOUNTPATTERN=$LDAP_ACCOUNT_PATTERN \
    -e LDAP_ACCOUNTSSHUSERNAME=$LDAP_SSHUSER_PATTERN \
    -e LDAP_ACCOUNTFULLNAME=$LDAP_FULLNAME_PATTERN \
    -e LDAP_USERNAME=$LDAP_QUERY_USERNAME \
    -e LDAP_PASSWORD=$LDAP_QUERY_PASSWORD \
    -e WEBURL="http://$WEB_IP:8080" \
    -d openfrontier/gerrit:2.14.5.1
