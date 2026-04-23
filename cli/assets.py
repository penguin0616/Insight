#!/usr/bin/env python3
"""
Prints out the bulk assets for easy copy and paste.
Expects .png, .tex, and .xml
"""

import os
import glob
import pathlib

from . import *

def main():
	results = []

	for img in ROOT_INSIGHT_DIRECTORY.joinpath("images").glob("*.png"):
		tex = img.with_suffix(".tex") 
		xml = img.with_suffix(".xml") 

		if not tex.exists():
			print(f"{img.name} is missing its .tex file")
			continue
		
		if not xml.exists():
			print(f"{img.name} is missing its .xml file")
			continue
		
		results.append(os.path.splitext(img.name)[0])

	print(", ".join(map(lambda x: '"' + x + '"', results)))


if __name__ == "__main__":
	main()