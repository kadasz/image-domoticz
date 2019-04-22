FROM phusion/baseimage:latest
MAINTAINER Karol D Sz

ENV TZ Europe/Warsaw
ENV TERM xterm

ENV APP domoticz
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
RUN git clone --depth 2 https://github.com/domoticz/domoticz.git && \
		cd domoticz && \
		cmake -DCMAKE_BUILD_TYPE=Release . && \
		make && make install

# cleanup
RUN apt-get remove -y cmake make gcc g++ build-essential libssl-dev git zlib1g-dev libudev-dev libboost-all-dev && \
		apt-get autoremove -y && \
		apt-get clean && \
		rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# disable cron service
RUN touch /etc/service/cron/down
# remove sshd service
RUN rm -rf /etc/service/sshd

WORKDIR /opt
EXPOSE 8080
CMD ["/sbin/my_init"]
