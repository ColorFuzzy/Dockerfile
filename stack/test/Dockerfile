FROM colorfuzzy/dockerfile:test042902
MAINTAINER Color Fuzzy <color.fuzzy@gmail.com>


# 添加deliveryservice的服务和相关配置
RUN mkdir -p /venv/DeliveryService
ENV GOPATH /venv/DeliveryService

RUN go get github.com/beego/bee
RUN go get github.com/astaxie/beego
RUN go get github.com/lib/pq
RUN go get github.com/paulmach/go.geo
RUN go get github.com/garyburd/redigo/redis
RUN go get github.com/astaxie/beego/session
RUN go get code.google.com/p/rog-go/exp/cmd/godef
RUN go get github.com/nsf/gocode