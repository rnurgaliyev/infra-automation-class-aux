resource "openstack_images_image_v2" "bionic" {
  name             = "${var.prefix}bionic"
  image_source_url = "https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img"
  container_format = "bare"
  disk_format      = "qcow2"
}

resource "openstack_compute_keypair_v2" "admin" {
  name       = "${var.prefix}admin"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLOH1KvssMlw6fMGO9XGfq+fiPjQkyBnXM5fVcBuHuAMRMxJNomdNpjps0gjypA3RNFgdoTi2fDSa7oG2k2fCLPCFbcXArOw7hgffHXaGlZmJzOxL8TtZrkwKo4z1UEunmaJ5gHAXTrl8KH+dmq0mrZYsit0SIouast5FDDF6kCASzgxr0Jz4gfwKBH03tBvDiSSpmMg1VgF6EFJwtGYk6JHt0lgYbj9RkBDhl3zyDL67YZuBfuCR5JXpAOKjXEtTZdfezFIqhH/iCCreDPct4I78p0sRUaduSmh/hL0UJ4tC2NoDuMfoIXJqwsFSRcgslh/UmQEY2TgoFcjKvS69Z"
}

resource "openstack_compute_keypair_v2" "cikey" {
  name       = "${var.prefix}cikey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC13dRSgKkcdnq6wcucW7QGyTMMxPh61Lm/LCxUjkpqyaI+5ltVz7V/aQjcVa/MH8SeTIlYz9H4BKe2VUaALKGVt6I8wKjTYSTO+nfkbppBpED7xmqFe7xx/Jxz1dKTK/vuTUbQk++v+UCpSJOMZuAGy2QWF7G9EXdORX/Qfyg4iFeegSfcPB9jTSeGLaoWVjHhWfvhIBN/IOyYxCqk8GwmjGyI9j7xVUaYbafvRjmKqMJxIaO4XtJn3jGiMW6+o07IkH9z7O9zU7WKP5HlspVfYzC6zP6PnksDxJ9F1E6GsuL88Lo15E9c1TZp2YOHOxxkrTTIvouqTT9RFI7HhoIJ"
}

data "openstack_networking_network_v2" "ext_net" {
  name     = "ext-net"
  external = true
}

resource "openstack_compute_secgroup_v2" "full_access" {
  name        = "${var.prefix}full_access"
  description = "Security Group for full access"

  # ICMP from all the world
  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }

  # All TCP from all over the world
  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "ssh_only" {
  name        = "${var.prefix}ssh_only"
  description = "Security Group for SSH only access"

  # SSH from all the world
  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  # ICMP from all the world
  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }
}
