#!/usr/bin/env bash

#--------------------------------------------------------------
# 开启django服务的方法

# 1. 开启mongodb和postgres
# 2. 修改django项目的dowant/settings_dev.py配置文件(如果有特殊设置, 可以改变那里)
# 3. 运行django服务
source /venv/DeliveryHeroChina/bin/activate  # python环境
cd /src/DeliveryHeroChina && source sysadmin/envs/env_dev  # 改变env环境变量

## 修改一些环境变量
export OPERATION_MODE='LIVEDEV'
export TIMER_CALLBACK_HOST='http://127.0.0.1:8888'
export QINIU_CALLBACK_HOST='http://127.0.0.1:8888'
export RESTAURANT_ADMIN_WEB_SOCKET_ADDR_FOR_CLIENT='ws://127.0.0.1:4001/serv/push?channel=pcclient'
# 这个地方没有启用https(开发环境和生产环境不一致, 需要注意)
export RESTAURANT_ADMIN_WEB_SOCKET_HTTPS_ADDR_FOR_CLIENT='ws://127.0.0.1:4001/serv/push?channel=pcclient'

# 短信服务, 开发环境没有
export SMS_MONITOR_SERVER_ADDR=""
export SMS_SENDING_SERVER_ADDR=""

# 在线支付, 开发环境没有
export ONLINE_PAY_SERVER=""

python dowant/manage.py collectstatic --settings=dowant.settings_dev
python dowant/manage.py migrate --settings=dowant.settings_dev
python dowant/manage.py runserver 0.0.0.0:8888 --settings=dowant.settings_dev &  # 脚本使用后台服务


#--------------------------------------------------------------
# 关闭django服务的方法
# 使用kill的方法

