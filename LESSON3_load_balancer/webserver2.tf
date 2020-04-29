resource "tls_private_key" "public_private_key_pair_2" {
    algorithm   = "RSA"
}

resource "oci_core_instance" "FoggyKitchenWebserver2" {
    availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[2], "name")
    compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
    display_name = "FoggyKitchenWebServer2"
    shape = var.Shapes[0]
    subnet_id = oci_core_subnet.FoggyKitchenWebSubnet.id
    source_details {
        source_type = "image"
        source_id   = lookup(data.oci_core_images.OSImageLocal.images[0], "id")
    }
    
    /*
    metadata = {
        ssh_authorized_keys = file(var.public_key_oci)
    }
    */

    extended_metadata {
        ssh_authorized_keys = tls_private_key.public_private_key_pair_2.public_key_openssh
    }

    create_vnic_details {
        subnet_id = oci_core_subnet.FoggyKitchenWebSubnet.id
    }
}

data "oci_core_vnic_attachments" "FoggyKitchenWebserver2_VNIC1_attach" {
    availability_domain = lookup(data.oci_identity_availability_domains.ADs.availability_domains[2], "name")
    compartment_id = oci_identity_compartment.FoggyKitchenCompartment.id
    instance_id = oci_core_instance.FoggyKitchenWebserver2.id
}

data "oci_core_vnic" "FoggyKitchenWebserver2_VNIC1" {
    vnic_id = data.oci_core_vnic_attachments.FoggyKitchenWebserver2_VNIC1_attach.vnic_attachments.0.vnic_id
}

output "FoggyKitchenWebserver2PublicIP" {
     value = [data.oci_core_vnic.FoggyKitchenWebserver2_VNIC1.public_ip_address]
}
