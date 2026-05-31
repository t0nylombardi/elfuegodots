# ── Minecraft Server Control ───────────────────────────────────────────────────
# Usage: mcs <server> <start|stop|restart|status>
# Each command is its own function; mcs() just validates and dispatches.

_mcs_service()  { echo "mcs-${1}"; }
_mcs_is_running() { launchctl list | grep -q "${1}$"; }

_mcs_start() {
  local svc=$(_mcs_service "$1")
  launchctl start "$svc" && echo "▶  $svc started"
}

_mcs_stop() {
  local svc=$(_mcs_service "$1")
  launchctl stop "$svc" && echo "⏹  $svc stopped"
}

_mcs_restart() {
  _mcs_stop "$1" && sleep 2 && _mcs_start "$1"
}

_mcs_status() {
  local svc=$(_mcs_service "$1")
  _mcs_is_running "$svc" \
    && echo "🟢 $svc is running" \
    || echo "🔴 $svc is not running"
}

_mcs_usage() { echo "Usage: mcs <server> <start|stop|restart|status>"; }

mcs() {
  local server="$1" cmd="$2"

  [[ -z "$server" || -z "$cmd" ]] && { _mcs_usage; return 1; }

  case "$cmd" in
    start)   _mcs_start   "$server" ;;
    stop)    _mcs_stop    "$server" ;;
    restart) _mcs_restart "$server" ;;
    status)  _mcs_status  "$server" ;;
    *)       echo "Unknown command: $cmd"; _mcs_usage; return 1 ;;
  esac
}
