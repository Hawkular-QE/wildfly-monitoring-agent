# What is this Docker image project?
Wildfly application server with built-in Hawkular monitoring agent
* [Wildfly Docker image](https://hub.docker.com/r/jboss/wildfly/) 
* [Hawkular agent](https://github.com/hawkular/hawkular-agent)

# Example usage

```
docker run -d  -e HAWKULAR_SERVER=http://livingontheedge.hawkular.org hawkular/wildfly-monitoring-agent
```
