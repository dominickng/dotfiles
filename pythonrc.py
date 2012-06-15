import atexit
import os
import readline
import rlcompleter
import sys

defaultCompleter = rlcompleter.Completer(locals())

histfile = os.path.expanduser("~/.pyhistory")
histsize = 1000

def myCompleter(text, state):
    if text.strip() == "" and state == 0:
        return text + "\t"
    else:
        return defaultCompleter.complete(text, state)

def save_history(histfile=histfile, histsize=histsize):
    import readline
    readline.set_history_length(histsize)
    readline.write_history_file(histfile)

readline.set_completer(myCompleter)
readline.parse_and_bind("tab: complete")

if os.path.exists(histfile):
    readline.read_history_file(histfile)

atexit.register(save_history)

del rlcompleter, readline, atexit
