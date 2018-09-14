SCRIPT_LOCATION=/etc/azure
mkdir -p $SCRIPT_LOCATION

wget -q https://raw.githubusercontent.com/trinadhkotturu/IgnitePreDayLab/master/mysql-app-consistent-backup-env.sh -O $SCRIPT_LOCATION/mysql-app-consistent-backup-env.sh
wget -q https://raw.githubusercontent.com/trinadhkotturu/IgnitePreDayLab/master/mysql-app-consistent-backup-funcs.sh -O $SCRIPT_LOCATION/mysql-app-consistent-backup-funcs.sh
wget -q https://raw.githubusercontent.com/trinadhkotturu/IgnitePreDayLab/master/mysql-app-consistent-backup.sh -O $SCRIPT_LOCATION/mysql-app-consistent-backup.sh
wget -q https://raw.githubusercontent.com/trinadhkotturu/IgnitePreDayLab/master/pre-mysql-backup.sh -O $SCRIPT_LOCATION/pre-mysql-backup.sh
wget -q https://raw.githubusercontent.com/trinadhkotturu/IgnitePreDayLab/master/post-mysql-backup.sh -O $SCRIPT_LOCATION/post-mysql-backup.sh
wget -q https://raw.githubusercontent.com/trinadhkotturu/IgnitePreDayLab/master/VMSnapshotScriptPluginConfig.json -O $SCRIPT_LOCATION/VMSnapshotScriptPluginConfig.json

sed -i 's#"preScriptLocation" : ""#"preScriptLocation" : "'"$SCRIPT_LOCATION"'/pre-mysql-backup.sh"#g' $SCRIPT_LOCATION/VMSnapshotScriptPluginConfig.json
sed -i 's#"postScriptLocation" : ""#"postScriptLocation" : "'"$SCRIPT_LOCATION"'/post-mysql-backup.sh"#g' $SCRIPT_LOCATION/VMSnapshotScriptPluginConfig.json

chmod 700 $SCRIPT_LOCATION/pre-mysql-backup.sh
chmod 700 $SCRIPT_LOCATION/post-mysql-backup.sh
chmod 600 $SCRIPT_LOCATION/VMSnapshotScriptPluginConfig.json
