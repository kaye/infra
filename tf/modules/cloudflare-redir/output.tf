output "zone_ids" {
  description = "Zone ID for every domain managed by this module, keyed by domain name."
  value       = { for domain, zone in data.cloudflare_zone.this : domain => zone.id }
}

output "primary_record_ids" {
  description = "Record ID for each of the primary domain's apex A records, keyed by IP address."
  value       = { for ip, record in cloudflare_record.primary : ip => record.id }
}

output "redirect_ruleset_ids" {
  description = "Redirect ruleset ID for each redirect domain, keyed by domain name."
  value       = { for domain, ruleset in cloudflare_ruleset.redirect : domain => ruleset.id }
}
