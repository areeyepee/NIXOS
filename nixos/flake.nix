{
  description = "A very basic flake (with flakelight)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flakelight.url = "github:nix-community/flakelight";
    tailscale-src.url = "github:tailscale/tailscale/latest";
  };

  outputs = {
    self,
    flakelight,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations.Nixrp = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        {
          nixpkgs.overlays = [
            (final: prev: {
              tailscale = prev.tailscale.overrideAttrs (old: {
                src = inputs.tailscale-src;
              });
            })
          ];
        }
        ./configuration.nix
      ];
    };
  };
}
