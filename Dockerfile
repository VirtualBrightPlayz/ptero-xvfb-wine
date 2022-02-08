FROM    --platform=linux/amd64 ubuntu

LABEL   author="VirtualBrightPlayz" maintainer="virtualbrightplayz@gmail.com"

ENV     DEBIAN_FRONTEND noninteractive

# RUN     apt update -y
RUN     dpkg --add-architecture i386
RUN     apt update
RUN     apt install -y wget net-tools iproute2 gnupg2 xvfb pulseaudio apt-transport-https software-properties-common lib32gcc1 sudo xserver-xorg-video-dummy python3 libfreetype6:i386 libfreetype6 git git-lfs openssh-client
# libfaudio0 aptitude
RUN     wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN     apt-key add winehq.key
RUN     mkdir -p /etc/apt/sources.list.d/
#RUN     echo "deb https://dl.winehq.org/wine-builds/debian/ buster main" > /etc/apt/sources.list.d/winehq.list
RUN     add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
RUN     wget -nc https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/amd64/libfaudio0_20.01-0~buster_amd64.deb
RUN     wget -nc https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/i386/libfaudio0_20.01-0~buster_i386.deb
# RUN     apt install -y ./libfaudio0_20.01-0~buster_amd64.deb
# RUN     apt install -y ./libfaudio0_20.01-0~buster_i386.deb
RUN     apt update
RUN     apt upgrade -y
RUN     apt-get install -y --install-recommends winehq-stable winbind

RUN     mkdir -p /home/container/.wine
ENV     WINEPREFIX=/home/container/.wine

# RUN     mkdir -p /etc/X11/xorg.conf.d/
# RUN     echo \
#             Section "Monitor" \
#                     Identifier "dummy_monitor" \
#                     HorizSync 28.0-80.0 \
#                     VertRefresh 48.0-75.0 \
#                     Modeline "1920x1080" 172.80 1920 2040 2248 2576 1080 1081 1084 1118 \
#             EndSection \
#             Section "Device" \
#                     Identifier "dummy_card" \
#                     VideoRam 256000 \
#                     Driver "dummy" \
#             EndSection \
#             Section "Screen" \
#                     Identifier "dummy_screen" \
#                     Device "dummy_card" \
#                     Monitor "dummy_monitor" \
#                     SubSection "Display" \
#                     EndSubSection \
#             EndSection > /etc/X11/xorg.conf.d/10-headless.conf

#RUN     wget -P /mono http://dl.winehq.org/wine/wine-mono/4.9.4/wine-mono-4.9.4.msi
#RUN     wineboot -u && msiexec /i /mono/wine-mono-4.9.4.msi
#RUN     rm -rf /mono/wine-mono-4.9.4.msi

RUN     apt-get install -y cabextract
RUN     wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
RUN     chmod +x winetricks
RUN     cp winetricks /usr/local/bin

# RUN     wineboot -u && winetricks -q dotnet48

# RUN     echo "git-user:x:$(id -u):$(id -g):Git User:/tmp:/bin/bash" > /etc/passwd

RUN     useradd -r -u $(id -u) -g $(id -g) git-user
RUN     adduser --disabled-password --home /home/container container
RUN     chown container:container /home/container -R
USER    container
ENV     USER=container HOME=/home/container
WORKDIR /home/container

COPY    ./entrypoint.sh /entrypoint.sh
CMD     ["/bin/bash", "/entrypoint.sh"]
