#!/usr/bin/env bash

source .env

echo "DOWNLOADING WORDPRESS"
echo "Backing-Up remote Wordpress database. (You might have to enter remote user and DB user passwords)"

DB_FILENAME=${REMOTE_DB_DATABASE}-$(date +%F).sql
# MYSQL_DUMP="mysqldump -u ${REMOTE_DB_USER} -p ${REMOTE_DB_DATABASE} > /tmp/${DB_FILENAME}"
# ssh -p${REMOTE_SSH_PORT} -i ${REMOTE_SSH_PRIVATE_KEY} -t ${REMOTE_USER}@${REMOTE_HOST} "${MYSQL_DUMP}"
# echo "Remote Wordpress database backup COMPLETE..."

# echo "Downloading dump file: ${DB_FILENAME} ..."
# scp -P${REMOTE_SSH_PORT} -i ${REMOTE_SSH_PRIVATE_KEY} ${REMOTE_USER}@${REMOTE_HOST}:/tmp/${DB_FILENAME} ${DB_FILENAME}
# echo "Downloading dump file: ${DB_FILENAME} COMPLETE..."

# echo "Replacing ${REMOTE_WP_URL} with ${LOCAL_WP_URL}"
# sed -i.bak "s,${REMOTE_WP_URL},${LOCAL_WP_URL},g" ${DB_FILENAME} && rm ${DB_FILENAME}.bak
# echo "Replacing ${REMOTE_WP_DIR} with ${LOCAL_WP_DIR}"
# sed -i.bak "s,${REMOTE_WP_DIR},${LOCAL_WP_DIR},g" ${DB_FILENAME} && rm ${DB_FILENAME}.bak
# echo "URL & Directory path replacement COMPLETE..."

# echo "Inserting to local database"
# mysql -u ${LOCAL_DB_USER} -p ${LOCAL_DB_DATABASE} < ${DB_FILENAME}
# echo "Inserting to local database COMPLETE ..."

# echo "Downloading remote wp-content/plugins directory ..."
# sudo scp -P${REMOTE_SSH_PORT} -i ${REMOTE_SSH_PRIVATE_KEY} -r ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_WP_DIR}/wp-content/plugins ${LOCAL_WP_DIR}/wp-content/plugins
# echo "Downloading remote wp-content/uploads directory ..."
# sudo scp -P${REMOTE_SSH_PORT} -i ${REMOTE_SSH_PRIVATE_KEY} -r ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_WP_DIR}/wp-content/uploads ${LOCAL_WP_DIR}/wp-content/uploads
# echo "wp-content directory download COMPLETE ..."

echo "Downloading and updating remote wp-config file ..."
sudo scp -P${REMOTE_SSH_PORT} -i ${REMOTE_SSH_PRIVATE_KEY} -r ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_WP_DIR}/wp-config.php ${LOCAL_WP_DIR}/wp-config.php
sed -i.bak "s|define( 'DB_NAME', 'deuralidb' );|define( 'DB_NAME', '${LOCAL_DB_DATABASE}' );|" ${LOCAL_WP_DIR}/wp-config.php && rm ${LOCAL_WP_DIR}/wp-config.php.bak
echo "s|define( 'DB_USER', '${REMOTE_DB_USER}' );|define( 'DB_USER', '${LOCAL_DB_USER}' );|"
sed -i.bak "s|define( 'DB_USER', '${REMOTE_DB_USER}' );|define( 'DB_USER', '${LOCAL_DB_USER}' );|" ${LOCAL_WP_DIR}/wp-config.php && rm ${LOCAL_WP_DIR}/wp-config.php.bak

echo -n "Enter local database password:"
read -s LOCAL_DB_PASSWORD
sed -i.bak "s|define( 'DB_PASSWORD', '\(.*\)' );|define( 'DB_PASSWORD', '${LOCAL_DB_PASSWORD}' );|" ${LOCAL_WP_DIR}/wp-config.php && rm ${LOCAL_WP_DIR}/wp-config.php.bak
echo "Local wp-config file update COMPLETE ..."
