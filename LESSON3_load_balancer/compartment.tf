resource "oci_identity_compartment" "FoggyKitchenCompartment" {
  name = var.NewCompartment
  description = var.NewCompartment
  compartment_id = var.compartment_ocid
}
