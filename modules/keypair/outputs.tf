output "key_name" {
  value = aws_key_pair.this.key_name
}

output "pem_file_path" {
  value = local_file.pem.filename
}
