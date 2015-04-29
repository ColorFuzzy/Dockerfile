#!/usr/bin/env bash

#--------------------------------------------------------------
# 开启django服务的方法

# 1. 开启mongodb和postgres
# 2. 修改django项目的dowant/settings_dev.py配置文件(如果有特殊设置, 可以改变那里)
# 3. 运行django服务
source /venv/DeliveryHeroChina/bin/activate  # python环境
cd /src/DeliveryHeroChina && source sysadmin/envs/env_dev  # 改变env环境变量
export OPERATION_MODE='LIVEDEV'
python dowant/manage.py collectstatic --settings=dowant.settings_dev
python dowant/manage.py migrate --settings=dowant.settings_dev
python dowant/manage.py runserver 0.0.0.0:8888 --settings=dowant.settings_dev &  # 脚本使用后台服务


#--------------------------------------------------------------
# 关闭django服务的方法
# 使用kill的方法

