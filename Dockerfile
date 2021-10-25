FROM    --platform=linux/amd64 debian:buster-slim

LABEL   author="VirtualBrightPlayz" maintainer="virtualbrightplayz@gmail.com"

ENV     DEBIAN_FRONTEND noninteractive

# RUN     apt update -y
RUN     dpkg --add-architecture i386
RUN     apt update
RUN     apt install -y wget net-tools iproute2 gnupg2 xvfb pulseaudio libfaudio0
RUN     wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN     apt-key add winehq.key
RUN     echo "deb https://dl.winehq.org/wine-builds/debian/ buster main" > /etc/apt/sources.list
RUN     wget -O- -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/Release.key | apt-key add -
RUN     echo "deb http://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10 ./" | tee /etc/apt/sources.list.d/wine-obs.list
RUN     apt update
RUN     apt upgrade -y
RUN     apt install -y winehq-stable

RUN     mkdir -p /home/container/.wine
ENV     WINEPREFIX=/home/container/.wine

RUN     wget -P /mono http://dl.winehq.org/wine/wine-mono/4.9.4/wine-mono-4.9.4.msi
RUN     wineboot -u && msiexec /i /mono/wine-mono-4.9.4.msi
RUN     rm -rf /mono/wine-mono-4.9.4.msi

RUN     apt-get install -y cabextract
RUN     wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
RUN     chmod +x winetricks
RUN     cp winetricks /usr/local/bin

# RUN     wineboot -u && winetricks -q dotnet452

USER    container
ENV     USER=container HOME=/home/container
WORKDIR /home/container

COPY    ./entrypoint.sh /entrypoint.sh
CMD     ["/bin/bash", "/entrypoint.sh"]
