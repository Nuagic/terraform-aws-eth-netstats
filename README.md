# terraform-aws-eth-netstats

This Terraform module setup an Ethereum monitoring solution based on https://github.com/cubedro/eth-netstats

![Screenshot](https://raw.githubusercontent.com/Nuagic/terraform-aws-eth-netstats/master/images/screenshot.jpg)

## Usage

```hcl
module "eth-netstats" {
  source                    = "Nuagic/eth-netstats/aws"
  name                      = "eth-netstats"
  vpc_id                    = "vpc-xxxxxx"
  subnet_ids                = ["subnet-yyyyyy", "subnet-zzzzzz"]
  service_discovery_service = "srv-ssssss"
  service_hostname          = "eth-netstats.mynetwork.local"
  nodes                     = {
    node-1 = {
      host = "ip-10-100-9-51.eu-west-1.compute.internal"
      port = 8545
    }
  }
}

```

## Examples
* [Complete example](https://github.com/Nuagic/terraform-aws-eth-netstats/blob/master/examples/complete/main.tf)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.0 |
| aws | >= 3.55.0 |
| local | >= 1.3 |
| template | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.55.0 |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create\_ecs\_cluster | Create ECS cluster | `bool` | `true` | no |
| ecs\_cluster | ECS cluster | `string` | `null` | no |
| eth-net-intelligence-api\_docker\_image | eth-net-intelligence-api docker image | `string` | `"nuagic/eth-net-intelligence-api:latest"` | no |
| ethstats\_docker\_image | EthStats docker image | `string` | `"nuagic/eth-netstats:latest"` | no |
| ethstats\_port | EthStats port | `number` | `80` | no |
| name | Resources name | `string` | n/a | yes |
| nodes | Node map | `map(object({ host = string, port = number }))` | n/a | yes |
| service\_discovery\_service | Service Discovery service id | `string` | `null` | no |
| service\_hostname | Service Discovery service hostname | `string` | `null` | no |
| subnet\_ids | Subnet IDs | `list(string)` | n/a | yes |
| tags | Resources tags | `map(string)` | `{}` | no |
| vpc\_id | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| service\_sg\_id | The Amazon Resource Name (ARN) that identifies the service security group |

