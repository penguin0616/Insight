"""

"""

import argparse
import logging
import os
import subprocess
import sys

from . import *

################################################################################

################################################################################

def validate_lua_syntax(filepath: str) -> tuple[bool, str]:
	"""
	Checks that the specified lua file has valid syntax.

	:param filepath: Path to the lua file.

	:returns: Tuple where the bool is whether it was successful, and the string is the failure reason.
	"""
	
	filepath = os.path.abspath(filepath)

	process = subprocess.run(["luac5.1", "-p", filepath], stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding="utf8")

	return process.returncode == 0, process.stderr



def test_lua_syntax():
	for dirpath, dirnames, filenames in os.walk(ROOT_INSIGHT_DIRECTORY):
		for filename in filenames:
			if (ext := os.path.splitext(filename)[1]) == ".lua":
				is_valid, error = validate_lua_syntax(os.path.join(dirpath, filename))
				assert is_valid == True, error



################################################################################


if __name__ == "__main__":
	pass