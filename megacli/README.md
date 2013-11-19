megacli 查看RIAD相关信息  
megacli -PDList -aALL | grep Online  
megacli -LDPDInfo -aALL | grep 'Firmware state' | grep -c Online  
