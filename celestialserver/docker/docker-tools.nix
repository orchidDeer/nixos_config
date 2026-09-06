{
  pkgs,
  lib,
  ...
}:
let
  # Every compose stack managed on this machine.
  composeProjects = [
    {
      name = "immich";
      dir = "/etc/immich";
    }
    {
      name = "steam-headless";
      dir = "/opt/container-services/steam-headless";
    }
    {
      name = "jellyfin";
      dir = "/etc/jellyfin";
    }
  ];
  projectNames = lib.concatMapStringsSep " " (p: p.name) composeProjects;
  projectCase = lib.concatMapStringsSep "\n" (p: ''
    ${p.name}) dirs+=("${p.dir}") ;;
  '') composeProjects;

  dockerStack = pkgs.writeShellScriptBin "docker-stack" ''
    set -euo pipefail

    usage() {
      echo "Usage: docker-stack <status|update|up|down|restart|logs> [project ...]" >&2
      echo "Known projects: ${projectNames}" >&2
      exit 1
    }

    if [ "$#" -eq 0 ]; then
      usage
    fi
    action="$1"
    shift

    all_dirs=(${lib.concatMapStringsSep " " (p: "\"${p.dir}\"") composeProjects})
    dirs=()
    if [ "$#" -eq 0 ]; then
      dirs=("''${all_dirs[@]}")
    else
      for name in "$@"; do
        case "$name" in
    ${projectCase}
          *)
            echo "Unknown project: $name" >&2
            echo "Known projects: ${projectNames}" >&2
            exit 1
            ;;
        esac
      done
    fi

    for dir in "''${dirs[@]}"; do
      echo "==> $action: $dir"
      case "$action" in
        status)
          (cd "$dir" && ${pkgs.docker}/bin/docker compose ps)
          ;;
        update)
          (cd "$dir" && ${pkgs.docker}/bin/docker compose pull && ${pkgs.docker}/bin/docker compose up -d --remove-orphans)
          ;;
        up)
          (cd "$dir" && ${pkgs.docker}/bin/docker compose up -d --remove-orphans)
          ;;
        down)
          (cd "$dir" && ${pkgs.docker}/bin/docker compose down)
          ;;
        restart)
          (cd "$dir" && ${pkgs.docker}/bin/docker compose restart)
          ;;
        logs)
          (cd "$dir" && ${pkgs.docker}/bin/docker compose logs --tail=100 -f)
          ;;
        *)
          usage
          ;;
      esac
      echo
    done

    if [ "$action" = "update" ]; then
      echo "==> Pruning old images"
      ${pkgs.docker}/bin/docker image prune -f
    fi
  '';
in
{
  virtualisation.docker.enable = true;
  environment.systemPackages = [
    dockerStack
    pkgs.docker
  ];
  environment.shellAliases = {
    dcupdate = "docker-stack update";
    dcstatus = "docker-stack status";
  };
}
