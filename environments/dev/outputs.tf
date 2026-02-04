output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "key_file_path" {
  value = module.keypair.pem_file_path
}
