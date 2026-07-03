include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../modules/cloudflare-redir"
}

inputs = {
  primary_domain = "ralleta.com.au"
  primary_record_values = [
    "198.185.159.144"
    , "198.185.159.145"
    , "198.49.23.144"
    , "198.49.23.145"
  ]
  redirect_domains = ["ralleta.com", "ralleta.au"]

  mx_records = [
    { priority = 1, content = "aspmx.l.google.com" },
    { priority = 5, content = "alt1.aspmx.l.google.com" },
    { priority = 5, content = "alt2.aspmx.l.google.com" },
    { priority = 10, content = "alt3.aspmx.l.google.com" },
    { priority = 10, content = "alt4.aspmx.l.google.com" },
  ]
  spf_includes = ["_spf.google.com"]
}
