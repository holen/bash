###   --- install bridge-utils --
apt-get install bridge-utils

cp /etc/network/interfaces /tmp/interfaces
echo "" > /etc/network/interfaces

### --- configure bridge
echo "
auto lo
iface lo inet loopback

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
" >> /etc/network/interfaces

###  show net
ip addr show
brctl show

### --- install KVM --
apt-get install -y qemu-kvm libvirt-bin virtinst virt-top

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
#/usr/bin/virt-install --connect qemu:///system \
#-n vm11 \
#-r 2048 \
#--vcpus=2 \
#--arch=x86_64 \
#--disk path=/data/kvmdb/vm11.img,format=qcow2,size=20,bus=virtio,cache=none \   
#-c /data/isos/CentOS-5.6-x86_64-atl1e-netinstall.iso \
# --vnclisten=0.0.0.0 --vncport=0 --vnc \
#--noautoconsole \
#--os-type linux \ 
#--accelerate --network=bridge:br0,model=virtio --hvm
#qemu-img create -f qcow2 disk202.img 480G
#qemu-img info disk202.img
#virsh edit vm208
# <disk type='file' device='disk'>
#      <driver name='qemu' type='qcow2' cache='writethrough'/>
#      <source file='/data/kvmdb/disk202.img'/>
#      <target dev='vdb' bus='virtio'/>
#    </disk> 
ebtables -A FORWARD -i virnet0 -s ! fe:54:00:30:f6:72 -p IPv4 --ip-source ! 10.20.10.202 -j DROP
service ebtables save
ebtables -Ln

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

