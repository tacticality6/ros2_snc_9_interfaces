#!/bin/bash

PACKAGE_NAME="ros2_snc_9_interfaces" # Change this to your package name

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

SRC_DIR="$WS_DIR/src/$PACKAGE_NAME"

# Check if workspace exists
if [ ! -d "$WS_DIR" ]; then
    echo "Error: Workspace '$WS_DIR' not found."
    exit 1
fi


# Check if the package exists
if [ ! -d "$SRC_DIR" ]; then
    echo "Error: Package '$PACKAGE_NAME' not found in $WS_DIR/src/"
    echo "Skipping..."
else
    # Remove the package
    echo "Removing package '$PACKAGE_NAME'..."
    rm -rf "$SRC_DIR"
fi

# Clean build, install, and log directories
echo "Cleaning up build, install, and log directories..."
rm -rf "$WS_DIR/build" "$WS_DIR/install" "$WS_DIR/log"

echo "Workspace Cleaned Successfully"
