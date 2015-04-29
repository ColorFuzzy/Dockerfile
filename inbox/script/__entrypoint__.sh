#! /bin/bash
sed -i.bak s/dhc-restaurant-logo/staging-restaurant-logo/g /docker/src/service/cache_service/config.json

rm /var/run/redis_63*
/etc/init.d/redis_6379 restart
/etc/init.d/redis_6380 restart
/etc/init.d/redis_6381 restart
/etc/init.d/redis_6382 restart

/etc/init.d/postgresql start
(nohup mongod -f /etc/mongod.conf > /dev/null &); (sleep 3);

# timer
cd /docker/src/service/timer_service
./start.sh

# cache
source /opt/virtualenv/deliveryherochina/bin/activate
source /docker/src/DeliveryHeroChina/sysadmin/envs/env_dev
echo "=================================================="
echo "=================================================="
echo "----------- loading data to cache ----------------"
echo "=================================================="
echo "=================================================="
cd /docker/src/DeliveryHeroChina
python dowant/manage.py load_restaurants_to_cache 127.0.0.1 6380

cd /docker/src/service/cache_service
./start.sh

cd /docker/script
./_ws.sh start

/usr/sbin/sshd -D
