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

from . import *

logger = logging.getLogger(__name__)

################################################################################

def generate(filepath: str, with_atlas: bool = False) -> tuple[bool, str]:
	"""
	Generates assets.
	
	:param filepath: Path to the file.

	:returns: Tuple where the bool is whether it was successful, and the string is the failure reason.
	"""

	args = ["klast", "compress", filepath]
	if with_atlas:
		args += ["--generate-atlas"]

	process = subprocess.run(
		args,
		stdout=subprocess.PIPE, 
		stderr=subprocess.PIPE, 
		encoding="utf8"
	)

	return process.returncode == 0, process.stderr.strip()


def main():
	# Make sure we actually have klast first.
	if shutil.which("klast") is None:
		logger.error("klast was not found")
		return sys.exit(1)
	
	IMAGES_ROOT = ROOT_INSIGHT_DIRECTORY.joinpath("images")
	
	# Generating textures for root images directory.
	failures = 0
	for file in IMAGES_ROOT.glob("*.png"):
		tex = file.with_suffix(".tex")
		atlas = file.with_suffix(".xml")

		if not tex.exists():
			is_valid, error = generate(str(file.absolute()), not atlas.exists())
			if not is_valid:
				logger.error("Encountered an error generating assets for %s: %s", file.absolute(), error)
				failures += 1
			else:
				logger.info("Generated assets for: %s", file.absolute())
		
	if failures > 0:
		sys.exit(1)

	# Okay, texture generation was fine. Time for magic.
	assets_dir = ROOT_INSIGHT_DIRECTORY.joinpath("scripts/assets")
	if not assets_dir.exists():
		logger.error("Unable to find assets directory?")
		sys.exit(1)
	

	assets = list(IMAGES_ROOT.glob("*.tex"))
	assets = map(lambda x: x.with_suffix("").relative_to(IMAGES_ROOT), assets)
	assets = sorted(assets, key=lambda x: str(x).lower())

	# First, bulk assets. Which is just the bulk of images I have in the images folder.
	with open(assets_dir / "bulkassets.lua", "w") as f:
		f.write("return {\n" + ", \n".join(map(lambda x: f'"{x}"', assets)) + "\n}")

	


################################################################################


if __name__ == "__main__":
	logging.basicConfig(
		level=logging.INFO,
		format="%(asctime)s [%(levelname)s] %(message)s",
		datefmt="%Y-%m-%d %H:%M:%S"
	)

	main()
