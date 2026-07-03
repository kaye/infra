locals {
  all_domains    = toset(concat([var.primary_domain], var.redirect_domains))
  redirect_hosts = setproduct(var.redirect_domains, ["@", "www"])
}

data "cloudflare_zone" "this" {
  for_each = local.all_domains
  name     = each.key
}

resource "cloudflare_record" "primary" {
  for_each = toset(var.primary_record_values)
  zone_id  = data.cloudflare_zone.this[var.primary_domain].id
  name     = "@"
  type     = "A"
  content  = each.value
  ttl      = 1
  proxied  = var.primary_record_proxied
}

resource "cloudflare_record" "mx" {
  for_each = {
    for pair in setproduct(local.all_domains, var.mx_records) :
    "${pair[0]}/${pair[1].priority}-${pair[1].content}" => pair
  }
  zone_id  = data.cloudflare_zone.this[each.value[0]].id
  name     = "@"
  type     = "MX"
  content  = each.value[1].content
  priority = each.value[1].priority
  ttl      = 3600
}

resource "cloudflare_record" "spf" {
  for_each = length(var.spf_includes) > 0 ? local.all_domains : toset([])
  zone_id  = data.cloudflare_zone.this[each.key].id
  name     = "@"
  type     = "TXT"
  content  = "v=spf1 ${join(" ", [for i in var.spf_includes : "include:${i}"])} ~all"
  ttl      = 3600
}

# CNAME records so Cloudflare's edge receives traffic for the redirect
# domains -- the redirect ruleset below only fires for requests that actually
# reach Cloudflare.
resource "cloudflare_record" "redirect_cname" {
  for_each = { for pair in local.redirect_hosts : "${pair[0]}/${pair[1]}" => pair }
  zone_id  = data.cloudflare_zone.this[each.value[0]].id
  name     = each.value[1]
  type     = "CNAME"
  content  = var.primary_domain
  ttl      = 1
  proxied  = true
}

resource "cloudflare_ruleset" "redirect" {
  for_each = toset(var.redirect_domains)
  zone_id  = data.cloudflare_zone.this[each.key].id
  name     = "Redirect to ${var.primary_domain}"
  kind     = "zone"
  phase    = "http_request_dynamic_redirect"

  rules {
    ref        = "redirect_to_primary"
    expression = "true"
    action     = "redirect"
    action_parameters {
      from_value {
        status_code = var.redirect_status_code
        target_url {
          expression = "concat(\"https://${var.primary_domain}\", http.request.uri.path)"
        }
        preserve_query_string = true
      }
    }
  }

  depends_on = [cloudflare_record.redirect_cname]
}
