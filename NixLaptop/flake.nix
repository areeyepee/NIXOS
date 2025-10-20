{
  inputs = {
    # This is pointing to an unstable release.
    # If you prefer a stable release instead, you can this to the latest number shown here: https://nixos.org/download
    # i.e. nixos-24.11
    # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    espanso-fix.url = "github:pitkling/nixpkgs/espanso-fix-capabilities-export";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    espanso-fix,
    ...
  }: let
    system = "x86_64-linux";
    #	hostname = "NixLaptop";
    #	username = "areeyepee";
  in {
    # NOTE: 'nixos' is the default hostname
    #  inherit hostname;
    nixosConfigurations.NixLaptop = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        espanso-fix.nixosModules.espanso-capdacoverride
      ];
      specialArgs = {inherit inputs;};
    };
  };
}
