#!/usr/bin/env sh
#
# Service.sh for fdclone

# import DroboApps framework functions
. /etc/service.subr

name="fdclone"
version="3.01e"
description="FDclone is a file & directory maintenance tool for the UNIX based OS"

prog_dir="$(dirname "$(realpath "${0}")")"
fdfile="${prog_dir}/bin/fd"
conffile="${prog_dir}/etc/fd2rc"

tmp_dir="/tmp/DroboApps/${name}"
pidfile="${tmp_dir}/pid.txt"
logfile="${tmp_dir}/log.txt"
statusfile="${tmp_dir}/status.txt"
errorfile="${tmp_dir}/error.txt"

start() {
  stop
  ln -s "${fdfile}" "/bin/fd"
  ln -s "${conffile}" "/etc/fd2rc"
  export TERM=xterm
  export TERMINFO="${prog_dir}/share/terminfo"
  return 0
}

stop() {
  rm -f /bin/fd
  rm -f /etc/fd2rc
  return 0
}

# boilerplate
if [ ! -d "${tmp_dir}" ]; then mkdir -p "${tmp_dir}"; fi
exec 3>&1 4>&2 1>> "${logfile}" 2>&1
STDOUT=">&3"
STDERR=">&4"
echo "$(date +"%Y-%m-%d %H-%M-%S"):" "${0}" "${@}"
set -o errexit  # exit on uncaught error code
set -o nounset  # exit on unset variable
set -o xtrace   # enable script tracing


case "$1" in
start)
        start
        ;;
stop)
        stop
        ;;
*)
        echo "Usage: $0 [start|stop]"
        exit 1
        ;;
esac

