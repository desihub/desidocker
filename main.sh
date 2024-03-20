#!/usr/bin/env bash

echo ""
echo "|----------------------------------------------------------------------- "
echo "|                         E   N   E   R   G   Y                        | "
echo "|   ---------------------------------------------------------------| S | "
echo "|   |           .                                  *               | P | "
echo "|   |      *               __                       +     .        | E | "
echo "| D |     .         _----_///       *                              | C | "
echo "|   |   +          /   \ ///                .        *             | T | "
echo "| A |             /     Y-/\     .                                 | R | "
echo "|   |     +       |========|            +           *              | O | "
echo "| R |             |/ \ / \ |                      |                | S | "
echo "|   |      _-_    |   X   X|         *          --+--              | C | "
echo "| K |   ==/___\   |\ / \ / |      +               |       ^-^      | O | "
echo "|   |___--|   |---------------_______________________-----\_/\-/---| P | "
echo "|   |     |   |              _______----------            | |_O    | I | "
echo "|   |--------------------------------------------------------------- C | "
echo "|                 I   N   S   T   R   U   M   E   N   T                | "
echo "-----------------------------------------------------------------------| "
echo ""

# Authenticate AWS IAM user and mount AWS bucket
$LOCAL_BIN/aws_run.sh

# Source desihub packages
# The dot (.) is necessary for desi_run.sh to set the global environment variables
. $LOCAL_BIN/desi_run.sh

# Start the Jupyter server
$LOCAL_BIN/start.sh start-notebook.py

