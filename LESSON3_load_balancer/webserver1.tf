resource "tls_private_key" "public_private_key_pair_1" {
    algorithm   = "RSA"
}

resource "oci_core_instance" "FoggyKitchenWebserver1" {
    availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[1], "name")
    compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
    display_name = "FoggyKitchenWebServer1"
    shape = var.Shapes
    subnet_id = oci_core_subnet.FoggyKitchenWebSubnet.id

    source_details {
        source_type = "image"
        source_id   = lookup(data.oci_core_images.OSImageLocal.images[0], "id")
    }

    metadata = {
        # public key used by the provisioner only + user provided public key:
        ssh_authorized_keys = "${tls_private_key.public_private_key_pair_1.public_key_openssh}${var.public_ssh_key}"
    }

    create_vnic_details {
        subnet_id = oci_core_subnet.FoggyKitchenWebSubnet.id
    }
}

data "oci_core_vnic_attachments" "FoggyKitchenWebserver1_VNIC1_attach" {
    availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[1], "name")
    compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
    instance_id = oci_core_instance.FoggyKitchenWebserver1.id
}

data "oci_core_vnic" "FoggyKitchenWebserver1_VNIC1" {
    vnic_id = data.oci_core_vnic_attachments.FoggyKitchenWebserver1_VNIC1_attach.vnic_attachments.0.vnic_id
}

output "FoggyKitchenWebserver1PublicIP" {
    value = [data.oci_core_vnic.FoggyKitchenWebserver1_VNIC1.public_ip_address]
}
