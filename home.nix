{ config, pkgs, ... }:
{

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "hweissi";
  home.homeDirectory = "/home/hweissi";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".p10k.zsh".source = config/zsh/.p10k.zsh;
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/hweissi/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # programs.zsh.ohMyZsh.customPkgs = [ pkgs.zsh-powerlevel10k ];
#   programs.zsh = {
#     enable = true;
#     oh-my-zsh = {
#       enable = true;
#       plugins = [ 
#           "git"
#           "common-aliases"
#           "thefuck"
#           "zsh-syntax-highlighting"
#           "zsh-autosuggestions"
#           "bgnotify"
#           "archlinux"
#           "z"
#           "cp"
#           "transfer"];
      
#       #promptInit = "source ./config/zsh/p10k-config/.p10k.zsh";
#       theme = "powerlevel10k";
#       #setOptions = [
#       #  "COMPLETION_WAITING_DOTS"
#       #  "HIST_IGNORE_DUPS"
#       #  "HIST_FCNTL_LOCK"
#       #];
#       shellAliases = {
#         ls = "lsd --group-directories-first";
#         pc = "echo -n $(pwd) | wl-copy --primary";
#         icat = "kitty +kitten icat";
#       };
#       shellInit = ''function angrshell() {
#     if [ $# -gt 1 ]
#     then
#         echo "Usage: angrshell <path>"
#         return
#     fi
#     readonly vpath=''${1:-"."}
#     docker run --rm -it -v "$vpath:/pwd" angr/angr
# }
# function gi() { curl -sLw n https://www.toptal.com/developers/gitignore/api/$@ ;}'';
#     };
#   };
  
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
        plugins = [ 
          "git"
          "common-aliases"
          "thefuck"
          "bgnotify"
          "archlinux"
          "z"
          "cp"
          "transfer"
        ];
        extraConfig = 
        ''
        setopt appendhistory
        '';
    };
    history = {
      share = false;

    };
    sessionVariables = {
      COMPLETION_WAITING_DOTS = true;
    };
    shellAliases = {
      ls = "lsd --group-directories-first";
      pc = "echo -n $(pwd) | wl-copy --primary";
      icat = "kitty +kitten icat";
    };
    initExtraFirst = 
    ''
    source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
      source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
    fi
    '';
    initExtra = 
    ''
    function angrshell() {
      if [ $# -gt 1 ]
      then
          echo "Usage: angrshell <path>"
          return
      fi
      readonly vpath=''${1:-"."}
      docker run --rm -it -v "$vpath:/pwd" angr/angr
    }
    function gi() { curl -sLw n https://www.toptal.com/developers/gitignore/api/$@ ;}

    export WORKON_HOME=~/.virtualenvs
    source /usr/bin/virtualenvwrapper.sh

    source ~/.p10k.zsh
    '';
  };
  programs.git = {
    enable = true;
    userEmail = "h.weissteiner@gmail.com";
    userName = "Hannes Weissteiner";
    extraConfig = {
      pull.rebase = false;
    };
  };

  programs.vscode = {
    enable = true;  
    extensions = 
    let 
      vscode-market =
        (import (builtins.fetchGit {
          url = "https://github.com/nix-community/nix-vscode-extensions";
          ref = "refs/heads/master";
          rev = "c43d9089df96cf8aca157762ed0e2ddca9fcd71e";
      })).extensions.${pkgs.system}.vscode-marketplace;
    in 
      [
        vscode-market.endormi."2077-theme"
        vscode-market.znck.grammarly
        vscode-market.atommaterial.a-file-icon-vscode
        vscode-market.donjayamanne.python-environment-manager
        pkgs.vscode-extensions.ziglang.vscode-zig
        pkgs.vscode-extensions.ms-vscode.cpptools
        pkgs.vscode-extensions.tamasfe.even-better-toml
        pkgs.vscode-extensions.james-yu.latex-workshop
        pkgs.vscode-extensions.marp-team.marp-vscode
        pkgs.vscode-extensions.jnoortheen.nix-ide
        pkgs.vscode-extensions.ms-python.vscode-pylance
        pkgs.vscode-extensions.ms-vscode-remote.remote-ssh
      ];
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = false;
    userSettings = {
        "workbench.colorTheme" = "2077";
        "workbench.iconTheme" = "a-file-icon-vscode";
        "python.experiments.enabled" = false;
        "python.globalModuleInstallation" = true;
        "editor.inlayHints.enabled" = "offUnlessPressed";
        "editor.fontFamily" = "'FiraCode Nerd Font'";
        "editor.fontLigatures" = true;
        "window.titleBarStyle" = "custom";
        "workbench.editorAssociations" = {
            "*.bin" = "default";
            "*.pdf" = "latex-workshop-pdf-hook";
        };
        "extensions.autoUpdate" = false;
        "latex-workshop.latex.recipes"= [


            {
                "name" = "latexmk";
                "tools" = [
                    "latexmk"
                ];
            }
            {
                "name" = "latexmk (latexmkrc)";
                "tools" = [
                    "latexmk_rconly"
                ];
            }
            {
                "name" = "latexmk (lualatex)";
                "tools" = [
                    "lualatexmk"
                ];
            }
            {
                "name" = "latexmk (xelatex)";
                "tools" = [
                    "xelatexmk"
                ];
            }
            {
                "name" = "pdflatex -> bibtex -> pdflatex * 2";
                "tools" = [
                    "pdflatex"
                    "bibtex"
                    "pdflatex"
                    "pdflatex"
                ];
            }
            {
                "name" = "Compile Rnw files";
                "tools" = [
                    "rnw2tex"
                    "latexmk"
                ];
            }
            {
                "name" = "Compile Jnw files";
                "tools" = [
                    "jnw2tex"
                    "latexmk"
                ];
            }
            {
                "name" = "Compile Pnw files";
                "tools" = [
                    "pnw2tex"
                    "latexmk"
                ];
            }
            {
                "name" = "tectonic";
                "tools" = [
                    "tectonic"
                ];
            }
        ];
        "latex-workshop.latex.external.build.command" = "make";
        "[latex]" = {
            "editor.wordWrap" = "bounded";
            "editor.wordWrapColumn" = 120;
        };
        "grammarly.config.documentDomain" = "academic";
        "grammarly.config.suggestionCategories.ConjunctionAtStartOfSentence" = true;
        "grammarly.config.suggestionCategories.InformalPronounsAcademic" = true;
        "grammarly.config.suggestionCategories.OxfordComma" = true;
        "python.defaultInterpreterPath" = "/home/hweissi/.virtualenvs/ctf";
        "window.zoomLevel" = 2;
        "nix.enableLanguageServer" = true;
    };
    
  };

  targets.genericLinux.enable = true;
}
