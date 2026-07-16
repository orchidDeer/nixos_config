{ config, pkgs, ... }: {
	services.displayManager.sddm.enable = true;
	services.displayManager.sddm.wayland.enable = true;
	services.power-profiles-daemon.enable = true;
	programs.hyprland = {
		enable = true;
		withUWSM = true;
		xwayland.enable = true;
	};
}
