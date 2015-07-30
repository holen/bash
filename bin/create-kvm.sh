#!/bin/bash
## This shell is for auto create kvm virtual machine
###

set -u
set -e

temp_dir="/data/tempate/"
kvm_dir="/data/kvmdb/"
disk_xml="/tmp/kvm-disk.xml"
disk_str="    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='writethrough'/>
      <source file='/data/kvmdb/disk-test.img'/>
      <target dev='vdc' bus='virtio'/>
    </disk> 
"
dump_file="/data/kvmdb/dump.xml"

Copy=`which cp`
Virsh=`which virsh`
Qemg=`which qemu-img`
status=False

### $1 --> temp_name  $2 --> vm_name  $3 --> memsize
clone_temp(){
	disk_list=`ls -1 "$temp_dir" | grep "${1}\."`
	for disk in $disk_list ;
	do
		$Copy ${temp_dir}${disk} ${kvm_dir}${2}.${disk##*.}
	done
	/bin/sed -i "s/${1}/${2}/g" ${kvm_dir}${2}.xml
	if [ "$status" == "True" ];then
		((mem_num=${3%%G}*1024*1024))
		/bin/sed -i "s/\(<memory .*>\).*<\/memory>/\1${mem_num}<\/memory>/g" ${kvm_dir}${2}.xml
	        /bin/sed -i "s/\(<currentMemory .*>\).*<\/currentMemory>/\1${mem_num}<\/currentMemory>/g" ${kvm_dir}${2}.xml
		$Virsh define ${kvm_dir}${2}.xml
	else
		echo "*********"
		$Virsh define ${kvm_dir}${2}.xml
	fi
}

### $1 --> vm_name
delete_vm(){
	$Virsh undefine $1
	/bin/rm ${kvm_dir}${1}.*
	/etc/init.d/libvirt-bin restart
}

### $1 --> vm_name  $2 --> disk_name  $3 --> size
add_disk(){
	$Qemg create -f qcow2 "${kvm_dir}${2}".img $3
	$Virsh dumpxml $1 > $dump_file
	printf "$disk_str" > $disk_xml
	sed -i "s/disk-test/${2}/g" $disk_xml
	$Virsh attach-device "$1" $disk_xml
	sed -i '/<\/devices>/i MARKER' $dump_file
	sed -i -e "/MARKER/r ${disk_xml}" -e '/MARKER/d' $dump_file
	$Virsh undefine $1
	$Copy $dump_file "/etc/libvirt/qemu/${1}.xml"
	$Virsh define "/etc/libvirt/qemu/${1}.xml"
	/etc/init.d/libvirt-bin restart
}

### $1 --> origin_vm $2 --> target_vm
virt_clone(){
    array=`grep 'source file' /etc/libvirt/qemu/${1}.xml | awk -F"'" '{print $2}' | sed "s/${1}/${2}/g"`
    disk_str=`for var in ${array[@]} ;do echo -n "-f $var "; done;`
    virt-clone --connect=qemu:///system -o $1 -n $2 $disk_str
}

if [ $# -lt 1 ];then
	echo "Please input enough parameter ... OR usage bash create-kvm -h "
	exit 1
fi

opt=$1

case "$opt" in
	"-h")
		printf "
  bash create-kvm [options] ...
    options:
	-h 				-->	more info
	-c temp_name vm_name memsize	-->	clone temp
		i.e. create-kvm.sh -c tm1 vm100 1G
        -C origin_vm target_vm          --> clone temp use virt-clone
	-D vm_name			-->	remove vm
	-d vm_name disk_name size	-->	hotplug a new disk
		i.e. create-kvm.sh vm100 disk200 200G

"
		;;
	"-c")
		shift
		if [ $# -lt 2 ];
		then
			echo "No enough argument value for option"
			exit 1
		else
			if [ -s "${temp_dir}${1}.xml" ];then
				if [ -s "/etc/libvirt/qemu/${2}.xml" ];then
					echo "The vm_name is exist"
				else
					if [ $# == 3 ];then
						status=True
						clone_temp $1 $2 $3
					else
						clone_temp $1 $2
					fi
				fi
			else
				echo "The temp is not exist"
			fi
		fi
		;;
    "-C")
        shift
		if [ $# != 2 ];
		then
			echo "No enough argument value for option"
			exit 1
		else
            virt_clone $1 $2
        fi
        ;;
	"-D")
		shift
		delete_vm $1
		;;
	"-d")
		shift
		if [ $# != 3 ];
		then
			echo "No enough argument value for option"
			exit 1
		else
			if [ -s "${kvm_dir}$2" ];then
				echo "The disk is exist"
			else
				add_disk $1 $2 $3 
			fi
		fi
		;;
	*)
		echo "Use -h to see more info"
		exit 1
		;;
esac
