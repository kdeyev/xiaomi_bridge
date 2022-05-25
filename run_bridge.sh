
source ${CATKIN_WS}/devel/setup.bash
# roscore&
roslaunch xiaomi_bridge bringup.launch&
sleep 5
roslaunch xiaomi_bridge move_base.launch&
sleep 5
roslaunch xiaomi_bridge navigation.launch
# roslaunch xiaomi_bridge rviz.launch