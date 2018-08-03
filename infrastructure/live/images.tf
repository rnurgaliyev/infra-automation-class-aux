data "openstack_images_image_v2" "loadbalancer" {
  name = "loadbalancer"
  most_recent = true
}

data "openstack_images_image_v2" "keystone" {
  name = "keystone"
  most_recent = true
}

data "openstack_images_image_v2" "keystone-db" {
  name = "keystone-db"
  most_recent = true
}
