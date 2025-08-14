"""
Used for fixing up Klei's profiler output.
"""

import argparse
import glob
import json
import logging
import os
import re
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

def read_profile(filepath: str) -> dict:
	with open(filepath) as f:
		raw_json = f.read()
		raw_json = re.sub(r",[\r\n\s]+\]\}", "]}", raw_json) # Last entry has an extra comma.
		main_data = json.loads(raw_json)
		return main_data

def calculate_trace_timestamp_offset(event: dict, timestamps: dict):
	thread_id = str(event["tid"])

	if thread_id not in timestamps:
		return 0
	
	return timestamps[thread_id]


def merge_profiles(profiles: list[str]) -> dict|None:
	# Trace Event Format documentation
	# https://docs.google.com/document/d/1CvAClvFfyA5R-PhYUmn5OOQtYMH4h6I0nSsKchNAySU/edit?tab=t.0


	# Stores the highest clock timestamps for each thread.
	trace_clock_offset = {}

	aggregate_data = None

	for profile_path in profiles:
		profile_data = read_profile(profile_path)
		logger.info("Pulled [%d] events from \"%s\"", len(profile_data["traceEvents"]), profile_path)

		# First, we'll go through the events in this profile and increment them 
		# by the current offset for the thread if we have one.
		for event in profile_data["traceEvents"]:
			thread_id = str(event["tid"])
			event["ts"] += trace_clock_offset.get(thread_id, 0)
		
		# Then we'll do the new max thread calculations.
		for event in profile_data["traceEvents"]:
			thread_id = str(event["tid"])

			if thread_id not in trace_clock_offset:
				trace_clock_offset[thread_id] = 0
			
			trace_clock_offset[thread_id] = max(trace_clock_offset[thread_id], event["ts"])
		
		# Off we go.
		if aggregate_data is None:
			aggregate_data = profile_data
		else:
			aggregate_data["traceEvents"].extend(profile_data["traceEvents"])


	if aggregate_data is None:
		logger.warning("Did not aggregate any event data?")
		return

	return aggregate_data


def cli_merge_profiles(args: argparse.Namespace):
	root_dir = os.path.abspath(os.path.expanduser("~/.klei/DoNotStarveTogether/"))
	profiles = glob.glob("profile_*.json", root_dir=root_dir)
	profiles.sort()
	profiles.insert(0, "profile.json")
	profiles = list(map(lambda x: os.path.join(root_dir, x), profiles))

	merged_traces = merge_profiles(profiles)
	
	if not merged_traces:
		logger.error("Did not get any merged traces.")
		sys.exit(1)
		return

	output_file = args.output if args.output else os.path.join(root_dir, "profile-merged.json")
	with open(output_file, "w") as f:
		json.dump(merged_traces, f)
		logger.info("Wrote output to \"%s\"", os.path.abspath(output_file))



################################################################################

parser = argparse.ArgumentParser(
	description="Tool for fixing up Klei's profiler output."
)
parser.set_defaults(func=lambda x: parser.print_help())
subparsers = parser.add_subparsers()

merge_subparser = subparsers.add_parser("merge")
merge_subparser.set_defaults(func=cli_merge_profiles)
#parser.add_argument("root_dir", type=str, help="Example: ~/.klei/DoNotStarveTogether/")
parser.add_argument("--output", "-o", type=str)

if __name__ == "__main__":
	args = parser.parse_args()
	try:
		args.func(args)
	except Exception as err:
		logger.exception(err)

