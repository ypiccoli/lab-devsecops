# ---------------------------------------------------------------------------
# VCN: a rede virtual isolada do lab.
# Equivalente ao VPC da AWS. Tudo abaixo vive dentro dela.
# ---------------------------------------------------------------------------
resource "oci_core_vcn" "lab" {
  compartment_id = var.compartment_ocid
  cidr_blocks    = [var.vcn_cidr]
  display_name   = "vcn-lab-devsecops"
  dns_label      = "labdevsecops"
}

# ---------------------------------------------------------------------------
# Internet Gateway: porta de saida da VCN para a internet.
# Sem ele nao ha rota publica, mesmo com IP publico na VM.
# ---------------------------------------------------------------------------
resource "oci_core_internet_gateway" "lab" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.lab.id
  display_name   = "igw-lab-devsecops"
  enabled        = true
}

# ---------------------------------------------------------------------------
# Route table: rota default apontando para o internet gateway.
# ---------------------------------------------------------------------------
resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.lab.id
  display_name   = "rt-public-lab"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.lab.id
  }
}

# ---------------------------------------------------------------------------
# Security list: firewall stateful no nivel da subnet.
# Ingress restrito a origem conhecida, egress liberado.
# ---------------------------------------------------------------------------
resource "oci_core_security_list" "public" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.lab.id
  display_name   = "sl-public-lab"

  # Saida liberada (necessario para apt, docker pull, etc)
  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  # SSH
  ingress_security_rules {
    protocol    = "6" # 6 = TCP
    source      = var.ssh_allowed_cidr
    source_type = "CIDR_BLOCK"
    description = "SSH restrito a origem conhecida"

    tcp_options {
      min = 22
      max = 22
    }
  }

  # API Flask
  ingress_security_rules {
    protocol    = "6"
    source      = var.api_allowed_cidr
    source_type = "CIDR_BLOCK"
    description = "API Flask do lab"

    tcp_options {
      min = 5000
      max = 5000
    }
  }

  # ICMP tipo 3 codigo 4: Path MTU Discovery.
  # Sem esta regra conexoes travam de forma intermitente e dificil de diagnosticar.
  ingress_security_rules {
    protocol    = "1" # 1 = ICMP
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Path MTU Discovery"

    icmp_options {
      type = 3
      code = 4
    }
  }
}

# ---------------------------------------------------------------------------
# Subnet publica: onde a VM da tarefa 16 vai nascer.
# ---------------------------------------------------------------------------
resource "oci_core_subnet" "public" {
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.lab.id
  cidr_block                 = var.subnet_public_cidr
  display_name               = "subnet-public-lab"
  dns_label                  = "public"
  route_table_id             = oci_core_route_table.public.id
  security_list_ids          = [oci_core_security_list.public.id]
  prohibit_public_ip_on_vnic = false
}
