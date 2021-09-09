FROM    ghcr.io/pterodactyl/yolks:debian

LABEL   author="VirtualBrightPlayz" maintainer="virtualbrightplayz@gmail.com"

ENV     DEBIAN_FRONTEND noninteractive

RUN     apt update -y \
        && dpkg --add-architecture i386 \
        && wget -nc https://dl.winehq.org/wine-builds/winehq.key \
        && apt-key add winehq.key \
        && echo "deb https://dl.winehq.org/wine-builds/debian/ buster main" > /etc/apt/sources.list.d/winesrc.list \
        && apt upgrade -y \
        && apt update -y \
        && apt install -y xvfb \
        && apt install --install-recommends winehq-stable


USER    container
ENV     USER=container HOME=/home/container
WORKDIR /home/container

COPY    ./entrypoint.sh /entrypoint.sh
CMD     ["/bin/bash", "/entrypoint.sh"]
