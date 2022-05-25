FROM ros:noetic

# RUN sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN sudo apt update
RUN sudo apt install -y ros-noetic-tf ros-noetic-xacro
RUN sudo apt install -y ros-noetic-robot-state-publisher ros-noetic-joint-state-publisher ros-noetic-move-base ros-noetic-map-server ros-noetic-amcl
# RUN sudo apt install -y ros-noetic-rviz
RUN sudo apt install -y subversion
#RUN sudo apt install ros-noetic-desktop-full


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

ENTRYPOINT [ "bash" ]
CMD ["src/xiaomi_bridge/run_bridge.sh"]

# CMD ["roscore"]

# WORKDIR ${CATKIN_WS}/src/xiaomi_bridge

# ENTRYPOINT [ "/ros_entrypoint.sh" ]
# CMD ["catkin_make"]

# # install ros package
# RUN apt-get update && apt-get install -y \
#       ros-${ROS_DISTRO}-demo-nodes-cpp \
#       ros-${ROS_DISTRO}-demo-nodes-py && \
#     rm -rf /var/lib/apt/lists/*


# ARG FROM_IMAGE=ros:foxy
# ARG OVERLAY_WS=/opt/ros/overlay_ws

# # multi-stage for caching
# FROM $FROM_IMAGE AS cacher

# # clone overlay source
# ARG OVERLAY_WS
# WORKDIR $OVERLAY_WS/src
# RUN echo "\
# repositories: \n\
#   ros2/demos: \n\
#     type: git \n\
#     url: https://github.com/ros2/demos.git \n\
#     version: ${ROS_DISTRO} \n\
# " > ../overlay.repos
# RUN vcs import ./ < ../overlay.repos

# # copy manifests for caching
# WORKDIR /opt
# RUN mkdir -p /tmp/opt && \
#     find ./ -name "package.xml" | \
#       xargs cp --parents -t /tmp/opt && \
#     find ./ -name "COLCON_IGNORE" | \
#       xargs cp --parents -t /tmp/opt || true

# # multi-stage for building
# FROM $FROM_IMAGE AS builder

# # install overlay dependencies
# ARG OVERLAY_WS
# WORKDIR $OVERLAY_WS
# COPY --from=cacher /tmp/$OVERLAY_WS/src ./src
# RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
#     apt-get update && rosdep install -y \
#       --from-paths \
#         src/ros2/demos/demo_nodes_cpp \
#         src/ros2/demos/demo_nodes_py \
#       --ignore-src \
#     && rm -rf /var/lib/apt/lists/*

# # build overlay source
# COPY --from=cacher $OVERLAY_WS/src ./src
# ARG OVERLAY_MIXINS="release"
# RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
#     colcon build \
#       --packages-select \
#         demo_nodes_cpp \
#         demo_nodes_py \
#       --mixin $OVERLAY_MIXINS

# # source entrypoint setup
# ENV OVERLAY_WS $OVERLAY_WS
# RUN sed --in-place --expression \
#       '$isource "$OVERLAY_WS/install/setup.bash"' \
#       /ros_entrypoint.sh

# run launch file
# CMD ["ros2", "launch", "demo_nodes_cpp", "talker_listener.launch.py"]



# launch ros package
# CMD ["ros2", "launch", "demo_nodes_cpp", "talker_listener.launch.py"]