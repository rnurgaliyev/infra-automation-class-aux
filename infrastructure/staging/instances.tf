################################################################################
### KEYSTONE
################################################################################
resource "openstack_compute_instance_v2" "keystone001" {
  name            = "${var.prefix}keystone001"
  image_id        = "${openstack_images_image_v2.bionic.id}"
  flavor_name     = "m1.micro"
  key_pair        = "${openstack_compute_keypair_v2.admin.name}"
  security_groups = ["${openstack_compute_secgroup_v2.full_access.name}"]

  network {
    uuid = "${openstack_networking_network_v2.staging.id}"
  }
}

resource "openstack_compute_floatingip_v2" "keystone001" {
  pool = "${data.openstack_networking_network_v2.ext_net.name}"
}

resource "openstack_compute_floatingip_associate_v2" "keystone001" {
  floating_ip = "${openstack_compute_floatingip_v2.keystone001.address}"
  instance_id = "${openstack_compute_instance_v2.keystone001.id}"
}

resource "google_dns_record_set" "keystone001" {
  name         = "keystone001.staging.${var.dns_subzone}.${data.google_dns_managed_zone.dns_zone.dns_name}"
  managed_zone = "${data.google_dns_managed_zone.dns_zone.name}"
  type         = "A"
  ttl          = 30

  rrdatas = ["${openstack_compute_floatingip_v2.keystone001.address}"]
}

################################################################################
### KEYSTONE DB
################################################################################
resource "openstack_compute_instance_v2" "keystone_db001" {
  name            = "${var.prefix}keystone-db001"
  image_id        = "${openstack_images_image_v2.bionic.id}"
  flavor_name     = "m1.micro"
  key_pair        = "${openstack_compute_keypair_v2.admin.name}"
  security_groups = ["${openstack_compute_secgroup_v2.full_access.name}"]

  network {
    uuid = "${openstack_networking_network_v2.staging.id}"
  }
}

resource "openstack_compute_floatingip_v2" "keystone_db001" {
  pool = "${data.openstack_networking_network_v2.ext_net.name}"
}

resource "openstack_compute_floatingip_associate_v2" "keystone_db001" {
  floating_ip = "${openstack_compute_floatingip_v2.keystone_db001.address}"
  instance_id = "${openstack_compute_instance_v2.keystone_db001.id}"
}

resource "google_dns_record_set" "keystone_db001" {
  name         = "keystone-db001.staging.${var.dns_subzone}.${data.google_dns_managed_zone.dns_zone.dns_name}"
  managed_zone = "${data.google_dns_managed_zone.dns_zone.name}"
  type         = "A"
  ttl          = 30

  rrdatas = ["${openstack_compute_floatingip_v2.keystone_db001.address}"]
}

################################################################################
### LOADBALANCER
################################################################################
resource "openstack_compute_instance_v2" "loadbalancer001" {
  name            = "${var.prefix}loadbalancer001"
  image_id        = "${openstack_images_image_v2.bionic.id}"
  flavor_name     = "m1.micro"
  key_pair        = "${openstack_compute_keypair_v2.admin.name}"
  security_groups = ["${openstack_compute_secgroup_v2.full_access.name}"]

  network {
    uuid = "${openstack_networking_network_v2.staging.id}"
  }
}

resource "openstack_compute_floatingip_v2" "loadbalancer001" {
  pool = "${data.openstack_networking_network_v2.ext_net.name}"
}

resource "openstack_compute_floatingip_associate_v2" "loadbalancer001" {
  floating_ip = "${openstack_compute_floatingip_v2.loadbalancer001.address}"
  instance_id = "${openstack_compute_instance_v2.loadbalancer001.id}"
}

resource "google_dns_record_set" "loadbalancer001" {
  name         = "loadbalancer001.staging.${var.dns_subzone}.${data.google_dns_managed_zone.dns_zone.dns_name}"
  managed_zone = "${data.google_dns_managed_zone.dns_zone.name}"
  type         = "A"
  ttl          = 30

  rrdatas = ["${openstack_compute_floatingip_v2.loadbalancer001.address}"]
}

resource "google_dns_record_set" "keystone" {
  name         = "keystone.staging.${var.dns_subzone}.${data.google_dns_managed_zone.dns_zone.dns_name}"
  managed_zone = "${data.google_dns_managed_zone.dns_zone.name}"
  type         = "A"
  ttl          = 30

  rrdatas = ["${openstack_compute_floatingip_v2.loadbalancer001.address}"]
}

resource "google_dns_record_set" "consul" {
  name         = "consul.staging.${var.dns_subzone}.${data.google_dns_managed_zone.dns_zone.dns_name}"
  managed_zone = "${data.google_dns_managed_zone.dns_zone.name}"
  type         = "A"
  ttl          = 30

  rrdatas = ["${openstack_compute_instance_v2.loadbalancer001.access_ip_v4}"]
}
