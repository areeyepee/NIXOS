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
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ---- Flakes ----
  nix.settings.experimental-features = ["flakes" "nix-command"];

  # ---- Network ----
  networking.hostName = "NixVM"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  # Enable KDE Plasma DE
  services.desktopManager.plasma6.enable = true;

  # Enable sddm 
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;




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
  users.users.rp = {
    isNormalUser = true;
    description = "Raphael Pertler";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
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

    #--- Base Stuff ---

    rustup
    clang
    python314

    # --- NIX Specific ---
    alejandra
    nixd
    # --- CLI ---
    # -- Misc --
    wget
    fish-lsp
    neofetch

    # -- Tools --
    # -- Git --
    git
    lazygit
    jujutsu
    lazyjj
    # -- Daily Driver --
    zoxide
    fzf
    eza
    dust
    ripgrep-all
    fd
    yazi
    dua
    bat
    # manix is a CLI interface dor NixSearch
    manix
    # nh is nix commands enhanced
    nh
    # tldr rust client
    tlrc
    # rip2 is improved rm. [rip <dir>]
    rip2    
    
    

    #---Applications---
    vscode.fhs
    brave
    warp-terminal
    rustdesk
  ];

  # Ensures nixpkgs Path == nixpkgs in the Flake.
  # Used for nixd configuration.
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  # ---- Programs and Services ----

  programs.ssh.startAgent = true;

  programs.fish.enable = true;
  programs.fish.shellAliases = {
    ez = "eza --color=always --group-directories-first --icons=always";
    ezl = "eza --long --header --tree --level=2 --all --group-directories-first --no-user --no-permissions --no-time";
  };

  programs.television = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "/home/rp/GitHub/NIXOS/nixos/";
  };
  programs.fzf.fuzzyCompletion = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.tailscale.enable = true;


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
