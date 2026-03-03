#!/bin/sh
set -e

# Increases kernel network buffer sizes for optimal WebRTC media performance.
# WebRTC relies heavily on UDP for real-time audio and video. The default Linux
# kernel buffer sizes are tuned for general-purpose workloads and are often too
# small for high-bandwidth media streams, causing packet loss and jitter under load.
#
# This script applies and persists the settings via /etc/sysctl.d so they survive reboots.
# Run it as root on the host before starting the deployment.

echo "Increasing network buffer size for media traffic"
default_buffer_size=2500000  # 2.5 MB — default buffer size for new sockets
max_buffer_size=33554432     # 32 MB — maximum buffer size a socket can request

mkdir -p /etc/sysctl.d
echo "# OpenVidu system settings" > /etc/sysctl.d/50-openvidu.conf
settings="
net.core.rmem_max=$max_buffer_size
net.core.wmem_max=$max_buffer_size
net.core.rmem_default=$default_buffer_size
net.core.wmem_default=$default_buffer_size
net.ipv4.udp_wmem_min=$default_buffer_size
net.ipv4.udp_rmem_min=$default_buffer_size
"
# net.core.rmem_max          — max OS receive buffer per socket
# net.core.wmem_max          — max OS send buffer per socket
# net.core.rmem_default      — default receive buffer for new sockets
# net.core.wmem_default      — default send buffer for new sockets
# net.ipv4.udp_wmem_min      — minimum UDP send buffer (prevents shrinking under pressure)
# net.ipv4.udp_rmem_min      — minimum UDP receive buffer (prevents shrinking under pressure)

for setting in $settings; do
    # Apply setting immediately
    sysctl -w $setting || true

    # Split setting into key and value
    key=$(echo "$setting" | cut -d= -f1)
    value=$(echo "$setting" | cut -d= -f2)

    echo "$key = $value" >> /etc/sysctl.d/50-openvidu.conf
done
echo "Network buffer size adjustments applied and persisted."
