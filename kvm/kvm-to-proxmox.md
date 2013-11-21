## KVM Migration to Proxmox  

# shutdown kvm vm  
$ virsh shutdown vm-ztest  

# list vm devices  
$ virsh domblklist vm-ztest  

    Target     Source  
    ------------------------------------------------  
    vda        /data/kvmdb/vm-ztest.vda  
    vdb        /data/kvmdb/vm-ztest.vdb  

# Create a new VM on Proxmox  

    Make similar disk structure to original vm machine. All other VM settings (CPU, RAM) can be different or same.  
    the kvm disk info is that:  
     --disk path=/data/kvmdb/vm-ztest.vda,format=qcow2,size=20,bus=virtio,cache=writethrough   
     --disk path=/data/kvmdb/vm-ztest.vdb,format=qcow2,size=4,bus=virtio,cache=writethrough   
    the proxmox disk info is that:  
    /var/lib/vz/images/103/vm-103-disk-1.qcow2  
    /var/lib/vz/images/103/vm-103-disk-2.qcow2  

#scp disk to proxmox and rename   

$ scp root@kvm-ip:/data/kvmdb/vm-ztest.vd* /var/lib/vz/images/103/  
$ cd /var/lib/vz/images/103/  
$ mv vm-ztest.vda vm-103.disk-1.qcow2  
$ mv vm-ztest.vdb vm-103.disk-2.qcow2  

or  
$ dd if=/dev/vg01/kvm101_img | ssh root@PROXMOX-IP-ADDRESS "dd of=/nfs/images/100/vm-101-disk-1.raw bs=4096"  

# start proxmox vm   
The VM should now be able to boot on Proxmox, make sure everything boots correctly.   

# configue network  
Use Proxmox console to login to booted VM and reconfigure networking as needed, since the NIC HW Address will now be different.   
