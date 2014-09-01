#!/bin/bash -e

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

if [ "$MYSQL_PASS" = "**Random**" ]; then
    unset MYSQL_PASS
fi

if [ "$MYSQL_REPLICATION_PASS" = "**Random**" ]; then
    unset MYSQL_REPLICATION_PASS
fi

PASS=${MYSQL_PASS:-$(pwgen -s 12 1)}
echo "=> Creating MySQL user ${MYSQL_USER} with ${PASS} password"

mysql -uroot -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '$PASS'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION"

echo "=> Done!"



PASS=${MYSQL_REPLICATION_PASS:-$(pwgen -s 12 1)}
echo "=> Creating MySQL user ${MYSQL_REPLICATION_USER} with ${PASS} password"

mysql -uroot -e "CREATE USER '${MYSQL_REPLICATION_USER}'@'%' IDENTIFIED BY '$PASS'"
mysql -uroot -e "GRANT REPLICATION SLAVE ON *.* TO '${MYSQL_REPLICATION_USER}'@'%'"

echo "=> Done!"



echo "========================================================================"
echo "You can now connect to this MySQL Server using:"
echo ""
echo "    mysql -u$MYSQL_USER -p$PASS -h<host> -P<port>"
echo "    replication: $MYSQL_REPLICATION_USER:$MYSQL_REPLICATION_PASS"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "MySQL user 'root' has no password but only allows local connections"
echo "========================================================================"

mysqladmin -uroot shutdown
