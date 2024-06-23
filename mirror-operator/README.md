# A script to mirror operator for disconnected OCP

The script only tested in RHEL8
Better to have at least 2core and 4GB ram to run this script, as oc-mirror heavily use memory to cache the operator images, hence the more operator you want to mirror, the more memory is required. Or you may find the script being terminated due to oom

## Prequiste
podman
pull-secret
oc
oc-mirror

## Reference
https://access.redhat.com/solutions/6994677
