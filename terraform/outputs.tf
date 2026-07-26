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
output "vcn_id" {
  description = "OCID da VCN do lab"
  value       = oci_core_vcn.lab.id
}

output "subnet_public_id" {
  description = "OCID da subnet publica (usado na criacao da VM)"
  value       = oci_core_subnet.public.id
}

output "vcn_cidr" {
  description = "CIDR da VCN"
  value       = var.vcn_cidr
}

output "public_ip" {
  description = "IP publico da VM do lab"
  value       = oci_core_instance.lab.public_ip
}

output "ssh_command" {
  description = "Comando pronto para conectar na VM"
  value       = "ssh -i ~/.ssh/lab_devsecops ubuntu@${oci_core_instance.lab.public_ip}"
}
