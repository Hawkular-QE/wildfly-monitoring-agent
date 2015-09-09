#!/bin/bash
#
# Copyright 2015 Red Hat, Inc. and/or its affiliates
# and other contributors as indicated by the @author tags.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if [ -z ${WF_AGENT} ]; then
   echo "Missing WF_AGENT env variable"
   exit 1
fi

if [ -z ${WF_AGENT_PORT} ]; then
   echo "Missing WF_AGENT_PORT env variable"
   exit 1
fi

docker exec hawkular /opt/hawkular-live/bin/jboss-cli.sh --connect <<EOF
batch
/subsystem=hawkular-monitor/managed-servers=default/remote-dmr=wf2/:add(host=${WF_AGENT},port=${WF_AGENT_PORT},enabled=true,password=`cat .secret`,resourceTypeSets="Main,Deployment,Web Component,EJB,Datasource,Transaction Manager",username=admin)
/subsystem=hawkular-monitor/:start(restart=true)
run-batch
exit
EOF
