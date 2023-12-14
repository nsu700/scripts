#!/bin/bash

master_cert_list=(admin.crt ca-bundle.crt ca.crt master.etcd-ca.crt master.etcd-client.crt master.kubelet-client.crt master.server.crt openshift-master.crt openshift-registry.crt openshift-router.crt service-signer.crt)
node_list=(nodea, nodeb, nodec)
master_nodes=(master1, master2, master3)
function show_cert() {
  cert=$(openssl crl2pkcs7 -nocrl -certfile /dev/stdin | openssl pkcs7 -print_certs -text | grep Validity -A3 -1)
  expireDate=$(echo "$cert" | grep "Not After" | sed 's/.*Not After : //' | xargs -n 1 -I {} date -d {} --utc +"%m-%d-%Y")
  issuer=$(echo "$cert"  | grep Issuer | sed 's/.*CN=//')
  subject=$(echo "$cert"  | grep Subject | sed 's/.*CN=//')
  printf "%-60s%-30s%-30s\n" "$subject" "$expireDate" "$issuer"
}

echo "------------------------- all nodes' kubelet TLS certificate for openshift 3.11 only -------------------------"
for node in `oc get nodes |awk 'NR>1'|awk '!/NotReady/{print $1}'`; do
  echo $node
  ssh $node "sudo cat /etc/origin/node/certificates/kubelet-client-current.pem" | show_cert
done

echo "------------------------- master TLS certificate for openshift 3.11 only-------------------------"
for node in `oc get nodes -l node-role.kubernetes.io/master=true | awk 'NR>1'|awk '!/NotReady/{print $1}'`;do
    echo $node
    for cert in $master_cert_list; do
        ssh $node "sudo openssl x509 -in /etc/origin/master/$cert -noout -enddate -issuer" | awk -v fileName=$cert -F"=" '{getline c;split(c,con,"=");printf "%-60s%-30s%-30s\n",fileName,\$NF,con[3]}'
    done
done

echo "------------------------- all nodes' kubelet TLS certificate for openshift 3.3 only -------------------------"
for node in $node_list; do
  echo $node
  ssh $node "sudo openssl x509 -in /etc/origin/node/server.crt -noout -enddate -issuer" | awk -v fileName="server.crt" -F"=" '{getline c;split(c,con,"=");printf "%-60s%-30s%-30s\n",fileName,\$NF,con[3]}'
  ssh $node "sudo openssl x509 -in /etc/origin/node/system:node:$node.crt -noout -enddate -issuer" | awk -v fileName="$node.crt" -F"=" '{getline c;split(c,con,"=");printf "%-60s%-30s%-30s\n",fileName,\$NF,con[3]}'
done

echo "------------------------- master TLS certificate for openshift 3.3 only-------------------------"
for node in $master_nodes;do
    echo $node
    for cert in $master_cert_list; do
        ssh $node "sudo openssl x509 -in /etc/origin/master/$cert -noout -enddate -issuer" | awk -v fileName=$cert -F"=" '{getline c;split(c,con,"=");printf "%-60s%-30s%-30s\n",fileName,\$NF,con[3]}'
    done
done
