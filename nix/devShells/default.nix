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
          export CLOUDFLARE_API_TOKEN=$(az keyvault secret show \
            --vault-name "$AZURE_KEYVAULT_NAME" \
            --name "CLOUDFLARE-API-TOKEN" \
            --query value -o tsv 2>/dev/null)
        '';
        # envs for terragrunt backend
        TG_AZURE_RESOURCE_GROUP = "rg-kayeralleta-ae";
        TG_AZURE_STORAGE_ACCOUNT = "kayeralleta";
        TG_AZURE_CONTAINER_NAME = "terragrunt";
        # env for azure-cli
        AZURE_KEYVAULT_NAME = "kv-kayeralleta-ae";
      };
    };
}
