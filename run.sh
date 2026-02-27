#!/bin/sh
set -e

# Docker script to configure and start an Http Proxy Server
# This script is intended to run inside the container only.

conf_dir="/etc/squid"

# Ensure cache and log dirs exist with sensible permissions
mkdir -p /var/cache/squid /var/log/squid
chown -R squid:squid /var/cache/squid /var/log/squid || true

# Initialize Squid cache directory if needed (safe to run on every start)
echo "Initializing squid cache directory (squid -z)..."
set +e
squid -z
_rc=$?
set -e
if [ $_rc -ne 0 ]; then
    echo "Warning: squid -z returned non-zero ($_rc). Continuing startup."
fi

# Start squid in foreground mode so container exits if squid exits.
squid -N &
SQUID_PID=$!

# Compute initial checksum of config directory (if present)
previous_status="$(find "${conf_dir}" -type f -exec md5sum {} \; | sort -k 2 | md5sum 2>/dev/null || true)"

stop() {
    echo "Stopping container, shutting down squid..."
    squid -k shutdown || true
}

trap 'stop; exit 0' TERM INT

while kill -0 "${SQUID_PID}" 2>/dev/null; do
    sleep 300
    current_status="$(find "${conf_dir}" -type f -exec md5sum {} \; | sort -k 2 | md5sum 2>/dev/null || true)"
    if [ "${previous_status}" = "${current_status}" ]; then
        echo "No changes on settings...Sleep 5 minutes"
    else
        echo "Changes found in settings, reloading squid configuration..."
        squid -k reconfigure || echo "squid reconfigure failed"
        previous_status="${current_status}"
    fi
done

wait "${SQUID_PID}"
