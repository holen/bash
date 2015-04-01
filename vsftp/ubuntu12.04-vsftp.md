#install vsftpd on ubutnu 12.04
install vsftpd

    apt-get install python-software-properties
    add-apt-repository ppa:thefrontiergroup/vsftpd
    apt-get update
    apt-get install vsftpd

set conf

    listen=YES
    anonymous_enable=NO
    local_enable=YES
    write_enable=YES
    local_umask=022
    dirmessage_enable=YES
    use_localtime=YES
    xferlog_enable=YES
    connect_from_port_20=YES
    chroot_local_user=YES
    chroot_list_enable=YES
    chroot_list_file=/etc/vsftpd.chroot_list
    secure_chroot_dir=/var/run/vsftpd/empty
    pam_service_name=vsftpd
    rsa_cert_file=/etc/ssl/private/vsftpd.pem

add chroot_list_file

    touch /etc/vsftpd.chroot_list

add ftp user

    useradd -d /srv/www/wcn/ -m wcnftp
    passwd wcnftp
    chown -R wcnftp.wcnftp wcn

grant privileges

    chmod a-w /srv/www/wcn
    dr-xr-xr-x 3 wcnftp wcnftp 4096 Mar 31 10:47 wcn/
    mkdir /srv/www/wcn/data
    chown -R wcnftp.ftp /srv/www/wcn/data
    *id wcnftp 
    *uid=1002(wcnftp) gid=1002(wcnftp) groups=1002(wcnftp)
