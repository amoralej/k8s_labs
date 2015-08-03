for i in $(ls /etc/kubernetes/*); do cp $i{,.orig}; echo "Making a backup of $i"; done

MASTER_NAME=

IP=$(ip a show eth0|grep -w inet|awk '{print $2}'|awk -F/ '{print $1}')

# Configure etcd store (single server)
sed -i 's/ETCD_LISTEN_CLIENT_URLS=.*/ETCD_LISTEN_CLIENT_URLS="http:\/\/0.0.0.0:4001"/g' /etc/etcd/etcd.conf
sed -i "s/ETCD_ADVERTISE_CLIENT_URLS=.*/ETCD_ADVERTISE_CLIENT_URLS=http:\/\/${IP}:4001/g" /etc/etcd/etcd.conf

systemctl enable etcd
systemctl restart etcd
systemctl status etcd

sleep 5

# Configure flannel

cat>flannel-config.json<<EOF
{
    "Network": "18.0.0.0/16",
    "SubnetLen": 24,
    "Backend": {
        "Type": "vxlan",
        "VNI": 1
     }
}
EOF

curl -L http://$IP:4001/v2/keys/coreos.com/network/config -XPUT --data-urlencode value@flannel-config.json

curl -L http://$IP:4001/v2/keys/coreos.com/network/config

cp /etc/sysconfig/flanneld{,.orig}

echo "FLANNEL_ETCD="http://$IP:4001"" >> /etc/sysconfig/flanneld

systemctl enable flanneld
systemctl start flanneld
systemctl restart flanneld

# Configure kubernetes apiserver

echo "KUBE_MASTER="--master=http://${IP}:8080"" >> /etc/kubernetes/config
sed -i "s/KUBE_API_ADDRESS=.*/KUBE_API_ADDRESS=--address=0.0.0.0/g" /etc/kubernetes/apiserver
echo "KUBE_ETCD_SERVERS="--etcd_servers=http://${IP}:4001"" >> /etc/kubernetes/apiserver 

systemctl enable kube-apiserver
systemctl restart kube-apiserver
systemctl status kube-apiserver

# Configure kubernetes scheduler

systemctl enable kube-scheduler
systemctl restart kube-scheduler
systemctl status kube-scheduler

# Configure kubernetes controller-manager 

systemctl enable kube-controller-manager
systemctl restart kube-controller-manager
systemctl status kube-controller-manager


# By default we enable the master as node as well for demo or small training environments

sed -i 's/KUBELET_ADDRESS=.*/KUBELET_ADDRESS="--address=0.0.0.0"/g' /etc/kubernetes/kubelet
sed -i 's/KUBELET_HOSTNAME=.*/#KUBELET_HOSTNAME=""/g' /etc/kubernetes/kubelet
sed -i "s/KUBELET_API_SERVER=.*/KUBELET_API_SERVER=--api_servers=http:\/\/${IP}:8080/g" /etc/kubernetes/kubelet

systemctl enable kubelet
systemctl restart kubelet
systemctl status kubelet

systemctl enable kube-proxy
systemctl restart kube-proxy
systemctl status kube-proxy

# Configure selinux to allow access to nfs 

setsebool -P virt_use_nfs 1



