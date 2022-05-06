#!/bin/sh

OUTFILE=${1:-ros2.repos}
ROSDISTRO=${ROSDISTRO:-rolling}

GENERATE_CMD=rosinstall_generator
# Use the repos file format rather than rosinstall format.
GENERATE_CMD="$GENERATE_CMD --format repos"
# Set rosdistro. Overrideable with ROSDISTRO environment variable.
GENERATE_CMD="$GENERATE_CMD --rosdistro $ROSDISTRO"

# Include all dependencies
GENERATE_CMD="$GENERATE_CMD --deps"

# Use upstream repositories rather than release repositories and
# use development branches rather than tags.
GENERATE_CMD="$GENERATE_CMD --upstream-development"

# Exclude packages which we don't incorporate into Space ROS
excluded_pkgs=$(cat excluded-pkgs.txt)
GENERATE_CMD="$GENERATE_CMD --exclude $excluded_pkgs --"

# Use Space ROS packages as base package list
# This list should stay small rosinstall_generator will resolve dependencies.
spaceros_pkgs=$(cat spaceros-pkgs.txt)
GENERATE_CMD="$GENERATE_CMD $spaceros_pkgs"

$GENERATE_CMD > $OUTFILE
