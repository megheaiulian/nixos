{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    core.url = "github:plumelo/nixos";
    core.inputs.nixpkgs.follows = "nixpkgs";
    core.inputs.home-manager.url = "github:nix-community/home-manager";
    nix-vim.url = "github:megheaiulian/nix-vim";
    nix-vim.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = github:nix-community/NUR;
  };

  outputs = { self, nixpkgs, core, nix-vim, nur, ... }: {
    nixosConfigurations.vision = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = (builtins.attrValues core.nixosModules) ++ [
        ./configuration.nix
        ({ ... }: {
          nix.registry.nixpkgs.flake = nixpkgs;
          nixpkgs.overlays = [
            (final: prev: ({
              nur = import nur {
                nurpkgs = prev;
                pkgs = prev;
              };
            }))
          ];
        })


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
