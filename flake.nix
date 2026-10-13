{
  description = "Home Manager configuration of yseki";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
            # TEMPORARY: work around pstoedit 4.3 failing to build on darwin.
            # Remove this whole overlays list once fixed upstream
            # (the --replace-fail below will start failing at that point).
            overlays = [
              (final: prev: {
                pstoedit = prev.pstoedit.overrideAttrs (
                  old:
                  prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
                    postPatch = (old.postPatch or "") + ''
                      substituteInPlace src/drvsvg.cpp \
                        --replace-fail 'defined (NetBSD) )' 'defined (NetBSD) || defined(__APPLE__) )'
                    '';
                  }
                );
              })
            ];
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

        "yseki@gdev01" = mkHome {
          system = "x86_64-linux";
          username = "yseki";
          modules = [ ./home/linux.nix ];
        };

        "yseki@bastion" = mkHome {
          system = "x86_64-linux";
          username = "yseki";
          modules = [ ./home/linux.nix ];
        };
      };
    };
}