### install windows must be attention
#  --vcpus
--vcpus=VCPUS[,maxvcpus=MAX][,sockets=#][,cores=#][,threads=#]
###cache can be writethrough  不指定disk type默认是raw
cache=writethrough
#  must add storage driver
     --disk path=/data/isos/virtio-win-1.1.16.vfd,device=floppy    
     --disk path=/data/isos/virtio-win-drivers-20120712-1.iso,device=cdrom,perms=ro    
#  must set --os-variant or set --os-type is window
--os-variant win2k8
#  set network driver is e1000
--network=bridge:br0,model=e1000
#  win server
kvm -- win server 2008 -- 数据执行保护
#  add cpu core threads
virsh edit vm208  
  <cpu>
    <topology sockets='1' cores='8' threads='1'/>
  </cpu>
<graphics type='vnc' port='-1' autoport='yes' listen='0.0.0.0'>
      <listen type='address' address='0.0.0.0'/>
</graphics>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='writethrough'/>
      <source file='/data/kvmdb/disk204.img'/>
      <target dev='vdb' bus='virtio'/>
    </disk>
socket :cpu的个数 就是相当于你服务器的cpu插槽   cores:一个cpu的核数
# install win server 2003 attention
virt-install --connect qemu:///system -n tm2 -r 4096 --vcpus=2 --arch=x86_64 --disk path=/data/kvmdb/tm2.vda,format=qcow2,size=40,bus=virtio,cache=writethrough -c /data/isos/cn_win_srv_2003_r2_enterprise_x64_with_sp2_vl_cd1.iso --disk path=/data/isos/virtio-win-1.1.16.vfd,device=floppy --vnc --noautoconsole --os-type windows --accelerate --network=bridge:br0,model=e1000 --network=bridge:br1,model=e1000 --hvm

ps -ef | grep kvm
使用Download TightVNC vnc client连接console安装系统

###  elementary command

virsh save vm filename
virsh restroe filename
virsh list --all
virsh dominfo vm208
virsh vcpuinfo vm208
virsh domblklist vm212
virsh start vm0-1
virsh shutdown vm0-2
virsh destroy vm0-2
virsh pool-list --all
virsh iface-list --all
 virsh attach-interface --domain vm3 --type bridge --source br1 
/etc/init.d/libvirt-bin restart
virsh edit vm0-1
qemu-img info VirHost1.img 查看镜像信息
qemu-img convert -f raw -O qcow2 source.img target.qcow2.img 转换镜像格式
创建快照
virsh snapshot-create-as vm0-1 vm0-1.snap1
virsh snapshot-list vm0-1
ll /var/lib/libvirt/qemu/snapshot/vm0-1/vm0-1.snap1.xml
查看目前快照版本 virsh snapshot-current VirHost1
virsh snapshot-revert vm0-1 vm0-1.snap1
virsh snapshot-current
virsh snapshot-delete vm0-1 vm0-1.snap1
snapshot 主要在 image file 內增加 tag, 因此可以通过 qemu-img info 指令來查看
[root@localhost images]# qemu-img info vm0-1.img

virt-clone --connect=qemu:///system -o vm0-1 -n vm0-2 -f /data/kvmdb/vm0-2.img  克隆
virt-clone -o vm0-1 -n vm-mfschunk0 -f /data/kvmdb/vm-mfschunk0.img

rename kvm virtual machine

virsh dumpxml name_of_vm > name_of_vm.xml
virsh undefine name_of_vm
virsh define name_of_vm.xml
virsh start name_of_vm 

### attach disk 
挂载的命令是  virsh attach-device | attack-disk
qemu-img create -f qcow2 -b source.img diff.qcow  派生镜像，

挂载cdrom
virsh edit vm208
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='/data/isos/networkdriver.iso'/>
      <target dev='hdc' bus='ide'/>
      <readonly/>
     </disk>
virsh attach-device vm209 1

###  create img
qemu-img create -f qcow2 -o ? temp.qcow
qemu-img create -f qcow2 disk202.img 480G
seq 1 6 | xargs -I {} qemu-img create -f qcow2 disk30{}.img 50G
qemu-img info disk202.img
virsh edit vm208
 <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='writethrough'/>
      <source file='/data/kvmdb/disk202.img'/>
      <target dev='vdb' bus='virtio'/>
    </disk> 

modprobe acpiphp
modprobe pci_hotplug
virsh attach-device vm-red disk.xml
virsh attach-disk Guest1 /data/kvmdb/disk202.img vdb --cache none
virsh attach-disk tm2 /data/isos/cn_win_srv_2003_r2_enterprise_x64_with_sp2_vl_cd2.iso hdc --type cdrom
virsh attach-disk tm2 /data/isos/virtio-win-0.1-65.iso hdc --type cdrom

linux use disk202.img

fdisk -l
mkdir /data
fdisk /dev/vdc      n  p  enter enter enter  w
mkfs.ext4 /dev/vdc1
ll /dev/disk/by-uuid/
cat /etc/fstab
UUID=  /data     ext4     defaults     1 1
mount /dev/vdb1 /data 

virt-install for separate the swap

virt-install --connect qemu:///system -n tm1 -r 4096 --vcpus=2 --arch=x86_64 --disk path=/data/kvmdb/tm1.vda,format=qcow2,size=20,bus=virtio,cache=writethrough --disk path=/data/kvmdb/tm1.vdb,format=qcow2,size=4,bus=virtio,cache=writethrough -c /data/ubuntu-12.04.2-server-amd64.iso --vnc --noautoconsole --os-type linux --accelerate --network=bridge:br0,model=virtio --network=bridge:br1,model=virtio --hvm
qemu-img create -f qcow2 testswap 1G
mkswap testswap
file testswap

-- suggest --

1. 有 2 种常用的格式，一个是 qemu 的 qcow2 格式，一个是qemu的raw格式，后者实际是磁盘上一个连续区域 RAW格式是最原始的镜像格式，好处是速度快。但不支持很多新的功能(快照)。 现在qcow2格式效率有很大提升了，而且还支持一些新的功能  1 更小的存储空间，即使是不支持holes的文件系统也可以（这下du -h和ls -lh看到的就一样了）  2 Copy-on-write support, where the image only represents changes made to an underlying disk image（这个特性SUN ZFS表现的淋漓尽致） 3 支持多个snapshot，对历史snapshot进行管理 4 支持zlib的磁盘压缩 5 支持AES的加密
2. 采用普通的驱动，即硬盘和网卡都采用默认配置情况下，硬盘是 ide 模式，而网卡工作在 模拟的rtl 8139 网卡下，速度为100M 全双工。采用 virtio 驱动后，网卡工作在 1000M 的模式下，硬盘工作是SCSI模式下t
