# install mysql  
$ apt-get install mysql-server libapache2-mod-auth-mysql php5-mysql -y  

# install php  
$ apt-get install php5 libapache2-mod-php5 php5-mcryp php5-curl -y   

# install phpmyadmin  
apt-get install phpmyadmin -y   

# install php module  
$ apt-get install php5-gd -y  

# test php info  
$ php --version  
PHP 5.4.4-14+deb7u5 (cli) (built: Oct  3 2013 09:24:58)   
Copyright (c) 1997-2012 The PHP Group  
Zend Engine v2.4.0, Copyright (c) 1998-2012 Zend Technologies  

vim /var/www/info.php  
<?php  
phpinfo();  
?>  
$ /etc/init.d/apache2 restart  

# install ZendOptimizer  
Download ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz  
tar zxvf ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz  
mkdir /usr/local/zend  
cp ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64/php-5.4.x/ZendGuardLoader.so /usr/local/zend/  
vim /etc/php5/apache2/php.ini  
zend_extension="/usr/local/zend/ZendGuardLoader.so"  
/etc/init.d/apache2 restart  

access http://ip/info.php  
Zend Guard Loader	enable  
