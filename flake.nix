{
  description = "Homelab Server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    tailscale.url = "github:tailscale/tailscale";
    tailscale.flake = false;

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    tailscale,
    sops-nix,
    ...
  } @ inputs: {
    nixosConfigurations.NixServer = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

        sops-nix.nixosModules.sops
        ({pkgs, ...}: {
          nixpkgs.overlays = [
            (final: prev: {
              tailscale = prev.tailscale.overrideAttrs (old: {
                src = tailscale;
              });
            })
          ];
        })
      ];
    };
  };
}
