

#!/bin/bash



# Set the path to the Tomcat server.xml file

TOMCAT_CONFIG=${PATH_TO_TOMCAT}/conf/server.xml



# Set the new maxThreads value (adjust as needed)

NEW_MAX_THREADS=500



# Backup the original server.xml file

cp $TOMCAT_CONFIG $TOMCAT_CONFIG.bak



# Update the maxThreads parameter in the server.xml file

sed -i "s/<Connector port=\"8080\"/<Connector port=\"8080\" maxThreads=\"$NEW_MAX_THREADS\" /g" $TOMCAT_CONFIG



# Restart the Tomcat service

systemctl restart tomcat.service