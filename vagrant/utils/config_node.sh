for i in $(ls /etc/kubernetes/*); do cp $i{,.orig}; echo "Making a backup of $i"; done

MASTER_IP="kubemaster1.example.com"

if [ "$MASTER_IP" == "" ]
then
  echo "usage: config_node.sh <master ip>"
  exit 1
fi

# Configure selinux to allow access to nfs 

setsebool -P virt_use_nfs 1

# Configure flannel

echo "FLANNEL_ETCD="http://$MASTER_IP:4001"" >> /etc/sysconfig/flanneld

systemctl enable flanneld
systemctl start flanneld
systemctl restart flanneld

# Configure kubernetes services

echo "KUBE_MASTER="--master=http://${MASTER_IP}:8080"" >> /etc/kubernetes/config

sed -i 's/KUBELET_ADDRESS=.*/KUBELET_ADDRESS="--address=0.0.0.0"/g' /etc/kubernetes/kubelet
sed -i 's/KUBELET_HOSTNAME=.*/#KUBELET_HOSTNAME=""/g' /etc/kubernetes/kubelet
sed -i "s/KUBELET_API_SERVER=.*/KUBELET_API_SERVER=--api_servers=http:\/\/${MASTER_IP}:8080/g" /etc/kubernetes/kubelet

systemctl enable kubelet
systemctl restart kubelet
systemctl status kubelet

systemctl enable kube-proxy
systemctl restart kube-proxy
systemctl status kube-proxy


