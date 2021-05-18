# Overview Security Tooling

## Prerequisite
The following tools need to be installed to run the getting started:
- k3d (`brew install k3d`)
- starboard (`brew install krew`, `kubectl krew install starboard`)

## Getting started

```
# Start cluster
make k3d-up

# Init Starboard
make starboard-init

# Start all scans
make scan

# Generate reports
make report

# Stop Cluster
make k3d-down
```