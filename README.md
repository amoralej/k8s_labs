k8s Labs - RHEL Atomic 
======================

Supporting documentation and files.

Installation Prerequisites
---------------------------

You will need either Libvirt or VirtualBox installed to provision the Atomic virtual machines needed for this lab.

Libvirt Installation
--------------------

As root grab the Atomic qcow image make three copies of in the libvirt images directory

```
su -
cd /tmp
wget wget http://10.32.244.206/images/rhel-atomic-cloud-7.1-1.x86_64.qcow2
cp rhel-atomic-cloud-7.1-1.x86_64.qcow2 /var/lib/libvirt/images/rhel-atomic-cloud-7.1-1.x86_64-00.qcow2
cp rhel-atomic-cloud-7.1-1.x86_64.qcow2 /var/lib/libvirt/images/rhel-atomic-cloud-7.1-1.x86_64-01.qcow2
cp rhel-atomic-cloud-7.1-1.x86_64.qcow2 /var/lib/libvirt/images/rhel-atomic-cloud-7.1-1.x86_64-02.qcow2

# Copy over iso from 

# Correct the 

# Clean up the original file if you like
rm /tmp/rhel-atomic-cloud-7.1-1.x86_64.qcow2
```

Once you have booted your atomic vm login with:

username: cloud-user
password: atomic


```
# Become root
sudo -i
```

```
# Register your host with rhn (you will need you subscription username and password)
subscription-manager register
```

```
# Attach the host
subscription-manager attach --auto
```

```
# Use these discovery commands if you have issues registering your host.
subscription-manager list
subscription-manager list --available
```

```
# Edit the docker settings to allow insecure access to insecure registers 
/etc/sysconfig/docker
```

```
ADD_REGISTRY='--add-registry registry.access.redhat.com --add-registry 10.32.244
INSECURE_REGISTRY='--insecure-registry 10.32.244.206:5000'
```

```
# Reboot the system
systemctl reboot
```

You will need to login back into the host and update the system

```
# Upgrade the host
atomic host upgrade
```
