#!/bin/bash

# === CONFIGURATION ===
ROS2_VERSION="humble"  # Change if using another ROS 2 version
PACKAGE_NAME="ros2_snc_9_interfaces" # Change to your package name

#automatically determine workspace
# Check if the ROS 2 environment is sourced
if [ -n "$COLCON_PREFIX_PATH" ]; then
    # If sourced, use COLCON_PREFIX_PATH to find the workspace
    WS_DIR=$(dirname $(echo $COLCON_PREFIX_PATH | cut -d':' -f1))
    echo "ROS 2 Workspace detected (from COLCON_PREFIX_PATH): $WS_DIR"
elif [ -n "$AMENT_PREFIX_PATH" ]; then
    # If sourced, use AMENT_PREFIX_PATH to find the workspace
    WS_DIR=$(dirname $(echo $AMENT_PREFIX_PATH | cut -d':' -f1))
    echo "ROS 2 Workspace detected (from AMENT_PREFIX_PATH): $WS_DIR"
else
    # If not sourced, search upwards for 'src' folder
    echo "ROS 2 workspace not sourced, searching directories..."
    while [ "$PWD" != "/" ]; do
        if [ -d "$PWD/src" ]; then
            echo "Found ROS 2 workspace at: $PWD"
            break
        fi
        cd ..
    done
    if [ "$PWD" == "/" ]; then
        echo "Error: ROS 2 workspace not found."
        exit 1
    fi
    WS_DIR=$PWD
fi



# === SOURCE ROS 2 ENVIRONMENT ===
source /opt/ros/$ROS2_VERSION/setup.bash
source $WS_DIR/install/setup.bash

# === BUILD PACKAGE ===
echo "Building package: $PACKAGE_NAME..."
colcon build --packages-select $PACKAGE_NAME

# === SOURCE NEW BUILD ===
source $WS_DIR/install/setup.bash

# === RUN LAUNCH FILE IF PROVIDED ===
LAUNCH_FILE=$1
if [ -n "$LAUNCH_FILE" ]; then
    echo "Running launch file: $LAUNCH_FILE..."
    ros2 launch $PACKAGE_NAME $LAUNCH_FILE
fi
