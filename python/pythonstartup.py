import atexit
import os
import readline

history_file = os.environ.get("PYTHON_HISTORY")
if not history_file:
    state_home = os.environ.get("XDG_STATE_HOME", os.path.expanduser("~/.local/state"))
    history_file = os.path.join(state_home, "python", "history")

os.makedirs(os.path.dirname(history_file), exist_ok=True)

try:
    readline.read_history_file(history_file)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, history_file)
