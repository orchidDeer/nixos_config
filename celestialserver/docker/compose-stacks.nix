{
  config,
  lib,
  pkgs,
  ...
}:
# Declarative docker compose stacks.
#
#   local.composeStacks.<name> = {
#     files.<filename> = ./some-file.yml;   # must include docker-compose.yml
#     envFile = ./secrets.env;              # optional, sops-encrypted dotenv
#   };
#
# Each stack gets /etc/compose/<name>/ (files + .env), a sops secret and a
# systemd unit <name>.service. Editing a file or secret makes nixos-rebuild
# *reload* the unit, which runs `up -d` and recreates only changed containers.
let
  cfg = config.local.composeStacks;
  docker = "${pkgs.docker}/bin/docker";
  compose = name: "${docker} compose -p ${name}";
in
{
  options.local.composeStacks = lib.mkOption {
    default = { };
    description = "Docker compose stacks managed by systemd.";
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          files = lib.mkOption {
            type = lib.types.attrsOf lib.types.path;
            description = "Files placed in /etc/compose/<name>/, keyed by filename.";
          };
          envFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = "sops-encrypted dotenv, linked as /etc/compose/<name>/.env.";
          };
        };
      }
    );
  };

  config = lib.mkIf (cfg != { }) {
    virtualisation.docker.enable = true;

    sops.secrets = lib.mapAttrs' (
      name: stack:
      lib.nameValuePair "${name}_env" {
        sopsFile = stack.envFile;
        format = "binary";
        path = "/run/secrets/${name}.env";
        owner = "root";
        mode = "0400";
      }
    ) (lib.filterAttrs (_: s: s.envFile != null) cfg);

    environment.etc = lib.mkMerge (
      lib.mapAttrsToList (
        name: stack:
        lib.mapAttrs' (file: src: lib.nameValuePair "compose/${name}/${file}" { source = src; }) stack.files
        // lib.optionalAttrs (stack.envFile != null) {
          "compose/${name}/.env".source = config.sops.secrets."${name}_env".path;
        }
      ) cfg
    );

    systemd.services = lib.mapAttrs (name: stack: {
      description = "Docker compose stack ${name}";
      after = [ "docker.service" ];
      requires = [ "docker.service" ];
      wantedBy = [ "multi-user.target" ];
      # Content hashes, so unrelated repo changes don't trigger a reload.
      reloadTriggers = map (builtins.hashFile "sha256") (
        lib.attrValues stack.files ++ lib.optional (stack.envFile != null) stack.envFile
      );
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        WorkingDirectory = "/etc/compose/${name}";
        ExecStart = "${compose name} up -d --remove-orphans";
        ExecReload = "${compose name} up -d --remove-orphans";
        ExecStop = "${compose name} down";
        TimeoutStartSec = "300";
      };
    }) cfg;
  };
}
