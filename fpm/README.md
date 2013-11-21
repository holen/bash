###Home
## resume
% The fpm tool which aims to help you make and mangle packages however you choose, all (ideally) without having to care about the internals of your particular native package format. 

## install 
# install gem 
% Gem介绍：
% Gem是一个管理Ruby库和程序的标准包，它通过Ruby Gem（如 http://rubygems.org/ ）源来查找、安装、升级和卸载软件包，非常的便捷。
$ apt-get install rubygems build-essential rubygems-doc rpm -y
% rubygems - package management framework for Ruby libraries/applications
% build-essential - Informational list of build-essential packages
# install fpm
$ gem install fpm

% Building a package named "awesome" might look something like this:

$ fpm -s <source type> -t <target type> [list of sources]...

Package source types:

    dir - make a package from directories or files
    rpm - make a package from an RPM
    gem - make a package from a Rubygem
    python - make a package from a python module (via easy_install or local setup.py)
    empty - make a package without any files (useful for meta packages and other things)
    tar - make a package out of the contents of a tarball
    [deb] - make a package from an existing deb

Target package types:

    "rpm" - produce an RPM
    "deb" - produce a .deb
    "solaris" - produce a solaris package (for use with pkgadd). 
    "puppet" - produce a puppet module

% For example, you can package up your /etc/init.d directory as an RPM by doing simply this:

$ fpm -s dir -t rpm -n myinitfiles -v 1.0 /etc/init.d
    ...
    Created /home/jls/rpm/myinitfiles-1.0.x86_64.rpm
%%  -v, --version VERSION         The version to give to the package (default: 1.0)
%%  -n, --name NAME               The name to give to the package

% Above, 'x86_64' was automatically chosen as the architecture. If you want to package something as 'noarch' (or 'all' in debian), you use the '-a' flag:

$ fpm -s dir -t deb -a all -n cron-init-script -v 1.0 /etc/init.d/cron
...
Created /home/jls/cron-init-script_1.0_all.deb

%%  -a, --architecture ARCHITECTURE The architecture name. 
%%      Usually matches 'uname -m'. For automatic values, you can use '-a all' or '-a native'. 
%%      These two strings will be translated into the correct value for your platform and target package type.
 
% fpm will create a simple package for you and put it in your current directory. The result:
$ rpm -qp myinitfiles-1.0.x86_64.rpm -l
    /etc/init.d
    /etc/init.d/.legacy-bootordering
    /etc/init.d/NetworkManager.dpkg-backup
    ...

$ rpm -qp myinitfiles-1.0.x86_64.rpm --provides
    myinitfiles = 1.0-1
$ rpm -qp myinitfiles-1.0.x86_64.rpm --requires
    rpmlib(PayloadFilesHavePrefix) <= 4.0-1
    rpmlib(CompressedFileNames) <= 3.0.4-1
% You can package up any directory. But there's more

## Test
# build package at native
$ fpm -s dir -t deb -n share -v 0.1 /data/share02
Created deb package {:path=>"/data/share_0.1_amd64.deb"}
# scp to remote machine
$ scp share_0.1_amd64.deb root@10.20.10.203:/tmp/
# login remote machine
# install deb 
$ dpkg -i share_0.1_amd64.deb 
Selecting previously unselected package share.
(Reading database ... 50872 files and directories currently installed.)
Unpacking share (from share_0.1_amd64.deb) ...
Setting up share (0.1) ...
% dpkg -i {.deb package} will upgrade the package if it is installed.
# list package
$ dpkg -l share
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name                    Version                 Description
+++-=======================-=======================-==============================================================
ii  share                   0.1                     no description given
% iU 表示软件包未安装成功,ii表示安装成功
$ dpkg -s package_name 查看安装软件的详细信息
$ dpkg -p package_name 查看包的具体信息
$ dpkg -r package_name 删除一个已安装的包(保留配置信息)
$ dpkg -P package_name 删除一个已安装的包（不保留配置信息）
# Other options
$ fpm -s dir -t deb -n share -v 0.3 --description "something testing" --license 'ubuntu 12.04.3' /data/share02 
  --description DESCRIPTION     Add a description for this package.
  --license LICENSE             (optional) license name for this packag
