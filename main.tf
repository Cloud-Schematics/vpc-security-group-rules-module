##############################################################################
# Convert Rules to Object
##############################################################################

module "security_group_rule_map" {
  source = "./list_to_map"
  list   = var.security_group_rules
}

##############################################################################

##############################################################################
# Create Rules
##############################################################################

resource "ibm_is_security_group_rule" "default_vpc_rule" {
  for_each  = module.security_group_rule_map.value
  group     = var.security_group_id
  direction = each.value.direction
  remote    = each.value.remote

  dynamic "tcp" {
    for_each = each.value.tcp == null ? [] : [each.value]
    content {
      port_min = each.value.tcp.port_min
      port_max = each.value.tcp.port_max
    }
  }

  dynamic "udp" {
    for_each = each.value.udp == null ? [] : [each.value]
    content {
      port_min = each.value.udp.port_min
      port_max = each.value.udp.port_max
    }
  }

  dynamic "icmp" {
    for_each = each.value.icmp == null ? [] : [each.value]
    content {
      type = lookup(each.value.icmp, "type", null)
      code = lookup(each.value.icmp, "code", null)
    }
  }
}

##############################################################################