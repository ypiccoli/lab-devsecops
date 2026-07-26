variable "tenancy_ocid" {
  description = "OCID do tenancy"
  type        = string
}

variable "user_ocid" {
  description = "OCID do usuário dono da API key"
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint da API key cadastrada na OCI"
  type        = string
}

variable "private_key_path" {
  description = "Caminho absoluto da chave privada"
  type        = string
  default     = "/home/ypiccoli/.oci/oci_api_key.pem"
}

variable "region" {
  description = "Região da OCI"
  type        = string
}

variable "compartment_ocid" {
  description = "OCID do compartment onde os recursos serão criados"
  type        = string
}

variable "vcn_cidr" {
  description = "CIDR da VCN"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_public_cidr" {
  description = "CIDR da subnet publica"
  type        = string
  default     = "10.0.1.0/24"
}

variable "ssh_allowed_cidr" {
  description = "Origem permitida para SSH (22/tcp). Use seu IP publico com /32."
  type        = string
}

variable "api_allowed_cidr" {
  description = "Origem permitida para a API Flask (5000/tcp)"
  type        = string
}
