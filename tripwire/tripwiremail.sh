#!/bin/bash - 
set -o nounset                              
#set -o errexit
log_date=$(date -d "yesterday" +"%F")
send_mail_to="zhang@abc.com"

cd $(dirname $0)

function send_mail() {
        local title=$1
        cat /tmp/tripwire.txt | /data0/scripts/sendEmail \
        -f "ops mail (noreply) <ops-noreply@abc.com>" \
        -s mail.abc.com \
        -xu ops-noreply@abc.com       \
        -xp password        \
        -t $send_mail_to    \
        -u "$title"        \
        -o message-charset="utf-8"         \
        -o message-content-type='html'   \
        -o tls=no
}

echo "<pre>" > /tmp/tripwire.txt 
/data1/tripwire/sbin/tripwire --check >> /tmp/tripwire.txt
if [ `cat /tmp/a.txt | grep "Total violations found" | awk '{print $4}'` -ne 0 ];then
	send_mail "检测到web目录文件或者系统执行文件发生变化 $log_date"
fi
