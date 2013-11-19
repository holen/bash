install-kvm.sh --> install the kvm step by step   
create-kvm.sh --> shell for manage the virtual machine  
  bash create-kvm [options] ...  
    options:  
        -h                              -->     more info  
        -c temp_name vm_name memsize    -->     clone temp  
                i.e. create-kvm.sh -c tm1 vm100 1G  
        -D vm_name                      -->     remove vm  
        -d vm_name disk_name size       -->     hotplug a new disk  
                i.e. create-kvm.sh vm100 disk200 200G  

