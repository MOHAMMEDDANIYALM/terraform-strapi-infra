# Terraform Strapi Infrastructure

A modular Terraform configuration to provision AWS EC2 infrastructure for Strapi CMS deployment on Ubuntu 22.04.

## 📋 Overview

This project uses Terraform modules to create and manage AWS cloud infrastructure including:
- **EC2 Instance** - Ubuntu 22.04 server for Strapi
- **Key Pair** - SSH key for secure instance access
- **Security Group** - Network access control (ports 22, 1337)

## 🏗️ Project Structure

```
strapi-infra/
├── modules/                      # Reusable Terraform modules
│   ├── ec2/                      # EC2 instance module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── keypair/                  # SSH key pair module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── security-group/           # Security group module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/
│   └── dev/                      # Development environment
│       ├── main.tf               # Root module configuration
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars      # Environment variables (not in git)
├── versions.tf                   # Terraform version & provider requirements
├── .gitignore
└── README.md
```

## 🔧 Prerequisites

- **Terraform** >= 1.5.0
- **AWS Account** with appropriate IAM permissions
- **AWS CLI** configured with credentials
- **Local SSH tools** (for using the generated key pair)

## 📦 AWS Providers Required

- `hashicorp/aws` ~> 5.0
- `hashicorp/tls` ~> 4.0
- `hashicorp/local` ~> 2.0

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/MOHAMMEDDANIYALM/terraform-strapi-infra.git
cd strapi-infra/environments/dev
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Configure Variables

Edit `terraform.tfvars`:

```hcl
region        = "ap-south-1"
instance_type = "t3.small"
key_name      = "strapi-dev-key"
vpc_id        = "vpc-xxxxxxxx"  # Replace with your VPC ID
```

**To find your VPC ID:**

```bash
aws ec2 describe-vpcs --query "Vpcs[*].[VpcId,Tags[?Key=='Name'].Value|[0]]" --output table
```

### 4. Review the Plan

```bash
terraform plan
```

### 5. Apply Configuration

```bash
terraform apply
```

### 6. Get Outputs

```bash
terraform output
```

## 📝 Variables

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| `region` | string | `ap-south-1` | No | AWS region |
| `vpc_id` | string | - | Yes | VPC ID for security group |
| `instance_type` | string | `t3.small` | No | EC2 instance type |
| `key_name` | string | - | Yes | SSH key pair name |

## 📤 Outputs

| Name | Description |
|------|-------------|
| `ec2_public_ip` | Public IP address of EC2 instance |
| `key_file_path` | Path to generated .pem private key file |

## 🔐 Security Groups

### Ingress Rules
- **Port 22 (SSH)** - From 0.0.0.0/0 (Restrict this in production)
- **Port 1337 (Strapi)** - From 0.0.0.0/0

### Egress Rules
- **All traffic** - To 0.0.0.0/0

## 🔑 SSH Key Management

The SSH private key is automatically generated and saved as:
```
environments/dev/strapi-dev-key.pem
```

Set proper permissions:
```bash
chmod 400 environments/dev/strapi-dev-key.pem
```

Connect to instance:
```bash
ssh -i environments/dev/strapi-dev-key.pem ubuntu@<PUBLIC_IP>
```

## 📊 Module Details

### ec2 Module
Creates an EC2 instance with user data for basic setup (Node.js, Yarn, Git).

**Inputs:**
- `ami` - AMI ID
- `instance_type` - Instance type
- `key_name` - SSH key pair name
- `security_group_id` - Security group ID

**Outputs:**
- `public_ip` - Public IP address
- `instance_id` - Instance ID

### keypair Module
Generates an RSA key pair and stores the private key locally.

**Inputs:**
- `key_name` - Name for the key pair

**Outputs:**
- `key_name` - Key pair name
- `pem_file_path` - Path to PEM file

### security-group Module
Creates a security group with ingress/egress rules.

**Inputs:**
- `vpc_id` - VPC ID

**Outputs:**
- `id` - Security group ID

## 🛠️ Common Commands

```bash
# Initialize working directory
terraform init

# Validate syntax
terraform validate

# Format files
terraform fmt -recursive

# Preview changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure
terraform destroy

# Show outputs
terraform output

# Show specific resource
terraform show module.ec2.aws_instance.this
```

## 📋 Git Workflow

Files excluded from git (see `.gitignore`):
- `.terraform/` - Provider binaries
- `*.tfstate` - State files
- `*.pem` - Private keys
- `*.tfvars` - Sensitive variables

Push only code and documentation:
```bash
git add .
git commit -m "Your message"
git push origin main
```

## ⚠️ Important Notes

1. **VPC ID is Required** - Update `terraform.tfvars` with your VPC ID before applying
2. **SSH Key Storage** - Keep `.pem` files secure and never commit to git
3. **State Management** - Consider using remote state (S3 + DynamoDB) for production
4. **Security** - Restrict security group ingress rules to specific IPs in production
5. **Costs** - Monitor AWS costs; t3.small instances have associated charges

## 📚 Resources

- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Strapi Documentation](https://docs.strapi.io/)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)

## 📄 License

This project is open source and available under the MIT License.

## 👤 Author

**Mohammed Daniyalm** ⭐

- GitHub: [@MOHAMMEDDANIYALM](https://github.com/MOHAMMEDDANIYALM)
- Repository: [terraform-strapi-infra](https://github.com/MOHAMMEDDANIYALM/terraform-strapi-infra)
- Email: Connect on GitHub

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## ❓ Troubleshooting

### Error: Invalid VPC ID
```
Error: creating Security Group: operation error EC2: CreateSecurityGroup...
```
**Solution:** Update `vpc_id` in `terraform.tfvars` with a valid VPC ID from your AWS account.

### Error: Key pair already exists
```
Error: creating Key Pair: InvalidKeyPair.Duplicate
```
**Solution:** Change `key_name` in `terraform.tfvars` to a unique value or delete the existing key pair from AWS.

### Error: Terraform version mismatch
Ensure you're running Terraform >= 1.5.0:
```bash
terraform version
```

---

**Last Updated:** February 4, 2026
