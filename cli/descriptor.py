"""
Script used for managing descriptors.
"""

import argparse
from enum import Enum
import logging
import os
import subprocess

from . import *

################################################################################

class Descriptor(Enum):
	COMPONENT = 1
	PREFAB = 2

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

console_handler = logging.StreamHandler()
console_handler.setLevel(logging.DEBUG)
console_handler.setFormatter(logging.Formatter(fmt='%(asctime)s.%(msecs)03d %(message)s', datefmt='%m/%d/%Y %H:%M:%S'))
logger.addHandler(console_handler)

################################################################################

def resolve_descriptor_type(descriptor_type: str) -> Descriptor|None:
	"""
	Resolves a descriptor string to the proper type.

	:param descriptor_type: Descriptor type
	:returns: The resolved type if one was found.
	"""

	match descriptor_type:
		case "c" | "component":
			return Descriptor.COMPONENT
		case "p" | "prefab":
			return Descriptor.PREFAB
		case _:
			return None


def create_descriptor(name: str, type: Descriptor, overwrite: bool = False) -> str:
	"""
	Creates a descriptor of the specified type.
	
	:param name: The plain name of the descriptor -- examples include "combat", "weapon", "health".
	:param type: The type of descriptor to create.
	:returns: The filepath to the newly created descriptor.
	"""

	match type:
		case Descriptor.COMPONENT:
			directory_name = "descriptors"
		case Descriptor.PREFAB:
			directory_name = "prefab_descriptors"



	write_path = os.path.join(ROOT_INSIGHT_DIRECTORY, "scripts/", directory_name, f"{name}.lua")
	if os.path.exists(write_path) and not overwrite:
		raise Exception(f"Cannot overwrite existing descriptor [{write_path}]")

	filepath = os.path.join(ROOT_INSIGHT_DIRECTORY, "scripts/", directory_name, "example.lua")
	
	with open(filepath) as f:
		body = f.read()
		body = body.replace("example", name)
	
	
	with open(write_path, "w") as f:
		f.write(body)
	
	return write_path

def cli_make_descriptor(args: argparse.Namespace):
	descriptor_name = args.name
	descriptor_type = resolve_descriptor_type(args.type)

	if descriptor_name.endswith(".lua"):
		descriptor_name = os.path.splitext(descriptor_name)[0]

	if descriptor_type is None:
		raise ValueError(f"No descriptor of type \"{args.type}\" exists.")

	created_path = create_descriptor(descriptor_name, descriptor_type, args.force)
	logger.info(f"Created a {descriptor_name} descriptor at \"{created_path}\"")

	if not args.no_launch:
		subprocess.run(["code", created_path])



################################################################################

parser = argparse.ArgumentParser(
	description="Used for managing descriptors."
)
parser.set_defaults(func=lambda x: parser.print_help())
subparsers = parser.add_subparsers()

new_subparser = subparsers.add_parser("new", help="Create a new descriptor.")
new_subparser.set_defaults(func=cli_make_descriptor)
new_subparser.add_argument("name", type=str, help="The name of the descriptor.")
new_subparser.add_argument("type", type=str, choices=["c", "component", "p", "prefab"], help="The type of descriptor.")
new_subparser.add_argument("--force", "-f", action="store_true", help="Whether to overwrite the descriptor. Probably not recommended.")
new_subparser.add_argument("--no-launch", action="store_true")
#new_subparser.add_argument("--add-language", action="store_true")


if __name__ == "__main__":
	args = parser.parse_args()
	try:
		args.func(args)
	except Exception as error:
		logger.exception(error)

