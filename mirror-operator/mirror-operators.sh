#!/bin/bash
LOCAL_REGISTRY=192-168-166-137.sslip.io:5000
REGISTRY_USER=dummy
REGISTRY_PW=dummy
REGISTRY_CERT=./cert
PULL_SECRET=./pull-secret.txt
REDHAT_OPERATOR=cluster-logging,compliance-operator,elasticsearch-operator,file-integrity-operator,local-storage-operator
VERSION=4.12
MIRROR_CONFIG_FILE=./mirror-config.yaml

# Prepare login credential
which podman >/dev/null 2>&1
if [ $? == 0 ]; then
  cp $PULL_SECRET /run/user/`id -u`/containers/auth.json
fi

# Check for require cli
check_bin() {
  which $1 >/dev/null 2>&1
  if [ $? != 0 ]; then
    echo "Downloading $2..."
    curl -L --fail https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/$2 -o $2

    if [ $? != 0 ]; then
      echo "Error: Failed to download $2. Please check your internet connection and try again."
      exit 1
    fi

    # Unzip the package
    echo "Extracting the package..."
    sudo tar -xvzf $2 -C /usr/bin
    sudo chmod +x /usr/bin/$1
  else
    echo "$1 already installed."
  fi
}

# Check required cli
check_bin oc openshift-client-linux.tar.gz
check_bin oc-mirror oc-mirror.tar.gz
check_bin opm opm-linux.tar.gz


# Prepare the mirror config, for reference, please check https://docs.openshift.com/container-platform/4.11/updating/updating-restricted-network-cluster/mirroring-image-repository.html#oc-mirror-creating-image-set-config_mirroring-ocp-image-repository
if [ ! -z "$REDHAT_OPERATOR" ]; then
  cat <<EOF > "$MIRROR_CONFIG_FILE"
kind: ImageSetConfiguration
apiVersion: mirror.openshift.io/v1alpha2
archiveSize: 4
storageConfig:
  registry:
    imageURL: "${LOCAL_REGISTRY}/ocp4-mirror/metadata"
mirror:
  operators:
  - catalog: registry.redhat.io/redhat/redhat-operator-index:v$VERSION
    packages:
EOF

  for operator in ${REDHAT_OPERATOR//,/ }; do
    echo "
      - name: $operator" >> "$MIRROR_CONFIG_FILE"
  done
fi


# Start mirroring of images
echo "Starting mirroring images, the process will take a while to finish"
[[ -f $REGISTRY_CERT ]] && export SSL_CERT_FILE=$REGISTRY_CERT
oc-mirror --config $MIRROR_CONFIG_FILE docker://$LOCAL_REGISTRY
