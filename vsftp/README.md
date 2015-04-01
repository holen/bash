# install vsftp 
    apt-get install -y vsftpd

# vsftp conf 

    root@localhost:/var/ftp# cat /etc/vsftpd.conf
    listen=YES
    dirmessage_enable=YES
    use_localtime=YES
    xferlog_enable=YES
    connect_from_port_20=YES
    secure_chroot_dir=/var/run/vsftpd/empty
    pam_service_name=vsftpd
    rsa_cert_file=/etc/ssl/private/vsftpd.pem
    
    anonymous_enable=NO
    local_enable=YES
    local_umask=022
    file_open_mode=0755
    write_enable=YES
    
    chroot_list_enable=YES
    chroot_local_user=NO
    chroot_list_file=/etc/vsftpd.chroot_list
    local_root=/var/ftp
    
    userlist_enable=YES
    userlist_deny=YES
    userlist_file=/etc/vsftpd.user_list

# add ftp user

    useradd -g ftp ftpuser
    mkdir -p /var/ftp/www.test.com
    chmod 755 /var/ftp
    chmod 775 /var/ftp/www.test.com
    chown -R www-data.ftp /var/ftp/www.test.com
    vim /etc/password把ftpuser最后改为禁止登入
    ftpuser:x:1001:108::/home/ftpuser:/usr/sbin/nologin
    vim /etc/shells里加入一行
    /usr/sbin/nologin

# set apache2 virtualhost

    vim /etc/apache2/sites-available/www.test.com
    <VirtualHost *:80>
            ServerName  www.test.com
            DocumentRoot /var/ftp/www.test.com/
            <Directory />
              Options FollowSymLinks
              AllowOverride All
            </Directory>
            ErrorLog  /var/log/test.error.log
            CustomLog /var/log/test.access.log combined
    </VirtualHost>

    $ a2ensite www.test.com
    $ service apache2 reload

# test ftp upload and download

    ftp ip
    ls
    cd www.test.com
    put index.html
    get index.html
    quit
