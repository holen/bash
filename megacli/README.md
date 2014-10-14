megacli 查看RIAD相关信息  
megacli -PDList -aALL | grep Online  
megacli -LDPDInfo -aALL | grep 'Firmware state' | grep -c Online  

查看所有物理磁盘信息

    megacli -PDList -aALL  #E is the enclosure device ID ,  S is the slot number   

test 

    dd if=/dev/zero of=test.dd bs=1024M count=20

将某块物理盘下线/上线

    megacli -PDOffline -PhysDrv [:7] -a0
    megacli -PDOnline -PhysDrv [:7] -a0

查看物理磁盘重建进度

    megacli -PDRbld -ShowProg -PhysDrv [:7] -a0  

## hpacucli

    hpacucli ctrl slot=1 show config detail
