
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Tomcat thread pool exhaustion.
---

When too many requests are sent to a Tomcat server, the thread pools that handle these requests can run out of available threads. This means that incoming requests will not be processed, leading to service degradation or even a complete outage. This incident type is critical for web applications that rely on Tomcat as their application server.

### Parameters
```shell
export TOMCAT_HOME="PLACEHOLDER"

export TOMCAT_PID="PLACEHOLDER"

export BLOCKED_THREAD_ID="PLACEHOLDER"

export PATH_TO_TOMCAT="PLACEHOLDER"
```

## Debug

### Check the number of available threads in the thread pool
```shell
sudo ${TOMCAT_HOME}/bin/catalina.sh status | grep "http-nio-8080" | awk '{print $7}'
```

### Check the number of threads currently in use by Tomcat
```shell
sudo lsof -p $(sudo lsof -i:8080 -t) | awk '{print $9}' | sort | uniq -c | sort -rn
```

### Check the thread dump of the JVM to identify the root cause of the thread pool exhaustion
```shell
sudo jstack ${TOMCAT_PID} | grep "java.util.concurrent.ThreadPoolExecutor" -A 20
```

### Check the number of threads blocked by a particular thread
```shell
sudo jstack ${TOMCAT_PID} | grep "${BLOCKED_THREAD_ID}" -A 20
```

### Check the overall thread usage and status of the JVM
```shell
sudo jstat -gcutil ${TOMCAT_PID} 1000 5
```

## Repair

### Tune thread pools - Adjust the thread pool size and configuration to match the workload and resources available.
```shell


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


```