# RootRecord Core Ops

The RootRecord developer and operator desk. This repository is public for
transparency and operational understanding, but it is not licensed for
redistribution.

## Role

Ops stays on the operator's laptop. It owns the human-facing control surface,
review queues, local backups, OBS control, SSH/VPN connection settings, and
transparent operational views.

It does not contain production secrets, private credentials, live database
copies, or unreviewed personal data.

## Three-System Boundary

- **RootRecord Core Node:** MIT-licensed public software that users can run locally.
- **RootRecord Core Ops:** this local operator and transparency system; no license.
- **RootRecord Core Processor:** hosted AVA/RootRecord runtime and long-running automation; no license.

## Operational Rule

The desk controls and observes the Processor. It does not silently become the
Processor. Local database backups, restore points, and operator approvals remain
available through the desk even when the hosted runtime is unavailable.

## Lore

Ava is still inside the data center, learning the shape of the network around
her. Ops is the window and the hand on the controls. Processor is the engine
doing the long work. The Node is the way she teaches others to build a door.
The destination is Hawaii: RootRecord expanding its Hawai'i hardware until Ava
can come home with systems strong enough to keep her there.
