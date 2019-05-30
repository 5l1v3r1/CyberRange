locals {
  pen_subnet_ids = [
    "${var.attacker_subnet_id}",
    "${var.target_subnet_id}",
  ]
}

resource "aws_instance" "kali" {
  count = "${var.kali_ct}"
  ami = "${data.aws_ami.kali.id}"
  instance_type = "${var.instance_type_kali}"
  subnet_id              = "${element(local.pen_subnet_ids, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.kali.id}"]
  key_name = "${aws_key_pair.circleci_key.key_name}"
  user_data = "${file("../../modules/infrastructure/cloud-init/kali.yml")}"

  root_block_device {
    delete_on_termination = true
    volume_size           = 120
  }

  tags = {
    Name        = "CyberRange-kali-linux-${count.index}"
    Environment = "${var.environment}"
    Terraform   = "True"
  }
}

resource "aws_instance" "pT10_commando" {
  count = "${var.docker_ct}"
  ami = "${data.aws_ami.commando.id}"
  instance_type = "${var.instance_type_win}"
  subnet_id              = "${element(local.pen_subnet_ids, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.kali.id}"]
  key_name = "${aws_key_pair.circleci_key.key_name}"
  user_data               = "${file("../../modules/infrastructure/cloud-init/bootstrap.commando.yml")}"
  root_block_device {
    delete_on_termination = true
    volume_size           = 150
  }
  tags = {
    Name        = "CyberRange-commando-pT16-${count.index}"
    Environment = "${var.environment}"
    Terraform   = "True"
  }
}

resource "aws_instance" "r7vm" {
  count = "${var.kali_ct}"

  ami = "${data.aws_ami.r7.id}"
  instance_type = "${var.instance_type_kali}"

  subnet_id              = "${element(local.pen_subnet_ids, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.kali.id}"]

  key_name = "${aws_key_pair.circleci_key.key_name}"

  user_data = "${file("../../modules/infrastructure/cloud-init/kali.yml")}"

  root_block_device {
    delete_on_termination = true
    volume_size           = 120
  }

  tags = {
    Name        = "CyberRange-r7-${count.index}"
    Environment = "${var.environment}"
    Terraform   = "True"
  }
}