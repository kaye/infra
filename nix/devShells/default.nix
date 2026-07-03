{ ... }:
{
  perSystem =
    { pkgs, kayeLib, ... }:
    let
      inherit (kayeLib.pythonTools) pythonEnv;
      my_azure-cli =
        with pkgs.azure-cli;
        withExtensions [
          extensions.account
          extensions.reservation
        ];
    in
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          cowsay
          opentofu
          terragrunt
          my_azure-cli
        ];
        shellHook = ''
          export ROOT_DIR=$(${pkgs.git}/bin/git rev-parse --show-toplevel)
          ${pkgs.cowsay}/bin/cowsay "Working on project root directory: $ROOT_DIR"
          cd "$ROOT_DIR"
        '';
        # env
        TG_AZURE_RESOURCE_GROUP = "rg-kayeralleta-ae";
        TG_AZURE_STORAGE_ACCOUNT = "kayeralleta";
        TG_AZURE_CONTAINER_NAME = "terragrunt";
      };
    };
}
