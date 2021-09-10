FROM    --platform=linux/amd64 debian:buster-slim

LABEL   author="VirtualBrightPlayz" maintainer="virtualbrightplayz@gmail.com"

ENV     DEBIAN_FRONTEND noninteractive

# RUN     apt update -y
RUN     dpkg --add-architecture i386
RUN     apt update
RUN     apt install -y wget
# RUN     wget -nc https://dl.winehq.org/wine-builds/winehq.key
# RUN     apt-key add winehq.key
# RUN     mkdir -p /etc/apt/sources.list.d/
# RUN     echo "deb https://dl.winehq.org/wine-builds/debian/ buster main" > /etc/apt/sources.list.d/winesrc.list
RUN     apt update
RUN     apt upgrade -y
RUN     apt install -y xvfb
RUN     apt install -y --install-recommends wine32


RUN     apt-get install -y cabextract
RUN     wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
RUN     chmod +x winetricks
RUN     cp winetricks /usr/local/bin

RUN     wineboot -u && winetricks -q dotnet452


USER    container
ENV     USER=container HOME=/home/container
WORKDIR /home/container

COPY    ./entrypoint.sh /entrypoint.sh
CMD     ["/bin/bash", "/entrypoint.sh"]
