output "availability_domains" {
  description = "Availability domains disponíveis na região configurada"
  value       = data.oci_identity_availability_domains.ads.availability_domains[*].name
}

output "compartment_name" {
  description = "Nome do compartment alvo do lab"
  value       = data.oci_identity_compartment.lab.name
}

output "region" {
  description = "Região configurada"
  value       = var.region
}