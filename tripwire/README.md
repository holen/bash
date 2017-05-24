# tripwire 
tripwire: File integrity assessment application

安装 

    yum -y install gcc gcc-c++
    git clone https://github.com/Tripwire/tripwire-open-source.git
    cd tripwire-open-source/
    ./configure --prefix=/usr/local/tripwire
    make
    make install

加密策略文件

    twadmin --create-polfile -S site.key /usr/local/tripwire/etc/twpol.txt

显示加密的策略文件

    twadmin --print-polfile

扫描系统并构建数据库

    tripwire --init

Tripwire 完整性检查

    tripwire --check
    tripwire --check --interactive

重新初始化或更新策略
   
    法一、 tripwire --init
    法二、 tripwire --update --twrfile /usr/local/tripwire/lib/tripwire/report/localhost.localdomain-20170328-115904.twr 

更新配置文件

    tripwire --update-policy --secure-mode low /usr/local/tripwire/etc/twpol.txt

查看报告

    twprint -m r --twrfile /usr/local/tripwire/lib/tripwire/report/localhost.localdomain-20170328-145508.twr

打印关于数据库中某个具体文件的信息

    twprint -m d --print-dbfile /opt/tripwire-open-source/Makefile

从Tripwire数据库抽取所有信息

    twprint -m d --print-dbfile | more

