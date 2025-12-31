#!/usr/bin/env bash
set -e

echo "🔄 Cleaning XRDP leftovers..."

# Kill stale processes if any exist
pkill xrdp || true
pkill xrdp-sesman || true
pkill Xorg || true
pkill sshd || true

# Remove stale PID files
rm -f /var/run/xrdp/*.pid
rm -f /var/run/xrdp/*.sock
rm -f /tmp/.X*-lock
rm -rf /tmp/.X11-unix

# Recreate required directories
mkdir -p /var/run/xrdp
mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

echo "✅ XRDP cleanup complete"

echo "🚀 Starting dbus..."

if [ ! -S /run/dbus/system_bus_socket ]; then
  mkdir -p /run/dbus
  chmod 755 /run/dbus
  dbus-daemon --system --fork
fi

echo "🚀 Starting sshd..."
/usr/sbin/sshd

echo "🚀 Starting xrdp-sesman..."
xrdp-sesman --nodaemon &

echo "🚀 Starting xrdp..."
exec xrdp --nodaemon

