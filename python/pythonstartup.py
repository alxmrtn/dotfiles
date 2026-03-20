import atexit
import os
import readline

history_dir = os.path.join(os.environ.get("XDG_CONFIG_HOME", os.path.expanduser("~/.config")), "python")
os.makedirs(history_dir, exist_ok=True)
history_file = os.path.join(history_dir, ".python_history")

try:
    readline.read_history_file(history_file)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, history_file)
