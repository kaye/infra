{ ... }:
{
  perSystem =
    { pkgs, rust-overlay, ... }:
    {
      _module.args.kayeLib = {
        version = builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile ../version);
        pythonTools = pkgs.callPackage ./pythonTools.nix { };
      };
    };
}
