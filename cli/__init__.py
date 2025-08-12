import os

__all__ = ["ROOT_CLI_DIRECTORY", "ROOT_INSIGHT_DIRECTORY"]

ROOT_CLI_DIRECTORY = os.path.split(os.path.realpath(__file__))[0]
ROOT_INSIGHT_DIRECTORY = os.path.abspath(os.path.join(ROOT_CLI_DIRECTORY, ".."))
