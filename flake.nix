{
  description = "Home Manager configuration of yseki";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Nord dircolors theme. Not a flake, so consume it as a plain source tree.
    nord-dircolors = {
      url = "github:nordtheme/dircolors";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      mkHome =
        {
          system,
          username,
          modules,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home/common.nix
            { home.username = username; }
          ]
          ++ modules;
        };
    in
    {
      homeConfigurations = {
        "yseki@yseki-home-mac" = mkHome {
          system = "aarch64-darwin";
          username = "yseki";
          modules = [ ./home/darwin.nix ];
        };

        "yseki@qubo" = mkHome {
          system = "aarch64-darwin";
          username = "yseki";
          modules = [ ./home/darwin.nix ];
        };

        "yseki@ising" = mkHome {
          system = "aarch64-darwin";
          username = "yseki";
          modules = [ ./home/darwin.nix ];
        };

        "yseki@bastion" = mkHome {
          system = "x86_64-linux";
          username = "yseki";
          modules = [ ./home/linux.nix ];
        };
      };
    };
}
