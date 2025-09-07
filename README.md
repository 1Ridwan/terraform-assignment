## Terraform WordPress – Modular VPC + EC2

This repo contains terraform code to provision a WordPress web server in a custom VPC using a modularised Terraform setup

---

## Features
- DRY approach; no hardcoded values
- Remote state stored in AWS S3
- Modules split for networking and app; inputs/outputs wired at the root
- Custom VPC with:
  - Internet Gateway (IGW) for outbound internet access
  - Public route table: routes 0.0.0.0/0 through the IGW, allowing internet access for public subnet
  - Security groups (principle of least privilege):
      - Inbound HTTP (80) open to all, so WordPress is accessible publicly
      - Inbound SSH (22) restricted to my IP only
      - Outbound traffic fully allowed, so instances can download packages and updates
- Use environment variables for sensitive credentials
- Outputs the public IP of the server

---

## Git Workflow

- Started with all infrastructure defined in the root module
- Created a dedicated feature branch (`modules`) to refactor into a modular design 
- Opened a pull request to review and merge the modularised infrastructure back into `main`

---

## Repo Structure
```

.
├─ modules/
│  ├─ networking/
│  │  ├─ main.tf
│  │  ├─ variables.tf
│  │  └─ outputs.tf
│  └─ wordpress/
│     ├─ main.tf
│     ├─ variables.tf
│     └─ outputs.tf
├─ main.tf            # Compose modules & wire inputs/outputs
├─ variables.tf       # Root variables
├─ outputs.tf         # Output key outputs (public IP of web server)
├─ provider.tf        # Providers + backend (S3 remote state)
├─ terraform.tfvars   # Env-specific values
├─ wordpress-site.sh  # User data for WordPress setup
└─ .gitignore

````

---

## Prerequisites
- Terraform (version 1.6.0 or higher, must be earlier version than 7.0.0)
- AWS account + credentials
- S3 bucket for state (update `provider.tf` backend)

---

## Quick Start
```bash
terraform init
terraform plan
terraform apply
````

**Outputs**

```bash
terraform output
# public_ip = "x.x.x.x"
```

Visit `http://<public_ip>`.

---

## Cleanup

```bash
terraform destroy
```

---

## What I Learned / Issues Faced

* Tried to call variables/resources from other modules directly; fixed by outputting from the source module and consuming at the root
* User data initially misconfigured → WordPress failed to load -> Resolved by aligning `DB_*` vars in user_data and .tfvars
* Many troubleshooting sessions were caused by clock skew; I resolved this by enabling NTP time sync so my system clock stayed aligned with AWS
