#!/bin/bash -e

echo server-id = $MYSQL_SERVER_ID >> /etc/mysql/conf.d/my.cnf
VOLUME_HOME="/var/lib/mysql"

if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    if [ ! -f /usr/share/mysql/my-default.cnf ] ; then
        cp /etc/mysql/my.cnf /usr/share/mysql/my-default.cnf
    fi
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"

    if [[ -z "$MYSQL_MASTER_HOST" ]]; then
      /create_mysql_admin_user.sh
      /create_db.sh $MYSQL_DATABASE
    else
      /create_slave.sh
    fi
else
    echo "=> Using an existing volume of MySQL"
fi

exec mysqld_safe
