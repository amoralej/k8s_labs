## Creating a kubernetes cluster using vagrant and atomic host

*IMPORTANT NOTE:* The goal of this instructions is not to create a production-ready kubernetes cluster but tu build a simple environemen that can be used for learning or testing purposes. Note that this environment is not configured in a secure way (not SSL encryption in APIs, not authentication or authorization, etc...)

### Prepare your host to run vagrant with libvirt provider :

This depends on the OS used: 

#### For fedora

Install vagrant and vagrant-libvirt packages

```
yum install vagrant vagrant-libvirt
```

And add following plugins:

```
vagrant plugin install vagrant-registration
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-atomic
vagrant plugin install vagrant-reload
```


#### For RHEL7 

Install vagrant rpm from https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.2_x86_64.rpm

Install following dependencies:

```
yum install libxslt-devel libxml2-devel libvirt-devel libffi.i686 libffi-devel rubygems ruby-devel gcc libvirt-devel
yum localinstall ftp://ftp.muug.mb.ca/mirror/fedora/epel/7/x86_64/r/rubygem-ruby-libvirt-0.4.0-4.el7.x86_64.rpm
```


Install required plugins:


```
sudo alternatives --set ld /usr/bin/ld.gold

vagrant plugin install vagrant-libvirt
vagrant plugin install vagrant-registration
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-atomic
vagrant plugin install vagrant-reload


sudo alternatives --set ld /usr/bin/ld
```

### Download de vagrant boxes provided by Red Hat

They can be downloaded from access.redhat.com, go to downloads, select "Red Hat Enterprise Linux", search for "Container Development Kit" and click on "Red Hat Atomic Vagrant box for libvirt". File rhel-atomic-libvirt-7.1-3.x86_64.box (or similar) will be downloaded.

Add this boxes to your local vagrant

```
vagrant box add --provider libvirt --name atomic-rhel-7.1.3 ./rhel-atomic-libvirt-7.1-3.x86_64.box
```


### Prepare libvirt

In order to avoid typing the password everytime you do any action, copy your ssh public key to root's authorized keys in the libvirt host:

```
ssh-copy-id root@<libvirt host ip>
```

If you don't have a ssh pair keys yet, you'll have to create using ssh-keygen command before using ssh-copy-id

### Create your vagrant file

Create a directory on your home directory and copy the contents of vagrant directory in this git repo. 

Modify the Vagrantfile and add your RHN user and password to fields c.registration.username and c.registration.password for each VM.

Review and modify the parameters in the libvirt provider configuration if needed.

### Create your cluster

Run following command from the just created directory

```
vagrant up --no-parallel
```

**Note:** The VMs must be able to reach the public Red Hat Network to be registered and updated

Once the comand finishes, connects to the master server:

```
vagrant ssh kubemaster1
```

and check that all nodes were registered successfully

```
kubectl get nodes
```

You should find three nodes in Ready state, kubemaster1, kubenode1 and kubenode2

You can start creating your pods, services, replication controllers, secrets, persistent volumes, etc... In directory training/user you have some examples of json and yaml file used to start creating your own elements.

