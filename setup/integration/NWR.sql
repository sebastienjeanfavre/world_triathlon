create or replace network rule world_triathlon_network_rule
    MODE = EGRESS
    TYPE = HOST_PORT
    VALUE_LIST = ('api.triathlon.org');