{
  config,
  inputs,
  pkgs,
  ...
}: let
  user = "raphael";
  command = "bin/nbfc_service --config-file ´/home/${user}/.config/nbfc.json´";
in {
  environment.systemPackages = with pkgs; [
    nbfc-linux
  ];

  systemd.services.nbfc_service = {
    enable = true;

    description = "NoteBook FanControl service";

    serviceConfig.Type = "simple";
    path = [pkgs.kmod];

    script = "${pkgs.nbfc-linux}/${command}";

    wantedBy = ["multi-user.target"];
  };
}
