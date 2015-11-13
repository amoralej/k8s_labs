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
wget http://10.32.244.206/images/rhel-atomic-cloud-7.1-1.x86_64.qcow2
cp rhel-atomic-cloud-7.1-1.x86_64.qcow2 /var/lib/libvirt/images/rhel-atomic-cloud-7.1-1.x86_64-00.qcow2
cp rhel-atomic-cloud-7.1-1.x86_64.qcow2 /var/lib/libvirt/images/rhel-atomic-cloud-7.1-1.x86_64-01.qcow2
cp rhel-atomic-cloud-7.1-1.x86_64.qcow2 /var/lib/libvirt/images/rhel-atomic-cloud-7.1-1.x86_64-02.qcow2
cd -

# Copy over iso from the libvirt directory of this repo
cp ./libvirt/atomic0-cidata.iso /var/lib/libvirt/images/
```

If you prefer to create a customized iso image containing the cloud-init user-data, create a directory:

```
mkdir -p /tmp/iso
```

Add file /tmp/iso/meta-data with content (modify as appropiate):

```
instance-id: atomic2
local-hostname: atomic2
```

Add file /tmp/iso/user-data with content (modify as appropiate):

```
#cloud-config
password: atomic
chpasswd: {expire: False}
ssh_pwauth: True
hostname: atomic2
fqdn: atomic2.example.com
```

And finally create the iso file that can be attached to the VM:

```
genisoimage -output atomic2.iso -volid cidata -joliet -rock /tmp/iso/meta-data /tmp/iso/user-data
```

# Correct the permissions

```
chown -R qemu:qemu /var/lib/libvirt/images/
```

# Clean up the original file if you want
```
rm -f /tmp/rhel-atomic-cloud-7.1-1.x86_64.qcow2
```

Configure add the images via virtmanager and add the iso a cd rom via add hardware

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
