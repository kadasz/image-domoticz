FROM phusion/baseimage:latest
MAINTAINER Karol D Sz

ENV TZ "${TZ:-Europe/Warsaw}"
ENV TERM xterm

ENV APP domoticz
ENV APP_PORT 8080
ENV APP_USER domoticz
ENV APP_HOME /opt/domoticz
ENV APP_LOG_VOLUME $APP_HOME/logs
ENV APP_PLUGINS_VOLUME $APP_HOME/plugins
ENV APP_DB_VOLUME $APP_HOME/db

WORKDIR $APP_HOME

# install requirements and useful libraries
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update; apt-get -q -y --no-install-recommends install psmisc curl less vim git wget net-tools lsof iproute2 iputils-ping speedtest-cli sudo tzdata build-essential python3-dev libssl-dev libusb-dev zlib1g-dev

RUN wget --quiet https://releases.domoticz.com/releases/release/domoticz_linux_x86_64.tgz
RUN tar xfz domoticz_linux_x86_64.tgz

# cleanup
RUN apt-get autoremove -y; apt-get clean all
RUN rm -rf /root/.cache /tmp/* /var/tmp/* /var/lib/apt/lists/*; sync

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

# create volumes directory, set permissions
RUN mkdir -p $APP_LOG_VOLUME $APP_DB_VOLUME
RUN chown -R $APP_USER:$APP_USER $APP_HOME

HEALTHCHECK --interval=30s --retries=1 --timeout=5s CMD wget --quiet --tries=1 --spider http://localhost:$APP_PORT/ || exit 1

EXPOSE $APP_PORT
CMD ["/sbin/my_init"]
