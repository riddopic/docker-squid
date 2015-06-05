#!/bin/sh
# encoding: UTF-8
#
# Author:    Stefano Harding <riddopic@gmail.com>
# License:   Apache License, Version 2.0
# Copyright: (C) 2014-2015 Stefano Harding
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

green="printf \\033[1;32m"
red="printf \\033[1;31m"
yellow="printf \\033[1;33m"
blue="printf \\033[34;01m"
normal="printf \\033[0;39m"
tab="printf \\033[60G"
[ -z "$COLOR" ] && COLOR=color

echo_success () {
  [ "$COLOR" = "color" ] && $tab
  printf "[ "
  [ "$COLOR" = "color" ] && $green
  printf "OK"
  [ "$COLOR" = "color" ] && $normal
  echo " ]"
  return 0
}

echo_failure () {
  [ "$COLOR" = "color" ] && $tab
  printf "[ "
  [ "$COLOR" = "color" ] && $red
  printf "FAILED"
  [ "$COLOR" = "color" ] && $normal
  echo " ]"
  return 1
}

echo_warning () {
  [ "$COLOR" = "color" ] && $tab
  printf "[ "
  [ "$COLOR" = "color" ] && $yellow
  printf "WARNING"
  [ "$COLOR" = "color" ] && $normal
  echo " ]"
  return 1
}

printf "Checking that Squid is running..."
services=`docker exec -it squid squidclient mgr:info | grep 'Squid Object Cache' > /dev/null 2>&1`
status=$?
if [[ "$status" != 0 ]]; then
  echo_failure
else
  echo_success
fi