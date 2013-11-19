###   --- install bridge-utils --
apt-get install bridge-utils

### --- configure bridge
auto eth0
iface eth0 inet manual

auto br0
iface br0 inet static
address 10.1.1.76 
netmask 255.255.255.0
gateway 10.1.1.1
bridge_ports eth0
bridge_stp off
bridge_fd 0
bridge_maxwait 0

###  show net
ip addr show
brctl show

### --- install KVM --
apt-get install qemu-kvm libvirt-bin virtinst virt-top

# --- adjust your system's "swappiness" parameter --
sysctl vm.swappiness=0
echo "vm.swappiness=0" >> /etc/sysctl.conf

###  locate img dir
## virsh net-destroy default
## virsh net-undefine default
mkdir -p /data/kvmdb

# 删除默认pool
## virsh pool-undefine default   

# --- 生成storage配置
mkdir -p /etc/libvirt/storage/

# Create the XML file for the storage pool device with a text edito  
echo "<pool type='dir'>
  <name>kvmdb</name>
  <uuid>850a8be3-8741-c824-b2cc-f37c40243e4f</uuid>
  <capacity>466568470528</capacity>
  <allocation>20900937728</allocation>
  <available>445667532800</available>
  <source>
  </source>
  <target>
    <path>/data/kvmdb</path>
    <permissions>
      <mode>0700</mode>
      <owner>-1</owner>
      <group>-1</group>
    </permissions>
  </target>
</pool>" > /data/kvmdb/kvmdb.xml

###   Add the storage pool definition 
### A storage pool is a quantity of storage set aside by an administrator
virsh pool-create /data/kvmdb/kvmdb.xml
virsh pool-define /data/kvmdb/kvmdb.xml
###  Turn on autostart for the storage pool 
virsh pool-autostart kvmdb

# 创建新的虚拟机gT
###  standard
/usr/bin/virt-install --connect qemu:///system \
-n vm11 \
-r 2048 \
--vcpus=2 \
--arch=x86_64 \
--disk path=/data/kvmdb/vm11.img,format=qcow2,size=20,bus=virtio,cache=none \   
-c /data/isos/CentOS-5.6-x86_64-atl1e-netinstall.iso \
 --vnclisten=0.0.0.0 --vncport=0 --vnc \
--noautoconsole \
--os-type linux \ 
--accelerate --network=bridge:br0,model=virtio --hvm
