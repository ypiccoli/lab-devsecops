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
