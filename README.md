mysql-docker
============

mysql docker container

## Usage master
```
docker run \
  -p 3306:3306 \
  --name mysql01 \
  -e MYSQL_USER=my_username \
  -e MYSQL_PASS=my_password \
  -e MYSQL_DATABASE=my_database \
  -e MYSQL_SERVER_ID=1 \
  -e MYSQL_REPLICATION_USER=my_replication_user \
  -e MYSQL_REPLICATION_PASS=_my_replication_password \
  -v /media/ephemeral/mysql01:/var/lib/mysql \
  sparrowlabs/mysql:5.5
```

## Usage slave

```
docker run \
  -p 3307:3306 \
  --name mysql02 \
  -e MYSQL_USER=my_username \
  -e MYSQL_PASS=my_password \
  -e MYSQL_DATABASE=my_database \
  -e MYSQL_SERVER_ID=2 \
  -e MYSQL_REPLICATION_USER=my_replication_user \
  -e MYSQL_REPLICATION_PASS=_my_replication_password \
  -e MYSQL_MASTER_HOST=url_to_master_db \
  -v /media/ephemeral/mysql02:/var/lib/mysql \
  sparrowlabs/mysql:5.5
```
