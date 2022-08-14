{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    core.url = "github:plumelo/nixos";
    core.inputs.nixpkgs.follows = "nixpkgs";
    core.inputs.home-manager.url = "github:nix-community/home-manager";
    nixpkgs-nvim.url = "github:nixos/nixpkgs/6b4900c1f19295fbf734848fd7a7f6aa56195a42";
    nix-vim.url = "github:megheaiulian/nix-vim";
    nix-vim.inputs.nixpkgs.follows = "nixpkgs-nvim";
  };

  outputs = { self, nixpkgs, core, nix-vim, ... }: {
    nixosConfigurations.vision = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = (builtins.attrValues core.nixosModules) ++ [
        ./configuration.nix
        ({ ... }: { nix.registry.nixpkgs.flake = nixpkgs; })
        {
          home-manager.users.iulian = { ... }: {
            imports = (builtins.attrValues (nixpkgs.lib.filterAttrs (n: v: n != "lf") core.homeModules)) ++ [ ./home.nix ];
            home.sessionVariables = rec {
              VISUAL = "nvim";
              EDITOR = VISUAL;
            };
            home.packages = [ nix-vim.defaultPackage."x86_64-linux" ];
          };
        }
      ];
    };
  };
}
