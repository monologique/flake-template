{
  description = "monologique's flake template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      devenv,
      systems,
    }@inputs:
    let
      pname = "hello";

      eachSystem =
        fn:
        (nixpkgs.lib.genAttrs (import systems) (
          system:
          fn ({
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          })
        ));

    in
    {
      packages = eachSystem (
        { pkgs, system }:
        {
          default = pkgs.writeScriptBin "${pname}" ''
            #!${pkgs.bash}/bin/bash
            echo "Hello, World!"
          '';

          devenv-up = self.devShells.${system}.default.config.procfileScript;

          devenv-test = self.devShells.${system}.default.config.test;
        }
      );

      apps = eachSystem (
        { system, ... }:
        {
          default = {
            type = "app";
            program = "${self.packages.${system}.default}/bin/${pname}";
            meta = {
              description = "monologique's flake template";
              mainProgram = self.packages.${system}.default;
            };
          };
        }
      );

      checks = eachSystem (
        { pkgs, system }:
        {
          tests =
            pkgs.runCommandLocal "check-${pname}-output"
              {
                nativeBuildInputs = [ self.packages.${system}.default ];
              }
              ''
                output=$(${self.packages.${system}.default}/bin/${pname})
                if [[ "$output" != "Hello, World!" ]]; then
                    echo "Script output does not match expected 'Hello, World!'"
                    echo "Got: '$output'"
                    exit 1
                fi
                touch $out
              '';
        }
      );

      devShells = eachSystem (
        { pkgs, system }:

        {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;

            modules = [
              {
                packages = with pkgs; [
                  yaml-language-server
                ];

                enterShell = ''
                  echo "Hello!"
                '';

                git-hooks.hooks = {
                  # Formatting
                  treefmt = {
                    enable = true;
                    settings.formatters = with pkgs; [
                      nixfmt-rfc-style
                      nodePackages.prettier
                      taplo
                      yamlfmt
                    ];
                  };
                  # Lint
                  actionlint.enable = true;
                  flake-checker.enable = true;
                  deadnix.enable = true;
                  yamllint.enable = true;
                };

                processes.${pname}.exec = self.apps.${system}.default.program;
              }
            ];
          };
        }
      );

      formatter = eachSystem ({ pkgs, ... }: pkgs.nixfmt-rfc-style);
    };
}
