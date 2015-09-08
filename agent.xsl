<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
<xsl:strip-space elements="*"/>

<xsl:param name="username" select="'jdoe'"/>
<xsl:param name="password" select="'password'"/>
<xsl:param name="hawkular_server" select="'localhost'"/>
<xsl:param name="hawkular_port" select="'8080'"/>

  <!-- add additional subsystem extensions -->
  <xsl:template match="node()[name(.)='extensions']">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
      <extension xmlns="urn:jboss:domain:3.0" module="org.hawkular.agent.monitor"/>
    </xsl:copy>
  </xsl:template>

  <!-- add extension subsystem configurations -->
  <xsl:template match="node()[name(.)='profile']">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>

      <!-- Hawkular Monitor agent subsystem -->
      <subsystem xmlns="urn:org.hawkular.agent.monitor:monitor:1.0"
                 apiJndiName="java:global/hawkular/agent/monitor/api"
                 numMetricSchedulerThreads="3"
                 numAvailSchedulerThreads="3">
        <xsl:attribute name="enabled">
           <xsl:value-of select="true()"/>
        </xsl:attribute>

        <diagnostics enabled="true"
                     reportTo="LOG"
                     interval="1"
                     timeUnits="minutes"/>

        <storage-adapter type="HAWKULAR">
           <xsl:attribute name="username">
              <xsl:value-of select="$username"/>
           </xsl:attribute>
           <xsl:attribute name="password">
              <xsl:value-of select="$password"/>
           </xsl:attribute>
        </storage-adapter>

        <metric-set-dmr name="WildFly Memory Metrics" enabled="true">
          <metric-dmr name="Heap Used"
                      interval="30"
                      timeUnits="seconds"
                      metricUnits="bytes"
                      path="/core-service=platform-mbean/type=memory"
                      attribute="heap-memory-usage#used" />
          <metric-dmr name="Heap Committed"
                      interval="1"
                      timeUnits="minutes"
                      path="/core-service=platform-mbean/type=memory"
                      attribute="heap-memory-usage#committed" />
          <metric-dmr name="Heap Max"
                      interval="1"
                      timeUnits="minutes"
                      path="/core-service=platform-mbean/type=memory"
                      attribute="heap-memory-usage#max" />
          <metric-dmr name="NonHeap Used"
                      interval="30"
                      timeUnits="seconds"
                      path="/core-service=platform-mbean/type=memory"
                      attribute="non-heap-memory-usage#used" />
          <metric-dmr name="NonHeap Committed"
                      interval="1"
                      timeUnits="minutes"
                      path="/core-service=platform-mbean/type=memory"
                      attribute="non-heap-memory-usage#committed" />
          <metric-dmr name="Accumulated GC Duration"
                      metricType="counter"
                      interval="1"
                      timeUnits="minutes"
                      path="/core-service=platform-mbean/type=garbage-collector/name=*"
                      attribute="collection-time" />

        </metric-set-dmr>

        <metric-set-dmr name="WildFly Threading Metrics" enabled="true">
          <metric-dmr name="Thread Count"
                      interval="2"
                      timeUnits="minutes"
                      metricUnits="none"
                      path="/core-service=platform-mbean/type=threading"
                      attribute="thread-count" />
        </metric-set-dmr>

        <metric-set-dmr name="WildFly Aggregated Web Metrics" enabled="true">
          <metric-dmr name="Aggregated Active Web Sessions"
                      interval="1"
                      timeUnits="minutes"
                      path="/deployment=*/subsystem=undertow"
                      attribute="active-sessions" />
          <metric-dmr name="Aggregated Max Active Web Sessions"
                      interval="1"
                      timeUnits="minutes"
                      path="/deployment=*/subsystem=undertow"
                      attribute="max-active-sessions" />
          <metric-dmr name="Aggregated Expired Web Sessions"
                      metricType="counter"
                      interval="1"
                      timeUnits="minutes"
                      path="/deployment=*/subsystem=undertow"
                      attribute="expired-sessions" />
          <metric-dmr name="Aggregated Rejected Web Sessions"
                      metricType="counter"
                      interval="1"
                      timeUnits="minutes"
                      path="/deployment=*/subsystem=undertow"
                      attribute="rejected-sessions" />
          <metric-dmr name="Aggregated Servlet Request Time"
                      metricType="counter"
                      interval="1"
                      timeUnits="minutes"
                      path="/deployment=*/subsystem=undertow/servlet=*"
                      attribute="total-request-time" />
          <metric-dmr name="Aggregated Servlet Request Count"
                      metricType="counter"
                      interval="1"
                      timeUnits="minutes"
                      path="/deployment=*/subsystem=undertow/servlet=*"
                      attribute="request-count" />
        </metric-set-dmr>

        <metric-set-dmr name="Undertow Metrics" enabled="true">
          <metric-dmr name="Active Sessions"
                      interval="2"
                      timeUnits="minutes"
                      path="/subsystem=undertow"
                      attribute="active-sessions" />
          <metric-dmr name="Sessions Created"
                      metricType="counter"
                      interval="2"
                      timeUnits="minutes"
                      path="/subsystem=undertow"
                      attribute="sessions-created" />
          <metric-dmr name="Expired Sessions"
                      metricType="counter"
                      interval="2"
                      timeUnits="minutes"
                      path="/subsystem=undertow"
                      attribute="expired-sessions" />
          <metric-dmr name="Rejected Sessions"
                      metricType="counter"
                      interval="2"
                      timeUnits="minutes"
                      path="/subsystem=undertow"
                      attribute="rejected-sessions" />
          <metric-dmr name="Max Active Sessions"
                      interval="2"
                      timeUnits="minutes"
                      path="/subsystem=undertow"
                      attribute="max-active-sessions" />
        </metric-set-dmr>

        <metric-set-dmr name="Servlet Metrics" enabled="true">
          <metric-dmr name="Max Request Time"
                      interval="5"
                      timeUnits="minutes"
                      metricUnits="milliseconds"
                      path="/"
                      attribute="max-request-time" />
          <metric-dmr name="Min Request Time"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="min-request-time" />
          <metric-dmr name="Total Request Time"
                      metricType="counter"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="total-request-time" />
          <metric-dmr name="Request Count"
                      metricType="counter"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="request-count" />
        </metric-set-dmr>

        <metric-set-dmr name="Singleton EJB Metrics" enabled="true">
          <metric-dmr name="Execution Time"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="execution-time" />
          <metric-dmr name="Invocations"
                      metricType="counter"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="invocations" />
          <metric-dmr name="Peak Concurrent Invocations"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="peak-concurrent-invocations" />
          <metric-dmr name="Wait Time"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="wait-time" />
        </metric-set-dmr>

        <metric-set-dmr name="Message Driven EJB Metrics" enabled="true">
          <metric-dmr name="Execution Time"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="execution-time" />
          <metric-dmr name="Invocations"
                      metricType="counter"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="invocations" />
          <metric-dmr name="Peak Concurrent Invocations"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="peak-concurrent-invocations" />
          <metric-dmr name="Wait Time"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="wait-time" />
          <metric-dmr name="Pool Available Count"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="pool-available-count" />
          <metric-dmr name="Pool Create Count"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="pool-create-count" />
          <metric-dmr name="Pool Current Size"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="pool-current-size" />
          <metric-dmr name="Pool Max Size"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="pool-max-size" />
          <metric-dmr name="Pool Remove Count"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="pool-remove-count" />
        </metric-set-dmr>

        <metric-set-dmr name="Stateless Session EJB Metrics" enabled="true">
          <metric-dmr name="Execution Time"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="execution-time" />
          <metric-dmr name="Invocations"
                      metricType="counter"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="invocations" />
          <metric-dmr name="Peak Concurrent Invocations"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="peak-concurrent-invocations" />
          <metric-dmr name="Wait Time"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="wait-time" />
          <metric-dmr name="Pool Availabile Count"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="pool-available-count" />
          <metric-dmr name="Pool Create Count"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="pool-create-count" />
          <metric-dmr name="Pool Current Size"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="pool-current-size" />
          <metric-dmr name="Pool Max Size"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="pool-max-size" />
          <metric-dmr name="Pool Remove Count"
                      interval="5"
                      timeUnits="minutes"
                      path="/"
                      attribute="pool-remove-count" />
        </metric-set-dmr>

        <metric-set-dmr name="Datasource JDBC Metrics" enabled="true">
          <metric-dmr name="Prepared Statement Cache Access Count"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=jdbc"
                      attribute="PreparedStatementCacheAccessCount" />
          <metric-dmr name="Prepared Statement Cache Add Count"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=jdbc"
                      attribute="PreparedStatementCacheAddCount" />
          <metric-dmr name="Prepared Statement Cache Current Size"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=jdbc"
                      attribute="PreparedStatementCacheCurrentSize" />
          <metric-dmr name="Prepared Statement Cache Delete Count"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=jdbc"
                      attribute="PreparedStatementCacheDeleteCount" />
          <metric-dmr name="Prepared Statement Cache Hit Count"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=jdbc"
                      attribute="PreparedStatementCacheHitCount" />
          <metric-dmr name="Prepared Statement Cache Miss Count"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=jdbc"
                      attribute="PreparedStatementCacheMissCount" />
        </metric-set-dmr>

        <metric-set-dmr name="Datasource Pool Metrics" enabled="true">
          <metric-dmr name="Active Count"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="ActiveCount" />
          <metric-dmr name="Available Count"
                      interval="1"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="AvailableCount" />
          <metric-dmr name="Average Blocking Time"
                      interval="1"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="AverageBlockingTime" />
          <metric-dmr name="Average Creation Time"
                      interval="1"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="AverageCreationTime" />
          <metric-dmr name="Average Get Time"
                      interval="1"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="AverageGetTime" />
          <metric-dmr name="Blocking Failure Count"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="BlockingFailureCount" />
          <metric-dmr name="Created Count"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="CreatedCount" />
          <metric-dmr name="Destroyed Count"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="DestroyedCount" />
          <metric-dmr name="Idle Count"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="IdleCount" />
          <metric-dmr name="In Use Count"
                      interval="1"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="InUseCount" />
          <metric-dmr name="Max Creation Time"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="MaxCreationTime" />
          <metric-dmr name="Max Get Time"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="MaxGetTime" />
          <metric-dmr name="Max Used Count"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="MaxUsedCount" />
          <metric-dmr name="Max Wait Count"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="MaxWaitCount" />
          <metric-dmr name="Max Wait Time"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="MaxWaitTime" />
          <metric-dmr name="Timed Out"
                      interval="1"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="TimedOut" />
          <metric-dmr name="Total Blocking Time"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="TotalBlockingTime" />
          <metric-dmr name="Total Creation Time"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="TotalCreationTime" />
          <metric-dmr name="Total Get Time"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="TotalGetTime" />
          <metric-dmr name="Wait Count"
                      interval="10"
                      timeUnits="minutes"
                      path="/statistics=pool"
                      attribute="WaitCount" />
        </metric-set-dmr>

        <metric-set-dmr name="Transactions Metrics" enabled="true">
          <metric-dmr name="Number of Aborted Transactions"
                      metricType="counter"
                      interval="10"
                      timeUnits="minutes"
                      path="/"
                      attribute="number-of-aborted-transactions" />
          <metric-dmr name="Number of Application Rollbacks"
                      metricType="counter"
                      interval="10"
                      timeUnits="minutes"
                      path="/"
                      attribute="number-of-application-rollbacks" />
          <metric-dmr name="Number of Committed Transactions"
                      metricType="counter"
                      interval="10"
                      timeUnits="minutes"
                      path="/"
                      attribute="number-of-committed-transactions" />
          <metric-dmr name="Number of Heuristics"
                      metricType="counter"
                      interval="10"
                      timeUnits="minutes"
                      path="/"
                      attribute="number-of-heuristics" />
          <metric-dmr name="Number of In-Flight Transactions"
                      interval="10"
                      timeUnits="minutes"
                      path="/"
                      attribute="number-of-inflight-transactions" />
          <metric-dmr name="Number of Nested Transactions"
                      interval="10"
                      timeUnits="minutes"
                      path="/"
                      attribute="number-of-nested-transactions" />
          <metric-dmr name="Number of Resource Rollbacks"
                      metricType="counter"
                      interval="10"
                      timeUnits="minutes"
                      path="/"
                      attribute="number-of-resource-rollbacks" />
          <metric-dmr name="Number of Timed Out Transactions"
                      metricType="counter"
                      interval="10"
                      timeUnits="minutes"
                      path="/"
                      attribute="number-of-timed-out-transactions" />
          <metric-dmr name="Number of Transactions"
                      interval="10"
                      timeUnits="minutes"
                      path="/"
                      attribute="number-of-transactions" />
        </metric-set-dmr>

        <avail-set-dmr name="Server Availability" enabled="true">
          <avail-dmr name="App Server"
                     interval="30"
                     timeUnits="seconds"
                     path="/"
                     attribute="server-state"
                     upRegex="run.*" />
        </avail-set-dmr>

        <avail-set-dmr name="Deployment Status" enabled="true">
          <avail-dmr name="Deployment Status"
                     interval="1"
                     timeUnits="minutes"
                     path="/"
                     attribute="status"
                     upRegex="OK" />
        </avail-set-dmr>

        <resource-type-set-dmr name="Main" enabled="true">
          <resource-type-dmr name="WildFly Server"
                             resourceNameTemplate="WildFly Server [%ManagedServerName] [${{jboss.node.name:localhost}}]"
                             path="/"
                             metricSets="WildFly Memory Metrics,WildFly Threading Metrics,WildFly Aggregated Web Metrics"
                             availSets="Server Availability">
            <resource-config-dmr name="Hostname"
                                 path="/core-service=server-environment"
                                 attribute="qualified-host-name" />
            <resource-config-dmr name="Version"
                                 attribute="release-version" />
            <resource-config-dmr name="Bound Address"
                                 path="/socket-binding-group=standard-sockets/socket-binding=http"
                                 attribute="bound-address" />
          </resource-type-dmr>
        </resource-type-set-dmr>

        <resource-type-set-dmr name="Hawkular" enabled="true">
          <resource-type-dmr name="Bus Broker"
                             resourceNameTemplate="Bus Broker"
                             path="/subsystem=hawkular-bus-broker"
                             parents="WildFly Server"/>
          <resource-type-dmr name="Monitor Agent"
                             resourceNameTemplate="Monitor Agent"
                             path="/subsystem=hawkular-monitor"
                             parents="WildFly Server">
            <operation-dmr name="Status" operationName="status" path="/" />
          </resource-type-dmr>
        </resource-type-set-dmr>

         <resource-type-set-dmr name="Deployment" enabled="true">
            <resource-type-dmr name="Deployment"
                               resourceNameTemplate="Deployment [%2]"
                               path="/deployment=*"
                               parents="WildFly Server"
                               metricSets="Undertow Metrics"
                               availSets="Deployment Status">
              <operation-dmr name="Deploy" operationName="deploy" path="/" />
              <operation-dmr name="Redeploy" operationName="redeploy" path="/" />
              <operation-dmr name="Remove" operationName="remove" path="/" />
              <operation-dmr name="Undeploy" operationName="undeploy" path="/" />
            </resource-type-dmr>

            <resource-type-dmr name="SubDeployment"
                               resourceNameTemplate="SubDeployment [%-]"
                               path="/subdeployment=*"
                               parents="Deployment"
                               metricSets="Undertow Metrics">
            </resource-type-dmr>
         </resource-type-set-dmr>

        <resource-type-set-dmr name="Web Component" enabled="true">
          <resource-type-dmr name="Servlet"
                             resourceNameTemplate="Servlet [%-]"
                             path="/subsystem=undertow/servlet=*"
                             parents="Deployment,SubDeployment"
                             metricSets="Servlet Metrics" />
        </resource-type-set-dmr>

        <resource-type-set-dmr name="EJB" enabled="true">
          <resource-type-dmr name="Singleton EJB"
                             resourceNameTemplate="Singleton EJB [%-]"
                             path="/subsystem=ejb3/singleton-bean=*"
                             parents="Deployment,SubDeployment"
                             metricSets="Singleton EJB Metrics" />

          <resource-type-dmr name="Message Driven EJB"
                             resourceNameTemplate="Message Driven EJB [%-]"
                             path="/subsystem=ejb3/message-driven-bean=*"
                             parents="Deployment,SubDeployment"
                             metricSets="Message Driven EJB Metrics" />

          <resource-type-dmr name="Stateless Session EJB"
                             resourceNameTemplate="Stateless Session EJB [%-]"
                             path="/subsystem=ejb3/stateless-session-bean=*"
                             parents="Deployment,SubDeployment"
                             metricSets="Stateless Session EJB Metrics" />
        </resource-type-set-dmr>

        <resource-type-set-dmr name="Datasource" enabled="true">
          <resource-type-dmr name="Datasource"
                             resourceNameTemplate="Datasource [%-]"
                             path="/subsystem=datasources/data-source=*"
                             parents="WildFly Server"
                             metricSets="Datasource Pool Metrics,Datasource JDBC Metrics" />
        </resource-type-set-dmr>

        <resource-type-set-dmr name="Transaction Manager" enabled="true">
          <resource-type-dmr name="Transaction Manager"
                             resourceNameTemplate="Transaction Manager"
                             path="/subsystem=transactions"
                             parents="WildFly Server"
                             metricSets="Transactions Metrics" />
        </resource-type-set-dmr>

        <managed-servers>
          <remote-dmr name="Another Remote Server"
                      enabled="false"
                      host="localhost"
                      port="9990"
                      username="adminUser"
                      password="adminPass"
                      resourceTypeSets="Main,Deployment,Web Component,EJB,Datasource,Transaction Manager" />

          <local-dmr name="Local"
                     enabled="true"
                     resourceTypeSets="Main,Deployment,Web Component,EJB,Datasource,Transaction Manager,Hawkular" />

        </managed-servers>
   </subsystem>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="node()[name(.)='socket-binding-group']">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
	<outbound-socket-binding  xmlns="urn:jboss:domain:3.0" name="hawkular">
	  <remote-destination
	     host="{$hawkular_server}"
	     port="{$hawkular_port}" />
	</outbound-socket-binding>
     </xsl:copy>
   </xsl:template>

  <xsl:template match="node()|@*">
      <xsl:copy>
         <xsl:apply-templates select="node()|@*" />
      </xsl:copy>
   </xsl:template>
</xsl:stylesheet>
