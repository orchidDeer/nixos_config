{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;

    host = "0.0.0.0";
    openFirewall = true;

    # Optional: preload models, see https://ollama.com/library
    loadModels = [
      "qwen2.5-coder:14b-instruct-q5_K_M" # Cede review
      "qwen3.5:9b-instruct-q8_0" # Brainstorming
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
      tls internal
    '';
  };
}
