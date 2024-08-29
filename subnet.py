#!/usr/bin/env python3

import json
import sys
from ipaddress import IPv4Network


def calc_subnets(base_cidr, num_azs):
    try:
        base_network = IPv4Network(base_cidr)

        # Divide the base network into 4 equal parts
        quarter_subnet_new_prefix = base_network.prefixlen + 2  # Dividing by 4
        quarter_subnets = list(
            base_network.subnets(new_prefix=quarter_subnet_new_prefix)
        )

        if len(quarter_subnets) < 4:
            raise ValueError("Unable to divide the network into four equal parts")

        # Assign the first 3 parts as private subnets
        private_subnets = quarter_subnets[:3]

        # The last quarter is for small subnets (firewall and public)
        last_quarter = quarter_subnets[3]
        small_subnet_size = 28  # /28 subnets
        small_subnets = list(last_quarter.subnets(new_prefix=small_subnet_size))

        if len(small_subnets) < 6:
            raise ValueError(
                "Insufficient space in the last quarter for 6 small subnets"
            )

        # Allocate 3 subnets each for firewall and public
        firewall_subnets = small_subnets[:3]
        public_subnets = small_subnets[3:6]

        return json.dumps({
            "private_subnets": ",".join([str(subnet) for subnet in private_subnets]),
            "firewall_subnets": ",".join([str(subnet) for subnet in firewall_subnets]),
            "public_subnets": ",".join([str(subnet) for subnet in public_subnets])
        })

    except ValueError as e:
        return json.dumps({"error": str(e)})


if __name__ == "__main__":
    in_param = sys.stdin.read()
    in_json = json.loads(in_param)
    base_cidr = in_json.get("base_cidr")
    num_azs = in_json.get("num_azs")
    print(calc_subnets(base_cidr, num_azs))
