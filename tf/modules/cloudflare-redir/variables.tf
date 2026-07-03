variable "primary_domain" {
  description = "The domain that gets the real A record (all other domains redirect to it)."
  type        = string
}

variable "primary_record_values" {
  description = "IPv4 addresses the primary domain's apex A records should point to."
  type        = list(string)
}

variable "primary_record_proxied" {
  description = "Whether the primary A record is proxied through Cloudflare."
  type        = bool
  default     = true
}

variable "mx_records" {
  description = "MX records created at the apex of every domain (primary and redirect)."
  type = list(object({
    priority = number
    content  = string
  }))
  default = []
}

variable "spf_includes" {
  description = "SPF 'include' mechanisms merged into one SPF TXT record at the apex of every domain."
  type        = list(string)
  default     = []
}

variable "redirect_domains" {
  description = "Domain names that should redirect to var.primary_domain instead of hosting content."
  type        = list(string)
}

variable "redirect_status_code" {
  description = "HTTP status code used by the redirect rules."
  type        = number
  default     = 301
}
