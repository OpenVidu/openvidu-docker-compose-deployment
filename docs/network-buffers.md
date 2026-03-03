# Optimizing Network Buffers

For production deployments, it is recommended to increase the kernel's network buffer sizes on the host before starting the stack. WebRTC relies heavily on UDP for real-time audio and video transport, and the default Linux kernel buffer sizes are tuned for general-purpose workloads. Under high media load this can cause packet drops and jitter.

> [!NOTE]
> The [Single Node, Elastic, and HA deployments](https://openvidu.io/latest/docs/self-hosting/deployment-types/) from OpenVidu already handle this automatically. Those deployments run containers with `network_mode: host`, so kernel-level network tuning applied on the host is directly inherited by all containers without any bridge overhead. This Docker Compose deployment uses bridge networking, so the optimization must be applied manually.

Run the provided script as root on the host:

```bash
sudo sh config_network_buffer.sh
```

This raises the maximum and default socket buffer sizes and sets a minimum floor for UDP buffers so they cannot shrink under pressure. The settings are applied immediately and persisted across reboots via `/etc/sysctl.d/50-openvidu.conf`. See the inline comments in the script for a description of each parameter.
