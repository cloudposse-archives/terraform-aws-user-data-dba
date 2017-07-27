
##############
# Install deps
##############

apt-get -y install pv mysql-client

##
## MySQL Client Configuration
##
cat <<"__EOF__" > /root/${namespace}.my.cnf
[client]
database=${db_name}
user=${db_user}
password=${db_password}
host=${db_host}
__EOF__
chmod 600 /root/${namespace}.my.cnf

##
## Makefile for MySQL commands
##

curl https://raw.githubusercontent.com/cloudposse/mysql_fix_encoding/3.0/fix_it.sh -o /usr/local/bin/mysql_latin_utf8.sh
chmod +x /usr/local/bin/mysql_latin_utf8.sh

curl https://raw.githubusercontent.com/cloudposse/rds-snapshot-restore/1.0/rds_restore_cluster_from_snapshot.sh -o /usr/local/bin/rds_restore_cluster_from_snapshot.sh
chmod +x /usr/local/bin/rds_restore_cluster_from_snapshot.sh

cat <<"__EOF__" > /usr/local/include/Makefile.${namespace}.mysql
DUMP ?= /tmp/mysqldump.sql
MY_CNF := /root/${namespace}.my.cnf

.PNONY : ${namespace}\:db-import
## Import dump to
${namespace}\:db-import:
	@pv $(DUMP) | sudo mysql --defaults-file=$(MY_CNF)
	 MY_CNF=$(MY_CNF) /usr/local/bin/mysql_latin_utf8.sh | pv | sudo mysql --defaults-file=$(MY_CNF)
__EOF__
chmod 644 /usr/local/include/Makefile.${namespace}.mysql

cat <<"__EOF__" > /usr/local/include/Makefile.${namespace}.rds
CLUSTER ?= ${db_cluster_name}

.PNONY : ${namespace}\:restore-from-snapshot
## Restore dump from snapshot. Specify SNAPSHOT_ID and DRY_RUN=false
${namespace}\:restore-from-snapshot:
	$(call assert-set,SNAPSHOT_ID)
	$(call assert-set,DRY_RUN)
	@DRY_RUN=$(DRY_RUN) MASTER_PASSWORD=$(shell sudo cat /root/${namespace}.my.cnf | grep password | cut -d'=' -f2) /usr/local/bin/rds_restore_cluster_from_snapshot.sh $(CLUSTER) $(SNAPSHOT_ID)

__EOF__
chmod 644 /usr/local/include/Makefile.${namespace}.rds


