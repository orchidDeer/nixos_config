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
  ];

  projectNames = lib.concatMapStringsSep " " (p: p.name) composeProjects;

  projectCase = lib.concatMapStringsSep "\n" (p: ''
    ${p.name}) dirs+=("${p.dir}") ;;
  '') composeProjects;

  updateDockerStacks = pkgs.writeShellScriptBin "docker-update-all" ''
    set -euo pipefail

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
      echo "==> Updating stack in $dir"
      cd "$dir"
      ${pkgs.docker}/bin/docker compose pull
      ${pkgs.docker}/bin/docker compose up -d --remove-orphans
    done

    echo "==> Pruning old images"
    ${pkgs.docker}/bin/docker image prune -f
  '';

  statusDockerStacks = pkgs.writeShellScriptBin "docker-status-all" ''
    set -euo pipefail

    all_dirs=(${lib.concatMapStringsSep " " (p: "\"${p.dir}\"") composeProjects})
    all_names=(${lib.concatMapStringsSep " " (p: "\"${p.name}\"") composeProjects})

    for i in "''${!all_dirs[@]}"; do
      dir="''${all_dirs[$i]}"
      name="''${all_names[$i]}"
      echo "==> $name ($dir)"
      (cd "$dir" && ${pkgs.docker}/bin/docker compose ps)
      echo
    done
  '';

in
{
  virtualisation.docker.enable = true;

  environment.systemPackages = [
    updateDockerStacks
    statusDockerStacks
    pkgs.docker
  ];
  environment.shellAliases = {
    dcupdate = "docker-update-all";
    dcstatus = "docker-status-all";
  };
}
