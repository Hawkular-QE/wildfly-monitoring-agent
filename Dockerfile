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

FROM jboss/wildfly:latest

ADD build-env .secret $JBOSS_HOME/
ADD output/${PAYLOAD} $JBOSS_HOME/
ADD wildfly-start.sh $JBOSS_HOME/

USER root
RUN chgrp -R 0 $JBOSS_HOME &&\
    chmod -R g+rw $JBOSS_HOME

EXPOSE 9990

CMD ["/bin/bash", "/opt/jboss/wildfly/wildfly-start.sh"] 
