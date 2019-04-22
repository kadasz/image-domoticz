FROM phusion/baseimage:latest
MAINTAINER Karol D Sz

ENV TZ Europe/Warsaw
ENV TERM xterm

ENV APP domoticz
ENV APP_PORT 8080
ENV APP_REV 4.9700
ENV APP_USER domoticz
ENV APP_HOME /opt/domoticz

WORKDIR /tmp

# install requirements
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update; apt-get -q -y --no-install-recommends install psmisc curl less vim git wget net-tools lsof iproute2 tzdata build-essential
RUN apt-get -q -y --no-install-recommends install cmake libboost-dev libboost-thread-dev libboost-system-dev libsqlite3-dev libcurl4-openssl-dev libssl-dev libusb-dev zlib1g-dev libudev-dev python3-dev subversion

# install OpenZWave
RUN curl https://bootstrap.pypa.io/get-pip.py | python3 -
RUN pip install python-openzwave

# build and install the Boost library
RUN wget --quiet https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.gz && \
		tar xfz boost_1_68_0.tar.gz; cd boost_1_68_0/ && \
		./bootstrap.sh && \
		./b2 stage threading=multi link=static --with-thread --with-system && \
		./b2 install threading=multi link=static --with-thread --with-system

# build and install Domoticz
RUN git clone https://github.com/domoticz/domoticz.git && \
		cd domoticz; git checkout tags/$APP_REV && \
		cmake -DCMAKE_BUILD_TYPE=Release . && \
		make && make install

# autoremove won't remove libcurl3
RUN apt-mark manual libcurl3
# cleanup
RUN apt-get remove -y cmake make gcc g++ build-essential libboost-dev libboost-thread-dev libboost-system-dev libsqlite3-dev libcurl4-openssl-dev libssl-dev libusb-dev zlib1g-dev libudev-dev subversion && \
		apt-get autoremove -y && \
		apt-get clean all && \
		rm -rf /root/.cache /tmp/* /var/tmp/* /var/lib/apt/lists/*

# disable cron service
RUN touch /etc/service/cron/down
# remove sshd service and regenerate ssh keys
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# runit - prepare domoticz service
RUN mkdir -p /etc/service/$APP
COPY $APP.run /etc/service/$APP/run
RUN chmod +x /etc/service/$APP/run

# create a user for domoticz
RUN addgroup --gid 9999 $APP_USER
RUN adduser --uid 9999 --gid 9999 --disabled-password --no-create-home --home $APP_HOME --gecos "Domoticz user" $APP_USER
RUN usermod -L $APP_USER

RUN chown -R $APP_USER:$APP_USER $APP_HOME

WORKDIR $APP_HOME
EXPOSE $APP_PORT
CMD ["/sbin/my_init"]
