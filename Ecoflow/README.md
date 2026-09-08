# EcoFlow Local Desk Operation

EcoFlow is a local RootRecord Core Ops operation. Its live data, databases,
quota cache, history, load series, and AC solar-gate state stay here:

```text
C:\Users\rootr\RootRecord Core Ops\Ecoflow
```

## Contents

- `ecoflow_ac_solar_gate.py` — AC/solar hysteresis processor. It preserves the
  Delta 2 AC ON/OFF behavior and verifies device state after PUT operations.
- `state\ecoflow-ac-solar-gate.json` — operator settings, last decision, last
  action, and manual AC-off protection.
- `quota\` — signed EcoFlow quota snapshots.
- `history\` — public-pack JSONL history used by solar/status/report readers.
- `ecoflow-10s.db`, `ecoflow-1min.db`, `ecoflow-state.db` — local EcoFlow
  databases.
- `loads\` — measured load-category series.

AVA keeps compatibility boundaries and scheduler integration under
`ava\apps\core`, but all EcoFlow paths resolve through
`apps.core.services.data_layout.ecoflow_dir()` to this folder.

## Live Flow

1. `ecoflow_quota` calls the existing local AVA EcoFlow polling path.
2. Quota snapshots and history are written here.
3. The extracted AC gate reads the Delta quota from here.
4. The gate applies the existing 200/300 W hysteresis and SOC overlay.
5. A requested AC change is verified with a fresh signed quota read.
6. Status, reports, voice, Desk, and local routes read the same tree.
7. Cloudflare/D1 receives a mirror only; it is not the local source of truth.

The hidden third pack remains denied by the shared serial allowlist and purge
logic. Do not recreate an `ava\data\ecoflow` tree or import old D:/E: EcoFlow
archives into the live operation.
