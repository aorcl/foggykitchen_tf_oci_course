resource "oci_core_dhcp_options" "FoggyKitchenDhcpOptions3" {
  provider  = oci.acceptor
  compartment_id = oci_identity_compartment.ExternalCompartment.id
  vcn_id = oci_core_virtual_network.FoggyKitchenSpokeVCN3.id
  display_name = "FoggyKitchenDHCPOptions3"

  // required
  options {
    type = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  // optional
  options {
    type = "SearchDomain"
    search_domain_names = [ "foggykitchen.com" ]
  }
}

resource "oci_core_dhcp_options" "FoggyKitchenDhcpOptions4" {
  provider  = oci.acceptor
  compartment_id = oci_identity_compartment.ExternalCompartment.id
  vcn_id = oci_core_virtual_network.FoggyKitchenSpokeVCN4.id
  display_name = "FoggyKitchenDHCPOptions4"

  // required
  options {
    type = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  // optional
  options {
    type = "SearchDomain"
    search_domain_names = [ "foggykitchen.com" ]
  }
}