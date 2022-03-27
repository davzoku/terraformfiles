# Terraform

Terraform is an IaC tool that allows users to provision immutable infrastructure using human-readable and declarative files.

A Terraform configuration is idempotent, means applying it multiple times will not change the result.

Terraform is available for macOS, FreeBSD, OpenBSD, Linux, Solaris, Windows.

Most Terraform configurations are written in the native Terraform language syntax. Terraform also supports an alternative syntax that is JSON-compatible. This syntax is useful when generating portions of a configuration programmatically, since existing JSON libraries can be used to prepare the generated configuration files. Terraform expects native syntax for files named with a `.tf` suffix, and JSON syntax for files named with a `.tf.json` suffix.

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

To show terraform dependency graph

```
terraform graph | dot -Tsvg > graph.svg
```

## Terraform Commands

**Initializing**

- terraform init : initialize your code to download the requirements mentioned in your code. Rerun init whenever a new plugin is introduced
- terraform get: download and update modules mentioned in the root module.

**Provisioing**

- `terraform plan` : review changes and choose whether to simply accept them.
- `terraform apply` : accept changes and apply them against real infrastructure.
- `terraform destroy` : destroy all your created infrastructure.

**Writing and Modifying Code**

- `terraform console`: provides an interactive console for evaluating expressions
- `terraform fmt`: format config files to a canonical format and style
- `terraform validate`: validates the configuration files in a directory, referring only to the configuration and not accessing any remote services

**Inspecting**

- `terraform graph` : generate a visual representation of either a configuration or execution plan in the DOT format
- `terraform output`: extract the value of an output variable from the state file.
- `terraform show`: provide human-readable output from a state or plan file
- `terraform state show`: show the attributes of a single resource in the Terraform state.
- `terraform state list`: list resources within a Terraform state.

**Importing**

- `terraform import`: import existing resources into Terraform state management

**Forcing Re-creation**

- `terraform taint`: informs Terraform that a particular object has become degraded or damaged.

