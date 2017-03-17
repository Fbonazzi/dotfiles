#! /usr/bin/env python
#
# Written by Filippo Bonazzi (2016)
#
# This program is free software: you can redistribute it and / or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################
#
# Read the JSON representation of the list of workspaces, get the focused
# workspace and open the first empty workspace available on the same output.
#
# We convert JSON directly to Python data by exploiting the similar syntax,
# we just need to convert "true" and "false" to "True" and "False". This is
# kind of a hack but it works fine for this short script.

import subprocess
import argparse
import sys
from operator import itemgetter
import ast

# Parse arguments
# A bit overkill for a single option maybe
parser = argparse.ArgumentParser(
    description="Launch a new i3 workspace on the active output.",
    epilog="Designed to run on a dual-monitor setup with odd workspaces "
    "on the left and even workspaces on the right.")
# Fill holes in the numbering
parser.add_argument("-f", "--fill-holes", action="store_true",
                    help="Fill holes in the workspace numbering on the active "
                    "output [Default: False]")
args = parser.parse_args()

try:
    line = subprocess.check_output(["i3-msg", "-t", "get_workspaces"])
except subprocess.CalledProcessError as e:
    # Print the error and exit
    print e.output
    print "Could not get list of workspaces from i3-msg. Aborting..."
    sys.exit(1)

# Replace "false"/"true" with "False"/"True" to "convert" JSON to Python
workspaces_str = line.replace("false", "False").replace("true", "True")
# Safely evaluate the data expression. Get a sorted list of workspaces
workspaces = sorted(ast.literal_eval(workspaces_str), key=itemgetter("num"))
workspace_nos = [w["num"] for w in workspaces]

# Find the focused workspace and save its output
for w in workspaces:
    if w["focused"]:
        focused_output = w["output"]
        focused_workspace = w["num"]
        break
if args.fill_holes:
    # Find the lowest free workspace on the focused output
    # Find the lowest workspace on the focused output
    new = focused_workspace % 2
    # Workspaces start from 1, not from 0
    if new == 0:
        new = 2
    # While the workspace number is taken, increment it by 2
    while new in workspace_nos:
        new += 2
else:
    # Find the highest workspace on the focused output and increase it by 2
    highest = 0
    for w in workspaces:
        if w["output"] == focused_output and w["num"] > highest:
            highest = w["num"]
    new = highest + 2

try:
    subprocess.check_call(["i3-msg", "workspace", str(new)])
except subprocess.CalledProcessError as e:
    # Print the error and exit
    print e
    print "Could not open workspace {}. Aborting...".format(new)
    sys.exit(1)
