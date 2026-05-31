#!/usr/bin/env python3
"""
Validates the syntax for all the lua files in the repository.
"""

import argparse
import logging
import os
import shutil
import subprocess
import sys

from . import *

logger = logging.getLogger(__name__)

################################################################################

def validate_lua_syntax(filepath: str) -> tuple[bool, str]:
	"""
	Checks that the specified lua file has valid syntax.

	:param filepath: Path to the lua file.

	:returns: Tuple where the bool is whether it was successful, and the string is the failure reason.
	"""
	
	filepath = os.path.abspath(filepath)

	process = subprocess.run(
		["luac5.1", "-p", filepath], 
		stdout=subprocess.PIPE, 
		stderr=subprocess.PIPE, 
		encoding="utf8"
	)

	return process.returncode == 0, process.stderr.strip()

def test_lua_syntax():
	# Make sure we actually have luac first.
	if shutil.which("luac5.1") is None:
		logger.error("luac5.1 was not found")
		return sys.exit(1)
	
	failures = 0

	for dirpath, dirnames, filenames in os.walk(ROOT_INSIGHT_DIRECTORY):
		for filename in filenames:
			if (ext := os.path.splitext(filename)[1]) == ".lua":
				full_path = os.path.join(dirpath, filename)
				is_valid, error = validate_lua_syntax(os.path.join(dirpath, filename))

				if not is_valid:
					logger.error("Encountered an error validating %s: %s", full_path, error)
					failures += 1
				else:
					logger.debug("Validated: %s", full_path)

	if failures > 0:
		sys.exit(1)


################################################################################


if __name__ == "__main__":
	logging.basicConfig(
		level=logging.INFO,
		format="%(asctime)s [%(levelname)s] %(message)s",
		datefmt="%Y-%m-%d %H:%M:%S"
	)

	test_lua_syntax()
