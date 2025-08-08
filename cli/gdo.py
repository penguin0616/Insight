"""
Used for sorting descriptors... kind of...
"""

import argparse
import logging
import os
import subprocess
import sys

from . import *

################################################################################

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

console_handler = logging.StreamHandler()
console_handler.setLevel(logging.DEBUG)
console_handler.setFormatter(logging.Formatter(fmt='%(asctime)s.%(msecs)03d %(message)s', datefmt='%m/%d/%Y %H:%M:%S'))
logger.addHandler(console_handler)

################################################################################

def main(args: argparse.Namespace):
	filename = args.file
	
	component_descriptors_path = os.path.join(ROOT_INSIGHT_DIRECTORY, "./scripts/descriptors")
	prefab_descriptors_path = os.path.join(ROOT_INSIGHT_DIRECTORY, "./scripts/prefab_descriptors")
	
	
	
	component_descriptor_names = [f for f in os.listdir(component_descriptors_path) if os.path.isfile(os.path.join(component_descriptors_path, f))]
	prefab_descriptor_names = [(f + " [Prefab]") for f in os.listdir(prefab_descriptors_path) if os.path.isfile(os.path.join(prefab_descriptors_path, f))]

	if filename.endswith("[Prefab]"):
		if filename not in prefab_descriptor_names:
			prefab_descriptor_names.append(filename)
	else:
		if not filename in component_descriptor_names:
			component_descriptor_names.append(filename)

	allfiles = component_descriptor_names + prefab_descriptor_names
	allfiles.sort()
	
	for i in range(len(allfiles)):
		v = allfiles[i]
		
		if v >= filename:
			for offset in range(-2, 3):
				idx = i + offset
				if idx > 0 and idx < len(allfiles):
					logger.info(f"[{offset:>2}]: {allfiles[idx]}")
			break


################################################################################

parser = argparse.ArgumentParser(
	description="meeeeeh."
)
parser.set_defaults(func=main)
parser.add_argument("file", type=str, help="Examples: \"inspectable.lua\" and \"wortox.lua [Prefab]\"")


if __name__ == "__main__":
	args = parser.parse_args()
	try:
		args.func(args)
	except Exception as err:
		logger.exception(err)

