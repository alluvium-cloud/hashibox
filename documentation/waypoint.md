---
location: "/documentation/waypoint.md"
title: "Adding Waypoint"
---

# {% $markdoc.frontmatter.title %}

In some cases, you may want to use [Waypoint](https://www.waypointproject.io/),
allowing developers to deploy, manage, and observe their applications through a
consistent abstraction of underlying infrastructure.

## Prerequisites

To interact with a Waypoint server and runners, you first need to [install Waypoint
on your machine](https://learn.hashicorp.com/tutorials/waypoint/get-started-install).

**TLDR:** For macOS with [Homebrew](https://brew.sh/):

```bash
$ brew install hashicorp/tap/waypoint
```

## Installing Waypoint on Nomad

Since we already have a running Nomad cluster, adding Waypoint to HashiBox is
pretty straightforward.

By running the following command, you install a Waypoint *server* on the Nomad
client in the `home` datacenter, and register related services in Consul:

```bash
$ export NOMAD_ADDR=http://conad-server-1.alluvium.cloud:4646
$ waypoint install -accept-tos -platform=nomad \
  -nomad-host=conad-server-1.alluvium.cloud:4646 \
  -nomad-region=us \
  -nomad-dc=home \
  -nomad-consul-service=true \
  -nomad-consul-service-hostname=conad-client-1.alluvium.cloud \
  -nomad-consul-datacenter=us \
  -nomad-host-volume=waypoint-server \
  -nomad-runner-host-volume=waypoint-runner
```

No need to manually create the Nomad host volumes `waypoint-server` and
`waypoint-runner`. They already have been created by Nomad clients via the
configuration files.

Once done, the Waypoint UI is available at <https://conad-client-1.alluvium.cloud:9702>.
