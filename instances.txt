resource "aws_instance" "webservers" {
  count           = length(var.subnets_private)
  ami             = lookup(var.ami,var.aws_region)
  instance_type   = var.instance_type
  security_groups = [aws_security_group.webservers.id]
  subnet_id       = element(aws_subnet.private.*.id,count.index)
  key_name        = var.aws_key_name
  user_data       = <<-EOF
                        #!/bin/bash
                        yum install -y httpd
                        chkconfig httpd on
                        service httpd start
                        echo "<h1>MAP603 Final Exam - William Chi</h1>" | tee /var/www/html/index.html
                        EOF
  tags = {
      Name = "WS-Server-${count.index+1}"
  }
}
