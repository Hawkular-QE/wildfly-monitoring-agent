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
. build-env
echo "## build-env ##"
cat build-env
echo "##"
rm -rf output/* &&\
mvn org.apache.maven.plugins:maven-dependency-plugin:2.10:get\
  -DremoteRepositories=${REPO_URL}\
  -Dartifact=${ARTIFACT}\
  -Dtransitive=false &&\
mvn org.apache.maven.plugins:maven-dependency-plugin:2.10:copy\
  -Dartifact="${ARTIFACT}"\
  -DoutputDirectory=output\
  -Dmdep.stripVersion=true\
  -Dmdep.stripClassifier=true &&\
echo "## Docker build ##" &&\
docker build --force-rm=true --no-cache=true --rm=true --tag=${DOCKER_TAG} .

exit $?
