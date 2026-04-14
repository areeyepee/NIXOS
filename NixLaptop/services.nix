{...}: {
  services = {
    openssh = {
      enable = true;
    };

    # Needed for openssh to work with Cosmic DE
    gnome.gcr-ssh-agent.enable = false;

    tailscale = {
      enable = true;
      openFirewall = true;
      extraUpFlags = ["--ssh"];
      # If you want to use Tailscale with a specific user, uncomment the following line
      # user = "raphael";
      # If you want to use Tailscale with a specific auth key, uncomment the following line
      # authKey = "your-auth-key-here";
    };

    # espanso = {
    #   enable = true;
    # };

    ratbagd.enable = true;
  };
}
