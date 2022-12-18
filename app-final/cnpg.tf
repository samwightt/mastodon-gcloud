resource "helm_release" "cnpg_operator" {
  repository = "https://cloudnative-pg.github.io/charts"
  chart = "cnpg"
  namespace = "cnpg-system"
  create_namespace = true
  name = "cnpg"
}