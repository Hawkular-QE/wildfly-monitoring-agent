#!/bin/bash
#
# Copyright 2016 Red Hat, Inc. and/or its affiliates
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

if [ -z "${HAWKULAR_SERVER}" ]; then
   HAWKULAR_SERVER="localhost"
   echo "Warning: HAWKULAR_SERVER not specified, using localhost"
fi

echo "## Registering with HAWKULAR_SERVER: ${HAWKULAR_SERVER} ##"

. ${JBOSS_HOME}/build-env

${JBOSS_HOME}/bin/add-user.sh admin `cat < ${JBOSS_HOME}/.secret` --silent

java -jar ${JBOSS_HOME}/${PAYLOAD} \
             --target-location ${JBOSS_HOME} \
             --server-url ${HAWKULAR_SERVER} \
             --module-dist classpath:hawkular-wildfly-agent-wf-extension.zip \
             --username jdoe --password=password

/opt/jboss/wildfly/bin/standalone.sh  -b 0.0.0.0 -bmanagement 0.0.0.0

exit $?
