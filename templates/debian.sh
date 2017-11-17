
##############
# Install deps
##############

apt-get update
apt-get -y install python-pip make

# Install AWS Client
pip install --upgrade awscli

##
## Setup Automatic Backups of Assets
##
cat <<"__EOF__" > /usr/local/bin/${name}.backup_assets.sh
#!/bin/bash
if [ "${backup_enabled}" = "true" ]; then
  echo "Asset backup ${name} started"
  aws s3 sync --exact-timestamps --no-follow-symlinks ${dir}/ s3://${bucket}
  echo "Asset backup ${name} finished"
else
  echo "Asset backup ${name} disabled"
fi
__EOF__
chmod +x /usr/local/bin/${name}.backup_assets.sh

# Add to cron
if [ "${backup_enabled}" == "true" ]; then
  croncmd="/usr/local/bin/${name}.backup_assets.sh"
  cronjob="${backup_frequency} $croncmd"
  ( crontab -u ${ssh_user} -l | grep -v "$croncmd" ; echo "$cronjob" ) | crontab -u ${ssh_user} -
fi

##
## Makefile for assets commands
##
cat <<"__EOF__" > /usr/local/include/Makefile.${name}.assets
ASSETS_BUCKET ?= "${bucket}"

## Backup assets to S3 ${name}
${name}\:assets-backup:
	@/usr/local/bin/${name}.backup_assets.sh

## Restore assets from S3 ${name}
${name}\:assets-restore:
	@aws s3 sync s3://$(ASSETS_BUCKET) ${dir}/ --exact-timestamps
	@sudo chmod -R 777 ${dir}

__EOF__
chmod 644 /usr/local/include/Makefile.${name}.assets