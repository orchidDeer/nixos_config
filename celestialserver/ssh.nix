{
  services.openssh = {
    enable = true;
    ports = [ 10233 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "juna" ];
    };
    extraConfig = "MaxAuthTries 3 \n PerSourcePenalties crash:360s authfail:360s max:8640s";
  };

  services.endlessh = {
    enable = true;
    port = 22;
    openFirewall = true;
  };
}
