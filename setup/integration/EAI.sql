CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION world_triathlon_integration
  ALLOWED_NETWORK_RULES = (world_triathlon_network_rule)
  ENABLED = True;

