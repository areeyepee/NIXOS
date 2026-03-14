# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nbfc.nix
    ./packages.nix
    ./programs.nix
    ./services.nix
    ./network.nix
    ./hardware.nix
  ];

  # Enable nix CLI and Flakes.
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Whether to enable fwupd, a DBus service that allows applications to update firmware.
  services.fwupd.enable = true;

  networking.hostName = "NixLaptop"; # Define your hostname.
  #networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  #networking.useDHCP = true;

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

  # --- Power Management ---

  #  services.auto-cpufreq.enable = true;
  # services.auto-cpufreq.settings = {
  #   battery = {
  #   governor = "powersave";
  #     turbo = "never";
  #  };
  #  charger = {
  #    governor = "performance";
  #    turbo = "auto";
  #  };
  #};
  # ---- GRAPHICS ----
  # ------------------

  # --- Desktop Environment Configuration ---

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  # Enable Wayland support in SDDM.
  #services.displayManager.sddm.wayland.enable = true;

  # -- Desktop Environment --
  # Enable the KDE Plasma Desktop Environment.
  #services.displayManager.sddm.enable = true;
  #Enable Plasma 6
  #services.desktopManager.plasma6.enable = true;

  # -- COSMIC DE --
  # Enable Cosmic Desktop Environment
  services.desktopManager.cosmic.enable = true;
  # Enable the Cosmic greeter (login screen)
  services.displayManager.cosmic-greeter.enable = true;

  services.desktopManager.cosmic.xwayland.enable = true;
  # Set the default session for the display Manager
  #services.displayManager.defaultSession = "plasma";

  # --- Nvidia GPU and Driver Configuration

  # Load nvidia Driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

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

  # ----- Services -----
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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
