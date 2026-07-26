# ---------------------------------------------------------------------------
# Busca a imagem Ubuntu mais recente compativel com a shape ARM.
# Data source em vez de OCID fixo: OCID de imagem muda a cada release
# e varia por regiao. Hardcode quebra em poucos meses.
# ---------------------------------------------------------------------------
data "oci_core_images" "ubuntu_arm" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04"
  shape                    = var.instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# ---------------------------------------------------------------------------
# VM Ampere A1 (ARM). Flex shape: OCPU e memoria configuraveis.
# ---------------------------------------------------------------------------
resource "oci_core_instance" "lab" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name        = "vm-lab-devsecops"
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_memory_gb
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu_arm.images[0].id
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.public.id
    assign_public_ip = true
    hostname_label   = "vmlab"
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
  }

  # O IP publico so muda se a VM for recriada.
  # Evita destruicao acidental por mudanca de imagem upstream.
  lifecycle {
    ignore_changes = [source_details[0].source_id]
  }
}