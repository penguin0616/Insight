#!/usr/bin/env python3
"""
Generates textures & atlases for all the images that do not already have them.
"""

import logging
import os
import pathlib
import shutil
import subprocess
import sys
from typing import Optional, TypedDict
import xml.etree.ElementTree as ET

from . import *

logger = logging.getLogger(__name__)

IMAGES_DIR = ROOT_INSIGHT_DIRECTORY.joinpath("images")
ASSETS_DIR = ROOT_INSIGHT_DIRECTORY.joinpath("scripts/assets")

################################################################################
class UVCoordinates(TypedDict):
	u1: float
	u2: float
	v1: float
	v2: float

def extract_uv_coords(atlas_xml: str, element_name: str) -> Optional[UVCoordinates]:
	root = ET.fromstring(atlas_xml)

	# Find the Element tag that matches the name attribute
	element = root.find(f".//Element[@name='{element_name}']")

	if element is None:
		return None
	
	return {
        "u1": float(element.attrib["u1"]),
        "u2": float(element.attrib["u2"]),
        "v1": float(element.attrib["v1"]),
        "v2": float(element.attrib["v2"]),
    }


def compress_image(filepath: os.PathLike, no_premultiply: bool = False, no_mipmaps: bool = False, no_trim: bool = False, no_atlas: bool = False) -> tuple[bool, str]:
	"""
	Generates assets.
	
	:param filepath: Path to the file.

	:returns: Tuple where the bool is whether it was successful, and the string is the failure reason.
	"""

	args = ["klast", "compress", os.path.abspath(filepath)]

	if no_premultiply:
		args += ["--no-premultiply"]

	if no_mipmaps:
		args += ["--no-mipmaps"]

	if no_trim:
		args += ["--no-trim"]

	if no_atlas:
		args += ["--no-atlas"]

	process = subprocess.run(
		args,
		stdout=subprocess.PIPE, 
		stderr=subprocess.PIPE, 
		encoding="utf8"
	)

	return process.returncode == 0, process.stderr.strip()

def pack_directory(dirpath: os.PathLike, no_premultiply: bool = False, no_mipmaps: bool = False, no_trim: bool = False) -> tuple[bool, str]:
	"""
	Packs a directory of images into a tex & atlas.
	
	:param dirpath: Path to the directory.

	:returns: Tuple where the bool is whether it was successful, and the string is the failure reason.
	"""

	args = ["klast", "pack", os.path.abspath(dirpath)]

	if no_premultiply:
		args += ["--no-premultiply"]

	if no_mipmaps:
		args += ["--no-mipmaps"]

	if no_trim:
		args += ["--no-trim"]

	process = subprocess.run(
		args,
		stdout=subprocess.PIPE, 
		stderr=subprocess.PIPE, 
		encoding="utf8"
	)

	return process.returncode == 0, process.stderr.strip()


def write_assets_file(name: str, assets_list: list[os.PathLike]):
	#assets = map(lambda x: pathlib.Path(x).with_suffix("").relative_to(IMAGES_DIR), assets_list)
	assets = map(lambda x: pathlib.Path(x).with_suffix("").name, assets_list)
	
	assets = sorted(assets, key=lambda x: str(x).lower())

	with open(ASSETS_DIR.joinpath(name + ".lua"), "w") as f:
		f.write("return {\n" + ", \n".join(map(lambda x: f'"{x}"', assets)) + "\n}")



def main():
	# Make sure we actually have klast first.
	if shutil.which("klast") is None:
		logger.error("klast was not found")
		return sys.exit(1)
	
	if not ASSETS_DIR.exists():
		logger.error("Unable to find assets directory?")
		sys.exit(1)
	
	##################################################
	# Generating textures for root images directory. #
	##################################################
	failures = 0
	for file in IMAGES_DIR.glob("*.png"):
		tex = file.with_suffix(".tex")
		atlas = file.with_suffix(".xml")

		if not tex.exists():
			# We only skip trimming (should_trim = False) if the atlas file exists 
			# and all the coordinates inside it are integers. In every other scenario, we trim.
			# It is moments like this that make me wonder if I'm overengineering.
			should_trim = not (atlas.exists() and all(val.is_integer() for val in extract_uv_coords(atlas.read_text(), tex.name))) # type: ignore
			
			is_valid, error = compress_image(file, no_trim=not should_trim, no_atlas=not atlas.exists())
			if not is_valid:
				logger.error("Encountered an error generating assets for %s: %s", file.absolute(), error)
				failures += 1
			else:
				logger.info("Generated assets for: %s", file.absolute())
		
	if failures > 0:
		sys.exit(1)

	##################################################
	# BulkAssets #
	##################################################

	# BulkAssets is just the list .tex files in the images directory that I haven't moved around.
	write_assets_file("bulkassets", list(IMAGES_DIR.glob("*.tex")))

	##################################################
	# Food Types #
	##################################################

	# These get packed into a single thing, but have to be referenced individually.
	food_dir = IMAGES_DIR.joinpath("food_types")
	pack_directory(food_dir)
	write_assets_file("food_types", list(food_dir.glob("*.png")))
	

	##################################################
	# Sinkholes #
	##################################################

	# These get packed into a single thing, but have to be referenced individually.
	forest_dir = IMAGES_DIR.joinpath("minimap/sinkholes/forest")
	pack_directory(forest_dir)
	write_assets_file("sinkholes_forest", list(forest_dir.glob("*.png")))

	caves_dir = IMAGES_DIR.joinpath("minimap/sinkholes/caves")
	pack_directory(caves_dir)
	write_assets_file("sinkholes_caves", list(caves_dir.glob("*.png")))
	
	



################################################################################


if __name__ == "__main__":
	logging.basicConfig(
		level=logging.INFO,
		format="%(asctime)s [%(levelname)s] %(message)s",
		datefmt="%Y-%m-%d %H:%M:%S"
	)

	main()
