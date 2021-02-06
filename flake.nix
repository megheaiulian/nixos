{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    core.url = "github:plumelo/nixos";
    core.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, core }: {
    nixosConfigurations.vision = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = (builtins.attrValues core.nixosModules) ++ [
        ./configuration.nix
        {
          home-manager.users.iulian = { ... }: {
            imports = (builtins.attrValues core.homeModules) ++ [./home.nix];
          };
        }
      ];
    };
  };
}
