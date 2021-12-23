locals {
  # GitHub Pages IP
  # https://docs.github.com/ja/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site
  gh_pages_ips = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153",
  ]
}

resource "cloudflare_record" "github_verify" {
  zone_id = data.cloudflare_zone.yohanesu.id
  name    = "_github-challenge-yohane-su"
  type    = "TXT"
  value   = "ea580f48b7"
}

resource "cloudflare_record" "minecraft" {
  zone_id         = data.cloudflare_zone.yohanesu.id
  name            = "mc"
  type            = "A"
  value           = "45.76.188.189"
  allow_overwrite = true
}

resource "cloudflare_record" "minecraft2" {
  zone_id         = data.cloudflare_zone.yohanesu.id
  name            = "mc2"
  type            = "A"
  value           = oci_core_instance.a1flex_instance01.public_ip
  allow_overwrite = true
}

resource "cloudflare_record" "gh_pages" {
  zone_id         = data.cloudflare_zone.yohanesu.id
  name            = "yohane.su"
  type            = "A"
  proxied         = true
  allow_overwrite = true

  for_each = toset(local.gh_pages_ips)
  value    = each.value
}
