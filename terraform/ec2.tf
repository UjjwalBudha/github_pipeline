module "ec2" {
  for_each                    = var.name
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "5.5.0"
  instance_type               = var.instance_type
  ami                         = var.ami_id
  monitoring                  = var.monitoring
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = var.sg_id
  subnet_id                   = var.subnet_id # public subnet
  iam_instance_profile        = "intern-ujwal"
  key_name                    = try(var.key_name, null)
  tags = {
    Name = each.value
  }
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = "test-intern-github-action"
}

resource "aws_s3_object" "file_upload" {
  bucket = module.s3_bucket.s3_bucket_id
  key    = "index.html"
  source = "../code/index.html"
}