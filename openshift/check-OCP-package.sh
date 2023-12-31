#!/bin/bash
set -x
OCP_RELEASE="${1}"
PACKAGE="${2}"
URL=https://releases-rhcos-art.apps.ocp-virt.prod.psi.redhat.com

OCP_MAJOR="$(echo "${OCP_RELEASE}" | awk -F. '{print $1"."$2}')"
RHCOS_VERSION="$(oc adm release info "${OCP_RELEASE}" -o jsonpath='{.displayVersions.machine-os.Version}')"

curl -sk "$URL/storage/releases/rhcos-${OCP_MAJOR}/${RHCOS_VERSION}/x86_64/commitmeta.json" | jq -r '.["rpmostree.rpmdb.pkglist"]|map(select(.[0]=="'"${PACKAGE}"'"))[0]|.[0]+"-"+.[2]+"-"+.[3]+"."+.[4]'
