FROM ubuntu:18.04

ARG APT_FLAGS="-q -y --no-install-recommends --no-install-suggests"

# Setup VNC
ENV DEBIAN_FRONTEND noninteractive
ENV USER root
RUN apt-get update && \
    apt-get install ${APT_FLAGS} ubuntu-desktop && \
    apt-get install ${APT_FLAGS} gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal && \
    apt-get install ${APT_FLAGS} xfce4 xfce4-goodies tightvncserver && \
    mkdir /root/.vnc

ADD xstartup /root/.vnc/xstartup
ADD passwd /root/.vnc/passwd

RUN chmod 600 /root/.vnc/passwd
RUN chmod +x /root/.vnc/xstartup

RUN mkdir /run/dbus

CMD service dbus start
CMD dbus-daemon --system
CMD /usr/bin/vncserver :1 -geometry 1280x800 -depth 16 && tail -f /root/.vnc/*:1.log
EXPOSE 5901

