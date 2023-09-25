# Blocks

Blocks is an Infrastructure as Code repository supporting the core application serving goodcodefriends.com

## Usage
Depending on which IaC language you wish to use, deployment may vary

### Terraform
Navigate to the desired env directory under `/env` and run the following for the desired module
```
terraform init
terraform plan -target=module.<MODULE_NAME>
terraform apply -target=module.<MODULE_NAME>
```

### Cloudformation
Current Cloudformation deployment method requires console login and manual template upload.
However, linting can be done locally using `cfn-lint`

## Contributing
Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
Apache 2 Licensed. See LICENSE for full details.
