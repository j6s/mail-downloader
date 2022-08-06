# See https://thej6s.com/articles/2019-01-03__automatic-email-attachement-extraction/
FROM debian:11

RUN apt-get update \
    && apt-get -y install getmail procmail mpack ca-certificates \
    && apt-get clean

RUN useradd -rm -d /home/user -s /bin/bash  -u 1000 user
RUN mkdir /out /getmail
RUN chown 1000:1000 /out /getmail
USER 1000

COPY ./script/ /script/

VOLUME /out
VOLUME /getmail
ENTRYPOINT [ "/script/fetch.sh" ]