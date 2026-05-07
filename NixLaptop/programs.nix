{pkgs, ...}: {
  programs = {

    nix-ld.enable = true; # Enable nix-ld for running non-Nix applications in a Nix environment
    # THIS IS NEEDED TO USE UV WITH PYTHON!!!
    ssh.startAgent = true; # Start the ssh-agent automatically
   # ssh.knownHosts = {
   #   Codeberg = {
   #     hostNames = ["codeberg.org"];
   #     publicKeyFile = "/home/raphael/.ssh/id_ed25519";
   #   };

   #   Github = {
   #     hostNames = ["github.com"];
   #     publicKeyFile = "/home/raphael/.ssh/GitHub";
   #   };
   # };

    fish = {
      enable = true;
      shellAliases = {
        ez = "eza --color=always --group-directories-first --icons=always";
        ezl = "eza --long --header --tree --level=2 --all --group-directories-first --no-user --no-permissions --no-time";
      };
    };

    nh = {
      enable = true;

      flake = "/home/raphael/NIX/NIXOS/NixLaptop/"; # String to the default Flake that nh should use for (e.g nh os switch flake)

      clean = {
        enable = true;

        extraArgs = "--keep 3 --keep-since 14d";
      };
    };

    zoxide = {
      enable = true;

      enableFishIntegration = true;
    };

    fzf = {
      fuzzyCompletion = true;
    };

    yazi = {
      enable = true;
    };

    bat = {
      enable = true;

    };

    git = {
      enable = true;

      config = {
        user.name = "areeyepee";

        user.email = "rp@proton.me";

        init.defaultBranch = "main";
      };
    };

    lazygit = {
      enable = true;
    };

    #coolercontrol.enable = true;
    # coolercontrol.nvidiaSupport = true; # Enable support for NVIDIA GPUs

    # direnv = {
    #  enable = true;
    #  nix-direnv.enable = true;
    #  enableFishIntegration = true;
    #};

    steam = {
      enable = true;
    };

    extra-container.enable = true;
  };
}
