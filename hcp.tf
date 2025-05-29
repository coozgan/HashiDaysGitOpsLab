data "aws_region" "current" { }

data "hcp_packer_version" "ami" {
  bucket_name  = var.hcp_packer_bucket_name
  channel_name = "production"
}

data "hcp_packer_artifact" "ami" {
  bucket_name         = var.hcp_packer_bucket_name
  version_fingerprint = data.hcp_packer_version.ami.fingerprint
  platform            = "aws"
  region              = data.aws_region.current.name
}