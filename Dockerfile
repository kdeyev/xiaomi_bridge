FROM ros:noetic

# RUN sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN sudo apt update
RUN sudo apt install -y ros-noetic-tf ros-noetic-xacro
RUN sudo apt install -y ros-noetic-robot-state-publisher ros-noetic-joint-state-publisher ros-noetic-move-base ros-noetic-map-server ros-noetic-amcl sudo
RUN sudo apt install ros-noetic-dwa-local-planner
RUN sudo apt install -y subversion
#RUN sudo apt install ros-noetic-desktop-full

RUN sudo apt install -y ros-noetic-rviz

# VNC
EXPOSE 5900
RUN apt-get install -y x11vnc xvfb 
RUN mkdir ~/.vnc
RUN x11vnc -storepasswd 1234 ~/.vnc/passwd
ENV DEBIAN_FRONTEND=noninteractive
RUN apt install -y xfce4
# CMD ["sh","/startvnc.sh"]


ARG CATKIN_WS=/root/catkin_ws
RUN mkdir -p $CATKIN_WS
WORKDIR ${CATKIN_WS}
# RUN source /opt/ros/noetic/setup.sh && catkin_make

WORKDIR ${CATKIN_WS}/src
ADD . xiaomi_bridge

WORKDIR ${CATKIN_WS}


RUN bash /ros_entrypoint.sh catkin_make
RUN bash /ros_entrypoint.sh catkin_make install

ENV VACUUM_IP=192.168.4.71
ENV CATKIN_WS=${CATKIN_WS}

COPY start.sh /start.sh
COPY startvnc.sh /startvnc.sh

COPY xstartup /root/.vnc/xstartup
RUN chmod +x /root/.vnc/xstartup

ENTRYPOINT [ "bash" ]
CMD ["/start.sh"]
