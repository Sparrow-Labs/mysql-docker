#!/bin/bash -e

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

echo "=> Creating SLAVE to ${MYSQL_MASTER_HOST}"

mysql -uroot -e "CHANGE MASTER TO MASTER_HOST='master', MASTER_USER='${MYSQL_REPLICATION_USER}', MASTER_PASSWORD='${MYSQL_REPLICATION_PASS}';"
mysql -uroot -e "START SLAVE;"
mysql -uroot -e "show slave status\G"

echo "=> Done!"

mysqladmin -uroot shutdown
