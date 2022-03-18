## Installation

Install Terraform on Windows with choco

```
choco install terraform
```

Install Terraform on MacOS

```
brew install terraform
```

```
choco install graphviz
```

```
terraform graph | dot -Tsvg > graph.svg
```

## Terraform Commands

- terraform init : initialize your code to download the requirements mentioned in your code.
- terraform plan : review changes and choose whether to simply accept them.
- terraform apply : accept changes and apply them against real infrastructure.
- terraform show
- terraform destroy : destroy all your created infrastructure.
