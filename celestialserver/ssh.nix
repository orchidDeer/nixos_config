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
    extraConfig = "MaxAuthTries 3 \n PerSourcePenalties crash:3600s authfail:3600s max:86400s";
  };

  services.endlessh = {
    enable = true;
    port = 22;
    openFirewall = true;
  };
}
