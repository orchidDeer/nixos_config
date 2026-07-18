{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false; # silences the second warning

    settings."*" = {
      ForwardAgent = false;
      AddKeysToAgent = "no";
      Compression = false;
      ServerAliveInterval = 0;
      ServerAliveCountMax = 3;
      HashKnownHosts = false;
      UserKnownHostsFile = "~/.ssh/known_hosts";
      ControlMaster = "no";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "no";
    };

    settings."celestialserver.localdeer" = {
      HostName = "celestialserver.localdeer";
      User = "juna";
      Port = 5432; # or your real ssh port
      IdentityFile = "~/.ssh/celestia";
    };
  };
}
