# Changelog

All notable changes to this project will be documented in this file.

## v0.2.0 - 2026-03-22
- Run as non-root `squid` user and harden filesystem (read-only root + `tmpfs`).
- Stronger healthcheck to validate local proxy availability.
- Move generated `auto.conf` to writable cache dir and update include path.
- Add logging rotation options and resource limits in compose.
- Note: If you bind-mount cache/log directories, ensure they are writable by the `squid` user.
