resource "helm_release" "cnpg_operator" {
  repository = "https://cloudnative-pg.github.io/charts"
  chart = "cloudnative-pg"
  namespace = "cnpg-system"
  create_namespace = true
  name = "cnpg"
}