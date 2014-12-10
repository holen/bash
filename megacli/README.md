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

    hpacucli ctrl all show    # 查看所有控制器状态
    hpacucli ctrl all show status   # 查看所有控制器状态
    hpacucli ctrl slot=1 show config detail 查看slot 1阵列信息详细状态
    hpacucli ctrl slot=1 array all show # 查看slot 1所有这列信息
    hpacucli ctrl slot=0 array B ld all show #查看slot 0 阵列B 所有逻辑驱动器信息 
    hpacucli ctrl slot=0 array B pd all show  #查看slot 0 阵列B 所有物理驱动器信息 
    hpacucli ctrl slot=0 array A modify spares=2I:1:6 # 在线修改阵列热备盘
    hpacucli ctrl slot=0 Array A remove spares=2I:1:6 # 在线删除阵列热备盘

 


