#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# use the command line interface to install JIRA package.
#
: ${WHISK_SYSTEM_AUTH:?"WHISK_SYSTEM_AUTH must be set and non-empty"}
AUTH_KEY=$WHISK_SYSTEM_AUTH

SCRIPTDIR="$(cd $(dirname "$0")/ && pwd)"
PACKAGE_HOME=$SCRIPTDIR
source "$PACKAGE_HOME/util.sh"

echo Installing Jira package.

createPackage jira \
    -a description "Package which contains actions and feeds to interact with JIRA"

waitForAll

install "$PACKAGE_HOME/jira/jirafeed.js" \
    jira/jirafeed \
    -a feed true \
    -a description 'Creates a webhook on JIRA to be notified on selected changes' \
    -a parameters '[ {"name":"username", "required":true, "bindTime":true, "description": "Your JIRA username"}, {"name":"siteName", "required":true, "bindTime":true, "description": "first part of your website domain name"}, {"name":"accessToken", "required":true, "bindTime":true, "description": "A webhook or personal token", "doclink": "https://id.atlassian.com/manage/api-tokens"},{"name":"webhookName", "bindTime":true, "description": "A name for the JIRA webhook"},{"name":"force_http", "bindTime":true, "description": "do you want to skip ssl certificate"},{"name":"events", "required":true, "description": "A comma-separated list"} ]' \
    -a sampleInput '{"username":"myUserName", "siteName":"abcCompany", "accessToken":"123ABCXYZ", "webhookName":"myFirst", "force_http":"true", "events":"jira:issue_created,jira:issue_updated,jira:issue_deleted"}'

waitForAll

echo JIRA package ERRORS = $ERRORS
exit $ERRORS
