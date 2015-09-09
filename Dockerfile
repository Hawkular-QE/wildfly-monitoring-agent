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

FROM jboss/wildfly:latest

USER root

ADD build-env /etc/build-env
ADD output/${PAY_LOAD} $JBOSS_HOME/modules/system/layers/base
ADD hawkular-agent-install.sh wildfly-start.sh /usr/bin/
ADD agent.xsl .secret /etc/

RUN /usr/bin/hawkular-agent-install.sh

EXPOSE 9990

CMD ["/bin/bash", "/usr/bin/wildfly-start.sh"] 
