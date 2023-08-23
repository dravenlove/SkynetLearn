#!/bin/sh
source `dirname $0`/project.sh
netstat -tlnp | grep skynet | awk '{print $7}' | awk -F"/" '{print $1}' | uniq | xargs kill -9
# rm -rf $ROOT/skynet.pid
