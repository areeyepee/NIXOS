# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nbfc.nix
  ];

  # Enable nix CLI and Flakes.
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Whether to enable fwupd, a DBus service that allows applications to update firmware.

  services.fwupd.enable = true;

  networking.hostName = "NixLaptop"; # Define your hostname.
  #  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # ---- GRAPHICS ----
  # ------------------
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  #Enable Wayland
  services.displayManager.sddm.wayland.enable = true;
  #Enable Plasma 6
  services.desktopManager.plasma6.enable = true;

  services.displayManager.defaultSession = "plasma";

  # --- Nvidia GPU and Driver Configuration

  # Load nvidia Driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    # Enables OpenGL
    graphics.enable = true;

    nvidia = {
      # Modesetting is required
      modesetting.enable = true;

      prime = {
        # Need to use the correct ID's for the system.

        # For current system (14.10.25)
        # amd ID =  pci@0000:06:00.0
        # nvidia ID = pci@0000:01:00.0
        amdgpuBusId = "PCI:06:0:0";
        nvidiaBusId = "PCI:01:0:0";
      };

      # Experimental. CAN CAUSE SLEEP/SUPEND TO FAIL.
      # Fixes glitches and app Crash after sleep, by saving all VRAM memory to /tmp/
      powerManagement = {
        enable = false;
        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        finegrained = false;
      };

      # Enables Nvidia settings menu, via "nvidia-settings"
      nvidiaSettings = true;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      open = true;
    };
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
  };

  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.raphael = {
    isNormalUser = true;
    description = "Raphael Pertler";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];

    shell = pkgs.fish;
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

    # --- Base Stuff ---
    wget
    rustup
    clang
    python314
    micro-full
    uv
    lm_sensors

    # -TeX-
    texliveFull
    tex-fmt

    # --- Nix ---
    alejandra
    nixd

    # --- Apps ---
    vscode.fhs
    brave
    warp-terminal
    kando
    geteduroam

    # --- CLI ---

    #-Nushell-
    nushell
    nufmt
    nushellPlugins.polars
    nushellPlugins.gstat
    nushellPlugins.skim

    # -Misc-
    fish-lsp
    neofetch
    # -Tools-
    fzf
    eza
    dust
    ripgrep-all
    fd
    dua
    manix
    tlrc

    jujutsu
    lazyjj

    fabric-ai
    ollama

    lshw-gui

    espanso-wayland
  ];

  #Ensures that the nixpgs Path is the same as the one in the Flake.
  #Used for the configuration of nixd (LSP)
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  #  --- Fonts ---

  fonts.packages = with pkgs; [
    nerd-fonts.hasklug
    nerd-fonts.jetbrains-mono
    nerd-fonts.monoid
    nerd-fonts.roboto-mono
    nerd-fonts.space-mono
    nerd-fonts.victor-mono
    nerd-fonts.zed-mono
  ];

  # ------- Programs --------

  programs = {
    ssh.startAgent = true; # Start the ssh-agent automatically

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

        extraArgs = "--keep 5 --keep-since 14d";
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

      extraPackages = with pkgs.bat-extras; [core];
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

    coolercontrol.enable = true;
    coolercontrol.nvidiaSupport = true; # Enable support for NVIDIA GPUs

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableFishIntegration = true;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services = {
    openssh = {
      enable = true;
    };

    tailscale = {
      enable = true;
      # If you want to use Tailscale with a specific user, uncomment the following line
      # user = "raphael";
      # If you want to use Tailscale with a specific auth key, uncomment the following line
      # authKey = "your-auth-key-here";
    };

    espanso = {
      enable = true;
    };
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
