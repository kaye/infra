{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    { pkgs, lib, ... }:
    {
      treefmt.config = {
        flakeCheck = true;
        flakeFormatter = true;
        programs.nixfmt.enable = true;
        programs.hclfmt.enable = true;
        programs.shellcheck.enable = true;
        programs.mypy.enable = true;
        programs.terraform.enable = true;
      };
    };
}
