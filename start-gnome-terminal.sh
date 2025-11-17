#!/bin/bash
#
# Auto-start GNOME Terminal for remote X11 use with VcXsrv (Windows)
#

# --- Configuration ---
# Automatically detect your Windows IP from the SSH client
# (this works if you're connecting directly from Windows to Ubuntu)
WINDOWS_IP=$(echo $SSH_CLIENT | awk '{print $1}')
export DISPLAY=${WINDOWS_IP}:0
export GDK_BACKEND=x11

# --- Cleanup ---
# Kill any stale GNOME Terminal or D-Bus processes from old sessions
pkill -f gnome-terminal-server 2>/dev/null
pkill -f dbus-launch 2>/dev/null
pkill -f "dbus-daemon --session" 2>/dev/null

# Give a short pause to ensure processes terminate
sleep 1

# --- Launch new session ---
# Start a clean D-Bus session and GNOME Terminal
dbus-launch --exit-with-session gnome-terminal &

echo "Started new GNOME Terminal session on DISPLAY=$DISPLAY"

