{
  description = "Dune flake template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      eachSystem =
        fn:
        (nixpkgs.lib.genAttrs systems (
          system:
          fn {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
        ));

      systems = [
        "x86_64-darwin"
        "x86_64-linux"
        "aarch64-darwin"
        "aarch64-linux"
      ];

      projectName = "hello";
    in
    {

      packages = eachSystem (
        { pkgs, system }:
        {
          default = self.packages.${system}.${projectName};

          "${projectName}" = pkgs.writeScriptBin "${projectName}" ''
            #!${pkgs.bash}/bin/bash
            echo "Hello, World!"
          '';
        }
      );

      apps = eachSystem (
        { system, ... }:
        {
          default = self.apps.${system}.${projectName};

          "${projectName}" = {
            type = "app";
            program = "${self.packages.${system}.${projectName}}/bin/${projectName}";
            meta = {
              description = "Nix flake template";
              mainProgram = self.packages.${system}.${projectName};
            };
          };
        }
      );

      checks = eachSystem (
        { pkgs, system }:
        {
          "${projectName}-tests" =
            pkgs.runCommandLocal "${projectName}-tests"
              {
                nativeBuildInputs = [ self.packages.${system}.default ];
              }
              ''
                output=$(${self.packages.${system}.default}/bin/${projectName})
                if [[ "$output" != "Hello, World!" ]]; then
                    echo "Script output does not match expected 'Hello, World!'"
                    echo "Got: '$output'"
                    exit 1
                fi
                touch $out
              '';

          pre-commit = inputs.pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              actionlint.enable = true;
              deadnix.enable = true;
              flake-checker.enable = true;
              treefmt = {
                enable = true;
                settings.formatters = with pkgs; [
                  nixfmt-rfc-style
                  taplo
                  yamlfmt
                  nodePackages.prettier
                ];
              };
            };
          };
        }
      );

      devShells = eachSystem (
        { pkgs, system }:
        {
          default = self.devShells.${system}.${projectName};

          "${projectName}" = pkgs.mkShell {
            inherit (self.checks.${system}.pre-commit) shellHook;

            buildInputs =
              with pkgs;
              [
                nixd
              ]
              ++ self.checks.${system}.pre-commit.enabledPackages
              ++ self.checks.${system}."${projectName}-tests".buildInputs;
          };
        }
      );
      formatter = eachSystem ({ pkgs, ... }: pkgs.treefmt);
    };
}
