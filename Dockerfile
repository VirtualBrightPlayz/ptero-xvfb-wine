FROM    ghcr.io/pterodactyl/yolks:debian

LABEL   author="VirtualBrightPlayz" maintainer="virtualbrightplayz@gmail.com"

ENV     DEBIAN_FRONTEND noninteractive

# RUN     apt update -y
RUN     dpkg --add-architecture i386
RUN     wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN     apt-key add winehq.key
RUN     mkdir -p /etc/apt/sources.list.d/
RUN     echo "deb https://dl.winehq.org/wine-builds/debian/ buster main" > /etc/apt/sources.list.d/winesrc.list
RUN     apt upgrade -y
RUN     apt update -y
RUN     apt install -y xvfb
RUN     apt install -y --install-recommends winehq-stable


USER    container
ENV     USER=container HOME=/home/container
WORKDIR /home/container

COPY    ./entrypoint.sh /entrypoint.sh
CMD     ["/bin/bash", "/entrypoint.sh"]
