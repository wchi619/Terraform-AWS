#Create ELB
resource "aws_elb" "elb" {
  name 			  = "ELB-Final"
  subnets 		  = [aws_subnet.public.*.id]
  security_groups = [aws_security_group.elb.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "HTTP:80/index.html"
    interval            = 30
  }

  instances                   = [element(aws_instance.webservers.*.id, 0), element(aws_instance.webservers.*.id, 1)]
  cross_zone_load_balancing   = true
  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 300

  tags = {
    Name = "ELB-Final"
  }
}

#Output ELB DNS Name
output "elb-dns-name" {
  value = "${aws_elb.vpc-final.dns_name}"
}