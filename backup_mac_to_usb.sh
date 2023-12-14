#!/bin/bash
BK_PATH=/Volumes/docs/mac-backup

# Backup ~/Dev folder
mkdir $BK_PATH/Dev
rsync -avz --delete --exclude 'Dev/kubernetes' --exclude '*must-gather*' --exclude 'Dev/cloudnative.to' --exclude 'origin' --exclude 'go/pkg' --exclude '.terraform' --exclude '.git' --exclude az400-delete --exclude 'Dev/cluster-version-operator' --exclude openshiftv4-ingress-controller --exclude openshift-source --exclude service-catalog --exclude vmware --exclude cluster-authentication-operator --exclude kubernetes-incubator --exclude local-storage-operator ~/Dev $BK_PATH/Dev

# Backup ssh key
mkdir $BK_PATH/ssh
cp -r ~/.ssh/* $BK_PATH/ssh

# Backup k8s auth
mkdir $BK_PATH/kube
cp -r ~/.kube/* $BK_PATH/kube

# Backup aws credential
mkdir $BK_PATH/aws
cp -r ~/.aws/* $BK_PATH/aws

# Backup ~/Docs folder
mkdir $BK_PATH/docs
rsync -avz --delete --exclude 'cases' --exclude 'go/pkg' --exclude '.terraform' --exclude '.git' $BK_PATH/docs
