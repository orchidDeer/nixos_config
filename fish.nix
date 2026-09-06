{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    functions = {
      fish_prompt = ''
        set_color normal
        echo -n "[🪷 "
        set_color d7afd7
        echo -n (date "+%H:%M:%S")
        set_color normal
        echo -n " <"
        set_color d7d7ff
        echo -n $USER
        set_color normal
        echo -n "@"
        set_color d7d7ff
        echo -n (string split -m1 "." -- (hostname))[1]
        set_color normal
        echo -n ">"
        set_color ffaf87
        __fish_git_prompt " (%s)"
        set_color normal
        echo -n " "
        set_color ffafaf
        echo -n (prompt_pwd)
        set_color normal
        echo -n " 🪷]"
        echo
        echo -n " "
        set_color ff875f
        echo -n "🍂 ▶ "
        set_color normal
      '';
      fish_title = ''
        echo "🪷"
      '';
    };
  };
  programs.bash = {
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
}
