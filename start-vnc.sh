#!/bin/bash

# Set environment variables
export DISPLAY=:99
export XDG_RUNTIME_DIR=/tmp/runtime-root
mkdir -p $XDG_RUNTIME_DIR
chmod 700 $XDG_RUNTIME_DIR

# Fix permissions for mounted Wine prefix
chown -R root:root /mt4/.mt4 2>/dev/null || true
chmod -R 755 /mt4/.mt4 2>/dev/null || true

# Start Xvfb (virtual framebuffer)
Xvfb :99 -screen 0 1280x720x24 &
sleep 2

# Start a simple window manager (fluxbox is lightweight)
fluxbox &
sleep 1

# Set VNC password from environment variable or use default
if [ -n "$VNC_PASSWORD" ]; then
    mkdir -p /root/.vnc
    x11vnc -storepasswd "$VNC_PASSWORD" /root/.vnc/passwd
    X11VNC_OPTS="-rfbauth /root/.vnc/passwd"
else
    X11VNC_OPTS="-nopw"
fi

# Start x11vnc on port 5900
x11vnc -display :99 -forever -shared -noxdamage -noxrecord $X11VNC_OPTS -rfbport 5900 &

# Give VNC time to start
sleep 2

# Start noVNC websockify on port 6080 (web access)
/opt/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 6080 &

# Give noVNC time to start
sleep 2

echo "VNC started on port 5900"
echo "noVNC web interface on port 6080"

# Check if MT4 is installed, if not install it
if [ ! -f "/mt4/.mt4/drive_c/Program Files (x86)/MetaTrader 4/terminal.exe" ]; then
    echo "Installing MetaTrader 4..."
    # Initialize Wine prefix first
    WINEPREFIX=/mt4/.mt4 wineboot -u
    sleep 3
    # Run installer
    WINEPREFIX=/mt4/.mt4 wine /mt4/mt4setup.exe /S &
    echo "MT4 installation started, waiting..."
    sleep 15
fi

# Find terminal.exe (it might be in different locations)
MT4_PATH="/mt4/.mt4/drive_c/Program Files (x86)/MetaTrader 4/terminal.exe"
if [ ! -f "$MT4_PATH" ]; then
    # Try alternative paths
    MT4_PATH=$(find /mt4/.mt4/drive_c -name "terminal.exe" -o -name "terminal64.exe" 2>/dev/null | grep -v windows | head -1)
fi

if [ -n "$MT4_PATH" ] && [ -f "$MT4_PATH" ]; then
    echo "Starting MetaTrader 4 from: $MT4_PATH"
    WINEPREFIX=/mt4/.mt4 wine "$MT4_PATH" &
else
    echo "MT4 terminal.exe not found. Opening terminal for manual install."
    # Launch xterm with instructions
    xterm -hold -e "echo 'MT4 not found. To install manually, run:'; echo 'WINEPREFIX=/mt4/.mt4 wine /mt4/mt4setup.exe'; bash" &
fi

# Keep container running
tail -f /dev/null
