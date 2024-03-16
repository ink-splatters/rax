{
  description = "basic native shell";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  nixConfig = {
    extra-substituters = "https://cachix.cachix.org";
    extra-trusted-public-keys =
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM=";
  };

  outputs = { nixpkgs, flake-utils, pre-commit-hooks, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nativeBuildInputs = [ pkgs.gnumake ];

      in with pkgs; {

        checks.pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            deadnix.enable = true;
            markdownlint.enable = true;
            nil.enable = true;
            nixfmt.enable = true;
            statix.enable = true;
          };

          tools = pkgs;
        };

        formatter = nixfmt;

        devShells.default = mkShell {
          inherit nativeBuildInputs;

          shellHook = self.checks.${system}.pre-commit-check.shellHook + ''
            export PS1="\n\[\033[01;36m\]‹⊂› \\$ \[\033[00m\]"
          '';
        };
      });
}