**Managing Workspaces**
see [Workspaces](#workspaces)

### Terraform Apply

The terraform apply -refresh-only command is used to reconcile the state Terraform knows about (via its state file) with the real-world infrastructure. This can be used to detect any drift from the last-known state, and to **update the state file**.

### Terraform Taint and Replace

HashiCorp deprecated the terraform taint command in v0.15.2. If you want to force replacement of an object even though there are no configuration changes, use the terraform plan or terraform apply command with the -replace option instead. If you are using an older version of Terraform, continue using the terraform taint command.

```
terraform apply -replace=<RESOURCE_NAME>
```

You could also use terraform destroy -target <virtual machine> and destroy only the virtual machine and then run a terraform apply again.

---

[Provisioners | Terraform by HashiCorp](https://www.terraform.io/language/resources/provisioners/syntax#creation-time-provisioners)

If a resource is successfully created but fails during provisioning, Terraform will error and mark the resource as "tainted". A resource that is tainted has been physically created, but can't be considered safe to use since provisioning failed.

Terraform also does not automatically roll back and destroy the resource during the apply when the failure happens because that would go against the execution plan: the execution plan would've said a resource will be created but does not say it will ever be deleted.

### Terraform Console

The `terraform console` command provides an interactive console for evaluating expressions.

#### Scripting

The terraform console command can be used in non-interactive scripts by piping newline-separated commands to it. Only the output from the final command is printed unless an error occurs earlier.

```bash
echo 'aws_iam_user.cloud[6].name' | terraform console
```

## Mutable vs Immutable Infrastructure

- Terraform uses immutable infrastructure approach, meaning when terraform detect there is a change in state, instead of updating existing resources, they are destroyed and recreated.

- The downside of mutable infrastructure approach is that, it introduce risk and complexity into the upgrading process. Suppose we want to update multiple existing server, however, they are on different old versions, or they simply don't meet the upgrade requirements. Immutable approach eliminate this risk.

- However, the key to making immutable infrastructure approach is to externalize the data, so that data is not destroyed along with the old infrastructure during the upgrading process.

## Terraform State

Terraform must store state about your managed infrastructure and configuration. This state is used by Terraform to map real world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures.

This state is stored by default in a local file named "terraform.tfstate", but it can also be stored remotely, which works better in a team environment.

## Blocks

A block is a container for other content. Examples of blocks include:

- resource
- module
- variable
- module

## Variables

## Environment Variables

[Environment Variables | Terraform by HashiCorp](https://www.terraform.io/cli/config/environment-variables#environment-variables)

We can use Terraform environment variables to change some of Terraform's default behaviors in unusual situations, or to increase output verbosity for debugging.

- TF_LOG: enable detailed logs
- TF_LOG_PATH: write logs to external file
- TF_INPUT
- TF_VAR_name: set environment variables such as `TF_VAR_region=us-west-1`
- TF_CLI_ARGS and TF_CLI_ARGS_name
- TF_DATA_DIR
- TF_WORKSPACE
- TF_IN_AUTOMATION
- TF_REGISTRY_DISCOVERY_RETRY
- TF_REGISTRY_CLIENT_TIMEOUT
- TF_CLI_CONFIG_FILE
- TF_IGNORE

### Variable Definition Precedence

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:

- Environment variables
- The terraform.tfvars file, if present.
- The terraform.tfvars.json file, if present.
- Any _.auto.tfvars or _.auto.tfvars.json files, processed in lexical order of their filenames.
- Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.) (highest priority)

## Meta-Arguments

Meta-Arguments are special constructs in Terraform which are available for Resource and Module Block.

Examples of meta-arguments include:

- `depends_on` (for explictly declaring dependencies, see resource-dependencies folder)
- `count` (for ceating multiple resources with the same config)
- `for_each` (alternative way to create multiple resources, uses map or set(string))
- `provider` (specifies provider to be used for a resource, can include alias to differentiate providers)
- `lifecycle` (allows customization to the default terraform lifecycle like ignore_changes or create_before_destroy, prevent_destroy)

## Providers

![Terraform Registry](terraform-registry.png)

Providers allow Terraform to interact with cloud providers, SaaS providers, and other APIs. [Terraform Registry](https://registry.terraform.io/) makes it easy for users to browse the list of available providers and add to their configuration to use. Terraform providers can be differentiated into official, verified and community providers depending on the author of the plugin.

- we can use `alias` meta-argument to identify multiple configurations for the same provider.

```
# The default provider configuration; resources that begin with `aws_` will use
# it as the default, and it can be referenced as `aws`.
provider "aws" {
  region = "us-east-1"
}

# Additional provider configuration for west coast region; resources can
# reference this as `aws.west`.
provider "aws" {
  alias  = "west"
  region = "us-west-2"
}
```

- we can use `version` in `required_providers` block to explictly declare a version constraint for a provider.

```
terraform {
  required_providers {
    mycloud = {
      source  = "mycorp/mycloud"
      version = "~> 1.0"
    }
  }
}
```

After running `terraform init`, the provider plugins are downloaded and stored in the `.terraform/providers` directory in the current working directory.

### Publishing Modules

Anyone can publish and share modules on the Terraform Registry.

The requirements for publishing a module is as follows:

- The module must be on GitHub and must be a public repo for public registry.
- Named terraform-<PROVIDER>-<NAME>. Module repositories must use this three-part name format
- The GitHub repository description is used to populate the short description of the module.
- Standard module structure. The module must adhere to the standard module structure. This allows the registry to inspect your module and generate documentation, track resource usage, parse submodules and examples, and more.
- x.y.z tags for releases. The registry uses tags to identify module versions. Release tag names must be a semantic version, which can optionally be prefixed with a v.

## Data Sources

Data sources allow Terraform to use information _defined outside of Terraform_, defined by another separate Terraform configuration, or modified by functions.

It is important to consider that Terraform reads from data sources during the plan phase and writes the result into the plan.

## Workspaces

Terraform starts with a single workspace named "default".

Named workspaces allow conveniently switching between multiple instances of a single configuration within its single backend.

A common use for multiple workspaces is to create a parallel, distinct copy of a set of infrastructure in order to test a set of changes before modifying the main production infrastructure. For example, a developer working on a complex set of infrastructure changes might create a new temporary workspace in order to freely experiment with changes without affecting the default workspace. Non-default workspaces are often related to feature branches in version control.

```bash
# list workspace
terraform workspace list

# create new workspace
terraform workspace new <WORKSPACE_NAME>

# show current workspace
terraform workspace show

# switch workspace
terraform workspace select <WORKSPACE_NAME>

# delete workspace
terraform workspace delete <WORKSPACE_NAME>

```

To get the name of the terraform workspace, we can use `terraform.workspace`.

When using multiple workspaces, the state files are stored in directories inside `terraform.tfstate.d`.

## Expressions

### Types

The Terraform language uses the following types for its values: string, number, bool, list (or tuple), map (or object), null.

Take note that square brackets are used to initialize list ie. `["us-west-1a", "us-west-1c"]` and curly braces for map ie. `{name = "Mabel", age = 52}`

## Resources Graph

[Resource Graph | Terraform by HashiCorp](https://www.terraform.io/internals/graph#walking-the-graph)

[Applying Graph Theory to Infrastructure as Code - YouTube](https://www.youtube.com/watch?v=Ce3RNfRbdZ0)

By default, up to 10 nodes in the graph will be processed concurrently.

Terraform analyzes any expressions within a resource block to find references to other objects and treats those references as implicit ordering requirements when creating, updating, or destroying resources.

## Backend

Backends define where Terraform's state snapshots are stored.

List of supported backend includes:

- local
- remote
- artifactory
- azurerm
- consul
- cos
- etcd
- etcdv3
- gcs
- http
- kuberenetes
- manta
- oss
- pg
- s3
- swift

## Style Conventions

[Style Conventions - Configuration Language | Terraform by HashiCorp](https://www.terraform.io/language/syntax/style)

- Indent two spaces for each nesting level.
- When multiple arguments with single-line values appear on consecutive lines at the same nesting level, align their equals signs

## Terraform Cloud

[Terraform full feature pricing table_v2](https://www.datocms-assets.com/2885/1602500234-terraform-full-feature-pricing-tablev2-1.pdf)

Terraform Cloud is available as **a hosted service** at https://app.terraform.io. Small teams can sign up for free to connect Terraform to version control, share variables, run Terraform in a stable remote environment, and securely store remote state. Paid tiers allow you to add more than five users, create teams with different levels of permissions, enforce policies before creating infrastructure, and collaborate more effectively.

You can use modules from a private registry, like the one provided by Terraform Cloud. Private registry modules have source strings of the form <HOSTNAME>/<NAMESPACE>/<NAME>/<PROVIDER>. This is the same format as the public registry, but with an added hostname prefix.

**Single Sign-On** requires Terraform Cloud for Business or Terraform Enterprise. It is NOT available in Terraform OSS or Terraform Cloud (free)

**Sentinel** is available in Terraform Cloud (Team & Governance), Terraform Enterprise, and Terraform Cloud for Business. It is NOT available in Terraform OSS or Terraform Cloud (free).

**Audit Logging** is available in Terraform Cloud (Team & Governance), Terraform Enterprise, and Terraform Cloud for Business. It is NOT available in Terraform OSS or Terraform Cloud (free).

## Terraform Enterprise

Enterprises with advanced security and compliance needs can purchase Terraform Enterprise, our **self-hosted** distribution of Terraform Cloud. It offers enterprises a private instance that includes the advanced features available in Terraform Cloud.

A Terraform Enterprise install that is provisioned on a network that does not have Internet access is generally known as an air-gapped install. These types of installs require you to pull updates, providers, etc. from external sources vs. being able to download them directly.

## References

- [Overview - Configuration Language | Terraform by HashiCorp](https://www.terraform.io/language)

- [Understanding Meta-Arguments in Terraform - Knoldus Blogs](https://blog.knoldus.com/meta-arguments-in-terraform/)
