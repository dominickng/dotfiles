#!/usr/bin/env python

import os
import readline
import rlcompleter
import readline
import atexit

defaultCompleter = rlcompleter.Completer(locals())

historyPath = os.path.expanduser("~/.pyhistory")
historySize = 1000

def myCompleter(text, state):
  if text.strip() == "" and state == 0:
    return text + "\t"
  else:
    return defaultCompleter.complete(text, state)

def save_history(historyPath=historyPath):
  import readline
  readline.set_history_length(historySize)
  readline.write_history_file(historyPath)

readline.set_completer(myCompleter)
readline.parse_and_bind("tab: complete")

if os.path.exists(historyPath):
  readline.read_history_file(historyPath)

atexit.register(save_history)

del rlcompleter, readline, atexit

