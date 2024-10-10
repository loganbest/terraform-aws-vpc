#!/usr/bin/env python3

import json
import sys
from ipaddress import IPv4Network


def calc_subnets(
    base_cidr, num_azs, enable_fw_subnets, enable_tgw_subnets, num_small_subnets
):
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

        # The last quarter is for small subnets (firewall, transit gateway, and public)
        last_quarter = quarter_subnets[3]
        small_subnet_size = 28  # /28 subnets
        small_subnets = list(last_quarter.subnets(new_prefix=small_subnet_size))

        if len(small_subnets) < num_small_subnets:
            raise ValueError(
                f"Insufficient space in the last quarter for {num_small_subnets} small subnets"
            )

        # Allocate 3 subnets each for firewall, tgw, and public
        if enable_fw_subnets:
            firewall_subnets = small_subnets[:3]
        else:
            firewall_subnets = []

        if enable_tgw_subnets:
            tgw_subnets = small_subnets[3:6]
        else:
            tgw_subnets = []

        public_subnets = small_subnets[6:9]

        return json.dumps(
            {
                "private_subnets": ",".join(
                    [str(subnet) for subnet in private_subnets]
                ),
                "firewall_subnets": ",".join(
                    [str(subnet) for subnet in firewall_subnets]
                ),
                "tgw_subnets": ",".join([str(subnet) for subnet in tgw_subnets]),
                "public_subnets": ",".join([str(subnet) for subnet in public_subnets]),
            }
        )

    except ValueError as e:
        return json.dumps({"error": str(e)})


if __name__ == "__main__":
    in_param = sys.stdin.read()
    in_json = json.loads(in_param)

    base_cidr = in_json.get("base_cidr")
    num_azs = in_json.get("num_azs")
    enable_fw_subnets = in_json.get("enable_fw_subnets")
    enable_tgw_subnets = in_json.get("enable_tgw_subnets")

    if enable_fw_subnets and enable_tgw_subnets:
        num_small_subnets = 9
    else:
        num_small_subnets = 6

    print(
        calc_subnets(
            base_cidr, num_azs, enable_fw_subnets, enable_tgw_subnets, num_small_subnets
        )
    )
