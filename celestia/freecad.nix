# Inside your flake's outputs or a separate module
{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.freecad.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.wrapGAppsHook3 ];
      # This ensures the GTK and Qt wrappers play nice together
      qtWrapperArgs = (old.qtWrapperArgs or [ ]) ++ [
        "--set QT_QPA_PLATFORM xcb"
        "\${gappsWrapperArgs[@]}"
      ];
    }))
  ];
}
