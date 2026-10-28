#!/usr/bin/env python3
"""Session start for i3: monitors, apps and where their windows go.

Left monitor: 1 kitty+tmux (tmux-continuum restores the sessions), 3 work Firefox, 6 Joplin.
Right monitor: 2 the other Firefox window, 4 Thunderbird (started once Proton Bridge listens).
"""
import json
import os
import re
import socket
import subprocess
import time

HOME = os.path.expanduser("~")
LAYOUT = os.path.join(HOME, ".screenlayout/i3.sh")   # saved with arandr, machine-specific
WORK = re.compile(r"gitlab|slack|trustisto|socialproof|sentry|aws", re.I)


def i3(cmd):
    subprocess.run(["i3-msg", "-q", cmd], check=False)


def run(*args):
    subprocess.Popen(args, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, start_new_session=True)


def windows(cls):
    tree = json.loads(subprocess.run(["i3-msg", "-t", "get_tree"], capture_output=True, text=True).stdout)
    found = []

    def walk(node):
        props = node.get("window_properties") or {}
        if re.fullmatch(cls, props.get("class") or "", re.I):
            found.append((node["id"], props.get("title") or ""))
        for child in node.get("nodes", []) + node.get("floating_nodes", []):
            walk(child)

    walk(tree)
    return found


def screens():
    # right after login a monitor may not report its modes yet ("cannot find mode"), so retry
    if os.access(LAYOUT, os.X_OK):
        for _ in range(20):
            if subprocess.run([LAYOUT], stderr=subprocess.DEVNULL).returncode == 0:
                break
            time.sleep(1)
    fehbg = os.path.join(HOME, ".fehbg")
    if os.access(fehbg, os.X_OK):
        subprocess.run([fehbg], check=False)


def firefox():
    run("firefox")
    # session restore opens the windows one by one; wait until their number stops changing
    seen, stable_since, deadline = -1, time.time(), time.time() + 90
    while time.time() < deadline:
        n = len(windows("firefox"))
        if n != seen:
            seen, stable_since = n, time.time()
        elif n and time.time() - stable_since > 5:
            break
        time.sleep(1)
    wins = windows("firefox")
    work = [w for w in wins if WORK.search(w[1])]
    if not work or len(work) == len(wins):
        work = wins[:1]
    work_ids = {con_id for con_id, _ in work}
    for con_id, _ in wins:
        i3(f'[con_id={con_id}] move container to workspace {"3" if con_id in work_ids else "2"}')


def thunderbird_after_bridge():
    deadline = time.time() + 180
    while time.time() < deadline:
        try:
            socket.create_connection(("127.0.0.1", 1143), timeout=1).close()
            break
        except OSError:
            time.sleep(2)
    run("thunderbird")


def main():
    screens()
    run("kitty", "--class", "startup-tmux", "tmux")
    run(os.path.join(HOME, ".joplin/Joplin.AppImage"))
    firefox()
    thunderbird_after_bridge()
    i3("workspace 1")


if __name__ == "__main__":
    main()
