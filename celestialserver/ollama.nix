{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;

    # Listens everywhere, but the port is not opened in the firewall:
    # reachable from localhost and over Tailscale (trusted interface) only.
    host = "0.0.0.0";
    openFirewall = false;

    # Optional: preload models, see https://ollama.com/library
    loadModels = [
      "qwen2.5-coder:14b-instruct-q5_K_M" # Cede review
      "deepseek-r1:14b" # Chain of Thought
    ];
  };

  services.open-webui = {
    enable = true;
    port = 7526;
    environment = {
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
    };
  };

  services.caddy.virtualHosts."chat.localdeer" = {
    extraConfig = ''
      reverse_proxy 127.0.0.1:7526
    '';
  };
}
