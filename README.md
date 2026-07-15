# Infra

## Quick Start
* Use `nix develop` or `direnv` to pull all required tools via `nix`
* Configure Azure CLI with `azure login`
* Create Terragrunt backend resources manually
* See env vars in [devShell](nix/devShells/default.nix) for Azure resources
* Set Cloudflare API Key in Azure Vault
  ```
  az keyvault secret set \
    --vault-name $AZURE_KEYVAULT_NAME \
    --name CLOUDFLARE-API-TOKEN \
    --value "<REDACTED>"
  ```
