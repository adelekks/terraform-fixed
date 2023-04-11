# Define SSH key pair for our instances
resource "aws_key_pair" "default" {
  key_name = "ken-mac"
  public_key = "${file("${var.key_path}")}"
}

# Define bitbucket-server inside the public subnet
resource "aws_instance" "bitbucket" {
   ami  = "${var.ami}"
   instance_type = "t2.medium"
#   instance_type = "t2.micro"
#   size           = 40
#   key_name = "Kenny-mac"
   key_name = "${aws_key_pair.default.id}"   
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgbitbucket.id}"]
   associate_public_ip_address = true
   source_dest_check = false

   connection {
     type        = "ssh"
     user        = "ec2-user"
     private_key = "${file("${var.key_path_priv}")}"
     host        = self.public_ip
#     host        = aws_instance.bitbucket.public_ip
   }

# copy Ansible Playbook to the server
   provisioner "file" {
     source      = "infra"
     destination = "/tmp/infra"
   }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
      "sudo yum -y install python-pip python-devel python",
      #"sudo pip install ansible==2.4.2",
      "sudo yum -y install ansible",
      "sudo ansible-playbook /tmp/infra/bitbucket.yml"
    ]
  }

   provisioner "remote-exec" {
     inline = [
       "sudo docker run -dit --restart unless-stopped bitbucket",
       "sudo docker ps -a"
     ]
   }

   tags = {
    Name = "bitbucket-server"
  }
}

# Define jenkins-server inside the public subnet
resource "aws_instance" "jenkins" {
   ami  = "${var.ami}"
   instance_type = "t2.medium"
#   size           = 40
#   instance_type = "t2.micro"
#   key_name = "Kenny-mac"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
   associate_public_ip_address = true
   source_dest_check = false

   connection {
     type        = "ssh"
     user        = "ec2-user"
     private_key = "${file("${var.key_path_priv}")}"
     host        = self.public_ip
    # host        = aws_instance.jenkins.public_ip
   }

# copy Ansible Playbook to the server
   provisioner "file" {
     source      = "infra"
     destination = "/tmp/infra"
   }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
      "sudo yum -y install python-pip python-devel python",
    #  "sudo pip install ansible==2.4.2",
      "sudo yum -y install ansible",
      "sudo ansible-playbook /tmp/infra/jenkins.yml"
    ]
  }

   provisioner "remote-exec" {
     inline = [
       "sudo docker ps -a"
     ]
   }

   provisioner "local-exec" {
     command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${var.key_path_priv} ec2-user@${self.public_ip}:/tmp/infra/jenkins-pass ."
   }

   tags = {
    Name = "jenkins-server"
  }
}

# Define nexus-server inside the public subnet
resource "aws_instance" "nexus" {
   ami  = "${var.ami}"
   instance_type = "t2.medium"
#   size           = 40
#   instance_type = "t2.micro"
#   key_name = "Kenny-mac"
   key_name = "${aws_key_pair.default.id}"   
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgnexus.id}"]
   associate_public_ip_address = true
   source_dest_check = false

   connection {
     type        = "ssh"
     user        = "ec2-user"
     private_key = "${file("${var.key_path_priv}")}"
     host        = self.public_ip
    # host        = aws_instance.nexus.public_ip
   }

# copy Ansible Playbook to the server
   provisioner "file" {
     source      = "infra"
     destination = "/tmp/infra"
   }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm",
      "sudo yum -y install python-pip python-devel python",
      #"sudo pip install ansible==2.4.2",
      "sudo yum -y install ansible",
      "sudo ansible-playbook /tmp/infra/nexus.yml --extra-var host_ip=${self.public_ip}"
    ]
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${var.key_path_priv} ec2-user@${self.public_ip}:/tmp/infra/nexus-pass ."
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker run -dit --restart unless-stopped nexus",
      "sudo docker ps -a"
    ]
  }

  tags = {
   Name = "nexus-server"
  }
}
