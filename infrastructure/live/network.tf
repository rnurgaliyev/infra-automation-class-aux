################################################################################
### LIVE NETWORK
################################################################################
resource "openstack_networking_network_v2" "live" {
  name           = "${var.prefix}live"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "live" {
  name            = "${var.prefix}live"
  network_id      = "${openstack_networking_network_v2.live.id}"
  cidr            = "10.255.254.0/24"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

resource "openstack_networking_router_v2" "live" {
  name                = "${var.prefix}live"
  admin_state_up      = true
  external_network_id = "${data.openstack_networking_network_v2.ext_net.id}"
}

resource "openstack_networking_router_interface_v2" "live" {
  router_id = "${openstack_networking_router_v2.live.id}"
  subnet_id = "${openstack_networking_subnet_v2.live.id}"
}
