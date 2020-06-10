FROM debian:jessie-slim

COPY ./awair.sh /usr/src/myapp/awair.sh
RUN apt-get update
RUN apt-get install -y busybox-static curl jq mysql-client

RUN mkdir -p /var/spool/cron/crontabs
RUN echo '* * * * * /usr/src/myapp/awair.sh' >> /var/spool/cron/crontabs/root

CMD ["busybox", "crond", "-f", "-L", "/dev/stderr"]
