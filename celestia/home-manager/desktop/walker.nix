{ ... }:
{
  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      search.placeholder = "Launch Application...";
    };
  };
}
