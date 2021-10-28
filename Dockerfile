FROM    --platform=linux/amd64 debian:buster

LABEL   author="VirtualBrightPlayz" maintainer="virtualbrightplayz@gmail.com"

ENV     DEBIAN_FRONTEND noninteractive

# RUN     apt update -y
RUN     dpkg --add-architecture i386
RUN     apt update
RUN     apt install -y wget net-tools iproute2 gnupg2 xvfb pulseaudio apt-transport-https
# libfaudio0 aptitude
RUN     wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN     apt-key add winehq.key
RUN     mkdir -p /etc/apt/sources.list.d/
RUN     echo "deb https://dl.winehq.org/wine-builds/debian/ buster main" > /etc/apt/sources.list.d/winehq.list
RUN     wget -nc https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/amd64/libfaudio0_20.01-0~buster_amd64.deb
RUN     wget -nc https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/i386/libfaudio0_20.01-0~buster_i386.deb
RUN     apt install -y ./libfaudio0_20.01-0~buster_amd64.deb
RUN     apt install -y ./libfaudio0_20.01-0~buster_i386.deb
RUN     apt update
RUN     apt upgrade -y
RUN     apt-get install -y --install-recommends wine-devel-i386=6.10~buster-1 wine-devel-amd64=6.10~buster-1 wine-devel=6.10~buster-1 winehq-devel=6.10~buster-1

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
