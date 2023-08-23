#!/bin/sh
source `dirname $0`/project.sh
kill 'cat $ROOT/skynet.pid'
rm -rf $ROOT/skynet.pid