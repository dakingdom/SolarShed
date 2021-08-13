#!/bin/bash

# This script converts the plain ASCII data output by getTracerData.py into a format
# that can be used by Grafana. The new file is written to the /ramdisk folder
# It converts the file /ramdisk/solarData.txt to /ramdisk/solarData.txt.prom
# 
# Here is an example wrapper script that brings it altogether, loading data into grafana indefinitely.

# Run this program as root
# look for the new file being created /ramdisk/solarData.txt.prom and updated every 4 seconds
# node_exporter will automatically load this data into Prometheus for you.

# In Grafana, the Prometheus data can be seen under the label 'AB_SolarStats'
# Ensure Prometheus and node_exporter are working correctly.

echo Starting Epever serial data collection...
while : ; do
    echo "Gathering Solar Data from getTracerData.py..."
    /home/solar/getTracerData.py > /ramdisk/solarData.txt.$$
    echo "...Now sleeping for 1 second."
    sleep 1
    echo "Adding date..."
    date >> /ramdisk/solarData.txt.$$
    mv /ramdisk/solarData.txt.$$ /ramdisk/solarData.txt
    echo "...Exporting data for Node Exporter..."
    /home/solar/exportData.sh
    echo "...Now sleeping for 4 seconds."
    sleep 4
done
