#!/bin/bash

# Install MetaTrader 4 inside Docker container

# Set up Wine prefix as Windows 10
echo "Setting up Wine prefix..."
WINEPREFIX=~/.mt4 winecfg -v=win10

# Run the MT4 installer
echo "Running MT4 installer..."
WINEPREFIX=~/.mt4 wine mt4setup.exe
