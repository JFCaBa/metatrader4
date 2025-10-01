# MetaTrader 4 on Docker

Run MetaTrader 4 in a Docker container with proper Wine and 32-bit support on RHEL/AlmaLinux.

## Prerequisites

- Docker installed
- X11 server (VNC or local display)
- `xhost +local:docker` (for GUI access)

## Quick Start

### 1. Build and run container (first time)
```bash
./build-and-run.sh
```

Inside the container, install MT4:
```bash
./install-mt4.sh
```

### 2. Run MT4 (subsequent runs)
```bash
./run-mt4.sh
```

## Directory Structure

- `/opt/mt4/data/` - Persistent MT4 installation (mounted to container)
- `/opt/mt4/shared/` - Shared folder between host and container
- Container paths:
  - `/mt4/.mt4/` - MT4 installation inside container
  - `/mt4/shared/` - Access shared files

## Sharing Files

Put files on host in `/opt/mt4/shared/`, access them in container at `/mt4/shared/`.

Perfect for copying EAs, indicators, or trading data between host and MT4.

## Architecture

- **Base:** Debian Bullseye (32-bit support)
- **Wine:** WineHQ stable (with i386 libraries)
- **MT4:** Downloaded from MetaQuotes CDN
- **Display:** X11 forwarding to host VNC/display

## Notes

- Container runs as your user (proper permissions)
- Data persists between container restarts
- No need for QEMU/KVM or native Wine installation
