resource "openstack_compute_instance_v2" "keystone" {
  name            = "${var.prefix}keystone00${count.index+1}"
  count           = 1
  image_id        = "${data.openstack_images_image_v2.keystone.id}"
  flavor_name     = "m1.micro"
  key_pair        = "${openstack_compute_keypair_v2.live_admin.name}"
  security_groups = ["${openstack_compute_secgroup_v2.live_access.name}"]

  network {
    uuid = "${openstack_networking_network_v2.live.id}"
  }
}

resource "openstack_compute_instance_v2" "keystone-db" {
  name            = "${var.prefix}keystone-db001"
  image_id        = "${data.openstack_images_image_v2.keystone-db.id}"
  flavor_name     = "m1.micro"
  key_pair        = "${openstack_compute_keypair_v2.live_admin.name}"
  security_groups = ["${openstack_compute_secgroup_v2.live_access.name}"]

  network {
    uuid = "${openstack_networking_network_v2.live.id}"
  }
}

resource "openstack_compute_instance_v2" "loadbalancer" {
  name            = "${var.prefix}loadbalancer001"
  image_id        = "${data.openstack_images_image_v2.loadbalancer.id}"
  flavor_name     = "m1.micro"
  key_pair        = "${openstack_compute_keypair_v2.live_admin.name}"
  security_groups = ["${openstack_compute_secgroup_v2.live_access.name}"]

  network {
    uuid = "${openstack_networking_network_v2.live.id}"
  }
}

resource "openstack_compute_floatingip_v2" "loadbalancer" {
  pool = "${data.openstack_networking_network_v2.ext_net.name}"
}

resource "openstack_compute_floatingip_associate_v2" "loadbalancer" {
  floating_ip = "${openstack_compute_floatingip_v2.loadbalancer.address}"
  instance_id = "${openstack_compute_instance_v2.loadbalancer.id}"
}

resource "google_dns_record_set" "keystone" {
  name         = "keystone.live.${var.dns_subzone}.${data.google_dns_managed_zone.dns_zone.dns_name}"
  managed_zone = "${data.google_dns_managed_zone.dns_zone.name}"
  type         = "A"
  ttl          = 30

  rrdatas = ["${openstack_compute_floatingip_v2.loadbalancer.address}"]
}

resource "google_dns_record_set" "consul" {
  name         = "consul.live.${var.dns_subzone}.${data.google_dns_managed_zone.dns_zone.dns_name}"
  managed_zone = "${data.google_dns_managed_zone.dns_zone.name}"
  type         = "A"
  ttl          = 30

  rrdatas = ["${openstack_compute_instance_v2.loadbalancer.access_ip_v4}"]
}
