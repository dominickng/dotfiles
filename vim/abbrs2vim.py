#!/usr/bin/env python

import time, os, os.path, sys

# To override the defaults, set these variables
EMAIL = ""

macros = {}
macros["YDATE"] = lambda: time.strftime("%Y-%m-%d")
macros["YEAR"]  = lambda: time.strftime("%Y")
macros["EMAIL"] = lambda: EMAIL or os.environ.get("EMAIL", "~/.vim/abbrs2vim.py")


vimdir = os.path.join(os.environ.get("HOME"), ".vim")
try:
	outfilename = os.path.join(vimdir, "abbrsout.vim")
	outfile = open(outfilename, "w")
except IOError:
	print >> sys.stderr, "Couldn't open output file for writing: %s" % outfilename
	sys.exit(1)

abbrsdir = os.path.join(vimdir, "abbrs")
if not os.path.isdir(abbrsdir):
	print >> sys.stderr, "Could not find directory with abbreviations: %s" % abbrsdir
	sys.exit(1)

for abbrfile in os.listdir(abbrsdir):
	abbr = open(os.path.join(abbrsdir, abbrfile), "r").read()
	for macro in macros.keys():
		if abbr.find(macro) >= 0:
			abbr = abbr.replace(macro, macros[macro]())
	abbr = abbr.replace("\n", "\r")
	# Put into paste mode and take out of paste mode
	abbr = "iab %s \x1b:set paste\ri%s\x1b:set nopaste\r" % (abbrfile.rsplit('.', 1)[0], abbr)
	if abbr.find("___") >= 0:
		# Then search for ___ to place the cursor there
		abbr += "gg\r/___\x1b:nohlsearch\n"
	else:
		# Leave the cursor in insert mode
		abbr += "a\n"
	outfile.write(abbr)


