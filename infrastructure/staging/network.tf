################################################################################
### STAGING NETWORK
################################################################################
resource "openstack_networking_network_v2" "staging" {
  name           = "${var.prefix}staging"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "staging" {
  name            = "${var.prefix}staging"
  network_id      = "${openstack_networking_network_v2.staging.id}"
  cidr            = "10.255.255.0/24"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

resource "openstack_networking_router_v2" "staging" {
  name                = "${var.prefix}staging"
  admin_state_up      = true
  external_network_id = "${data.openstack_networking_network_v2.ext_net.id}"
}

resource "openstack_networking_router_interface_v2" "staging" {
  router_id = "${openstack_networking_router_v2.staging.id}"
  subnet_id = "${openstack_networking_subnet_v2.staging.id}"
}
