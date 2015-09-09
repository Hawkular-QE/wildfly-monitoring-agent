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

/opt/jboss/wildfly/bin/add-user.sh admin `cat < /etc/.secret` --silent

. /etc/build-env
LAYERS_DIR=${JBOSS_HOME}/modules/system/layers/base
ZIP_FILE=${LAYERS_DIR}/${PAYLOAD}
unzip -qq -d ${LAYERS_DIR} ${ZIP_FILE} &&\
rm -f ${ZIP_FILE}

exit $?
