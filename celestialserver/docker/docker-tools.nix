{
  config,
  pkgs,
  lib,
  ...
}:
let
  # Stacks come from local.composeStacks (see compose-stacks.nix).
  stackNames = lib.attrNames config.local.composeStacks;
  docker = "${pkgs.docker}/bin/docker";

  dockerStack = pkgs.writeShellScriptBin "docker-stack" ''
    set -euo pipefail

    known=(${lib.escapeShellArgs stackNames})

    usage() {
      echo "Usage: docker-stack <status|update|up|down|restart> [stack ...]" >&2
      echo "       docker-stack logs <stack> [service ...]" >&2
      echo "Stacks: ''${known[*]}" >&2
      exit 1
    }

    check() {
      for k in "''${known[@]}"; do [ "$k" = "$1" ] && return 0; done
      echo "Unknown stack: $1 (known: ''${known[*]})" >&2
      exit 1
    }

    compose() {
      local stack="$1"; shift
      (cd "/etc/compose/$stack" && ${docker} compose -p "$stack" "$@")
    }

    [ "$#" -ge 1 ] || usage
    action="$1"; shift

    if [ "$action" = "logs" ]; then
      [ "$#" -ge 1 ] || usage
      check "$1"
      stack="$1"; shift
      compose "$stack" logs --tail=100 -f "$@"
      exit
    fi

    stacks=("$@")
    [ "''${#stacks[@]}" -gt 0 ] || stacks=("''${known[@]}")
    for s in "''${stacks[@]}"; do check "$s"; done

    for s in "''${stacks[@]}"; do
      echo "==> $action: $s"
      case "$action" in
        status)  compose "$s" ps ;;
        update)  compose "$s" pull && compose "$s" up -d --remove-orphans ;;
        # go through systemd so `systemctl status <stack>` stays truthful
        up)      systemctl start "$s" ;;
        down)    systemctl stop "$s" ;;
        restart) systemctl restart "$s" ;;
        *)       usage ;;
      esac
      echo
    done

    if [ "$action" = "update" ]; then
      echo "==> Pruning old images"
      ${docker} image prune -f
    fi
  '';
in
{
  environment.systemPackages = [
    dockerStack
    pkgs.docker
  ];
  environment.shellAliases = {
    dcupdate = "docker-stack update";
    dcstatus = "docker-stack status";
  };
}
