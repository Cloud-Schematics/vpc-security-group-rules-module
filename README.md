# Security Group Rules Module

Create any number of rules for a single security group.

## Module Variables

`security_group_id` - The ID of the security group where rules will be created

## Security Group Rules Variable

```terraform
variable "security_group_rules" {
  description = "A list of security group rules to be added to a security group."
  type = list(
    object({
      name      = string # Name of security group rule
      direction = string # Can be `inbound` or `outbound`
      remote    = string # CIDR Block or IP for traffic to allow
      ##############################################################################
      # One or none of these optional blocks can be added
      # > if none are added, rule will be for any type of traffic
      ##############################################################################
      tcp = optional(
        object({
          port_max = optional(number)
          port_min = optional(number)
        })
      )
      udp = optional(
        object({
          port_max = optional(number)
          port_min = optional(number)
        })
      )
      icmp = optional(
        object({
          type = optional(number)
          code = optional(number)
        })
      )
    })
  )
  ...
}
```


## Example Usage

```terraform
##############################################################################
# Create VPC Default Security Group Rules
##############################################################################

module "security_group_rules" {
  source               = "github.com/Cloud-Schematics/vpc-security-group-rules-module"
  security_group_id    = ibm_is_vpc.vpc.default_security_group
  security_group_rules = var.default_security_group_rules
}

##############################################################################
```

