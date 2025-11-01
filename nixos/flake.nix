{
  description = "A very basic flake (with flakelight)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flakelight.url = "github:nix-community/flakelight";
    
  };

  outputs = {
    self,
    flakelight,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations.NixVM = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./configuration.nix
      ];
      specialArgs = {inherit inputs;};
    };
  };
}
