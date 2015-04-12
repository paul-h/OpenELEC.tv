#!/bin/sh
#      Copyright (C) 2008-2013 Team XBMC
#      http://xbmc.org
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.

. /etc/profile

trap cleanup TERM

SAVED_ARGS="$@"
CRASHLOG_DIR=/storage/.mythtv/temp

cleanup() {
  # make systemd happy by not exiting immediately but
  # wait for mythfrontend to exit
  while killall -0 mythfrontend &>/dev/null; do
    sleep 0.5
  done
}

command_exists()
{
  command -v $1 &>/dev/null
}

single_stacktrace()
{
  # core filename is "core.*mythfrontend.*"
  find "$1" -name 'core.*mythfrontend.*' | while read core; do
    echo "=====>  Core file: "$core"" >> $FILE
    echo "        =========================================" >> $FILE
    gdb /usr/lib/mythtv/mythfrontend --core="$core" --batch -ex "thread apply all bt" 2>/dev/null >> $FILE
    rm -f "$core"
  done
}

print_crash_report()
{
  if [ ! -d $CRASHLOG_DIR ] ; then
    mkdir -p $CRASHLOG_DIR
  fi
  DATE=`date +%Y%m%d%H%M%S`
  FILE="$CRASHLOG_DIR/mythtv_crashlog_$DATE.log"
  echo "############## mythfrontend CRASH LOG ###############" > $FILE
  echo >> $FILE
  echo "################ SYSTEM INFO ################" >> $FILE
  echo -n " Date: " >> $FILE
  date >> $FILE
  echo " mythfrontend Options: $SAVED_ARGS" >> $FILE
  echo -n " Arch: " >> $FILE
  uname -m >> $FILE
  echo -n " Kernel: " >> $FILE
  uname -rvs >> $FILE
  echo -n " Release: " >> $FILE
  . /etc/os-release
  echo $NAME $VERSION >> $FILE
  echo "############## END SYSTEM INFO ##############" >> $FILE
  echo >> $FILE
  echo "############### STACK TRACE #################" >> $FILE
  if command_exists gdb; then
    single_stacktrace /storage/.cache/cores
  else
    echo "gdb not installed, can't get stack trace." >> $FILE
  fi
  echo "############# END STACK TRACE ###############" >> $FILE
  echo >> $FILE
  echo "################# LOG FILE ##################" >> $FILE
  echo >> $FILE
  cat /storage/.mythtv/temp/mythfrontend.log >> $FILE
  echo >> $FILE
  echo "############### END LOG FILE ################" >> $FILE
  echo >> $FILE
  echo "############ END mythfrontend CRASH LOG #############" >> $FILE
  echo "Crash report available at $FILE"
}

if command_exists gdb; then
  ulimit -c unlimited
fi

# clean up any stale cores. just in case
rm -f /storage/.cache/cores/*

/usr/lib/mythtv/mythfrontend $SAVED_ARGS
RET=$?

if [ $(( ($RET >= 131 && $RET <= 136) || $RET == 139 )) = "1" ] ; then
  # Crashed with core dump
  print_crash_report

  # Cleanup. Keep only youngest 10 reports
  rm -f $(ls -1t $CRASHLOG_DIR/mythtv_crashlog_*.log | tail -n +11)
fi

exit $RET
