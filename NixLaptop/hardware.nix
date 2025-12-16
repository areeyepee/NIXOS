{config, ...}: {
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
        sync.enable = true;

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
        enable = true;
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

      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
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
}
