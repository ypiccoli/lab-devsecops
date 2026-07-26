# Consulta os availability domains da região.
# Data source de leitura, não cria nada e não gera custo.
# Serve para validar que a autenticação está funcionando de ponta a ponta.
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Confirma que o compartment do lab existe e está acessível.
data "oci_identity_compartment" "lab" {
  id = var.compartment_ocid
}
