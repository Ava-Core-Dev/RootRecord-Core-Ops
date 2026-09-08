# Processor Migration List for Agents

This is the universal inventory and migration map for the AVA desk.

It is intentionally broader than one feature. The goal is to move AVA out of
large mixed-purpose files one processor at a time while preserving the desk's
24/7 behavior, remote fallback, deployment safety, and operator visibility.

This document is an index, not permission to change every listed subsystem in
one pass. Each migration must be isolated, tested, and verified live before the
next one starts.

## Authority Rules

- `C:\Users\rootr\ava` is the live AVA application checkout.
- `C:\Users\rootr\RootRecord Core Ops` is the workstation-level home for
  standalone processor implementations and Root Record operations.
- User-facing reports and documents belong in `C:\Users\rootr\Documents` or
  the declared AVA media/data root for that feature.
- Local AVA is authoritative while the desk is awake and connected.
- Cloudflare is proxy, cache, fallback, and standby automation. It is not the
  primary local scheduler or intelligence layer.
- `rootrecord.cloud` is the public home.
- `avaivy.cloud` is the Ava identity/wiki/blog surface.
- `origin.avaivy.cloud` points through the tunnel to `127.0.0.1:8787`.
- `api.rootmc.net` is the Minecraft API only.
- Never put credentials, deploy keys, tokens, cookies, `.env`, or
  `credentials.env` into a processor, README, backup, or Git checkout.
- Never start a second origin or second cloudflared connector.
- On Windows, the official origin spawner is Task Scheduler watchdog running
  `pythonw.exe`; agents must not hand-start a competing console uvicorn.

## Four-Operation Integration Contract

All four operations are one system and must work together cleanly. A migrated
processor is incomplete until its ownership and handoffs across all four are
documented and tested:

1. **Local AVA Core and Desk** — authoritative processing, scheduling,
   intelligence, local state, voice/radio, and operator control while the desk
   is awake.
2. **Public VPS and Nodes** — public-use nodes and server services that provide
   durable or externally reachable operations. Nodes are first-class production
   surfaces, not merely deployment targets or spare infrastructure.
3. **Vercel Site Delivery** — Next.js/static site builds, previews, production
   promotion, build status, and site-specific deployment flows.
4. **Cloudflare Edge and Fallback** — DNS, Workers, tunnel routing, heartbeat
   gating, cached/holding pages, standby jobs, and public edge protection.

### Required Handoffs

- Local AVA owns the source facts and schedules while online.
- Public VPS/nodes consume only declared deploy artifacts, APIs, or synced
  state; they must not invent local truth.
- Vercel receives the intended site artifact and must pass staging/visual QA
  before production promotion.
- Cloudflare routes traffic to the correct public node, Vercel site, or local
  origin and activates fallback only when the heartbeat/health contract says it
  should.
- Every public node has an owner, hostname, health check, deploy source,
  rollback path, backup path, and declared Cloudflare/Vercel relationship.
- A failure in one operation must degrade predictably without creating a
  duplicate scheduler, origin, tunnel, public node, or conflicting deployment.

### Processor Requirements

Every processor README must include a four-operation matrix stating:

| Operation | Owner | Input | Output | Failure behavior |
|---|---|---|---|---|
| Local AVA Core and Desk | | | | |
| Public VPS and Nodes | | | | |
| Vercel Site Delivery | | | | |
| Cloudflare Edge and Fallback | | | | |

Do not mark a migration complete until the matrix, public-node behavior, and
rollback path are filled in. A local test alone is not proof that the four
operations are integrated.

## Safe Migration Order

Follow this order unless the operator explicitly approves a dependency change.
The sequence moves observability and rollback foundations first, then local
runtime processors, then public delivery surfaces. Never migrate a dependent
feature before its health, backup, and deployment boundary is proven.

### Gate 0 — Freeze the Scope

Before touching code:

1. Name exactly one feature or tightly cohesive feature family.
2. Read the applicable `AGENTS.md`, common-bug notes, and source roadmap.
3. Record the current live paths, service owners, schedules, data roots, and
  public routes.
4. Search every caller, startup hook, scheduler registration, route, test, and
  maintenance script.
5. Check the live process and service state. Do not assume the checked-out code
  is what the running process loaded.
6. Make a timestamped backup of important live files.
7. Confirm the destination processor folder and data destination do not collide.

**Stop if:** ownership, callers, data paths, or rollback behavior are unknown.

### Gate 1 — Establish Recovery First

Before the first foundational migration, prove:

1. A clean source checkout or a documented dirty-worktree exception.
2. A usable database/runtime backup outside Git.
3. A checksum and source-commit marker for the backup.
4. A restore into a temporary target.
5. A working local health check and a known-good public fallback path.
6. The current PC remains available as rollback during all VPS/node work.

**Stop if:** restore has not been tested or rollback requires guessing.

### Step 1 — Migrate Status and Health

Migrate the status/health processor first because every later step depends on
observability. Include `/health`, uptime, scheduler state, heartbeat age,
process state, disk, host power, EcoFlow, and public/fallback status.

Verify locally, through the Desk, and through the public route. Keep the old
path as a compatibility call until the new processor has survived a restart.

### Step 2 — Migrate Watchdog and Supervision

Move watchdog ownership only after health is reliable. Preserve:

- one official origin spawner;
- one cloudflared connector;
- `pythonw.exe` and hidden execution;
- unlimited Task Scheduler execution time;
- breakaway process flags;
- health-based hung-origin recycling;
- cooldown state and file logs;
- parent/child process detection;
- no duplicate-origin behavior.

Test healthy, health-dark, port-open-but-wedged, offline-WAN, and tunnel-missing
conditions. Verify that a restart does not create a second origin or lose the
health endpoint.

### Step 3 — Migrate Origin Lifecycle and Boot

With supervision proven, extract boot/lifecycle orchestration. Preserve the
startup order for scheduler, heartbeat, voice, inbox, boot prelims, governance,
API imports, day board, and processor lifecycle hooks.

Restart through watchdog, inspect startup logs, confirm all expected jobs are
registered, and verify clean shutdown. Do not let Desk lifecycle compete with
Task Scheduler watchdog.

### Step 4 — Migrate Scheduler Control, Then Timing Families

Extract the scheduler control API and timing framework before moving individual
cron families. Keep the four timing classes intact:

1. `in-order-on-boot` — dependency-ordered boot work;
2. `always-on` — continuous/interval work;
3. `since-last-fire` — catch-up and interval work;
4. `on-time` — fixed HST clock slots.

After each family, verify registration, timezone, misfire behavior, manual
execution, last-run state, failure logging, and restart recovery. Migrate one
domain at a time in this order:

1. host/EcoFlow and solar;
2. weather, NOAA, NWS, radar, and Kilauea;
3. earthquakes and hazard tracking;
4. report generation and report catchup;
5. voice/audio/chimes/radio;
6. accounts, inbox, D1 sync, and identity;
7. economy, Stripe, API prices, and governance;
8. media, Minecraft, RCON, plugins, and node applications;
9. maintenance, code review, QR codes, and remaining utilities.

Do not combine a timing migration with a data-model migration unless the
operator has approved the larger rollback surface.

### Step 5 — Migrate Reports as Local Draft Processors

Extract report families only after their source freshness and scheduler paths
are observable. Recommended order:

1. Hybrid Tracking Reports;
2. NWS/weather;
3. Kilauea;
4. earthquakes;
5. morning/midday/evening/late reports;
6. economy and finance reports;
7. hurricane and tropical reports;
8. governance and code-review reports.

Every report processor must save locally first, preserve manual content, track
source timestamps, deduplicate, declare audio/publication behavior, and expose
missing-source warnings. Public posting remains a separate reviewed action.

### Step 6 — Migrate Voice, Radio, and Program Output

After report generation is stable, extract voice and radio. Preserve audio
priority, critical interruption, FIFO report order, music hold/duck/resume,
local Desk playback, program-feed separation, and orphan cleanup after restart.

Run a controlled alert, scheduled report, hourly chime, ambient playback, and
origin recycle test before moving on.

### Step 7 — Prove Local 24/7 Operation

Run the complete local system for an observation window before public cutover.
Verify at minimum:

- watchdog and tunnel remain singular;
- `/health` stays available;
- scheduler jobs continue through `:00`, `:15`, `:30`, and `:45`;
- heartbeat remains fresh;
- reports and audio continue;
- no duplicate lifecycle events appear;
- logs remain writable;
- backups complete;
- a controlled restart restores all services.

**Stop if:** any critical processor requires manual repair after restart.

### Step 8 — Prepare VPS and Public Nodes

Only after local 24/7 proof:

1. Create a clean VPS/node checkout from the approved GitHub branch.
2. Keep credentials, runtime data, databases, logs, and backups outside Git.
3. Install the read-only fast-forward pull service and timer.
4. Run `status` and dry-run checks before allowing pulls.
5. Add the deployment coordinator in observe-only mode.
6. Classify changed paths and validate dependencies.
7. Restart only the affected managed service.
8. Assign every public node a hostname, role, health endpoint, backup, and
  rollback owner.

Do not make a public node authoritative until it has passed the same health,
backup, report, and failure tests as local AVA.

### Step 9 — Prepare Vercel Staging

For every site:

1. Build the intended artifact.
2. Deploy to the matching `test.*` project.
3. Run visual, route, API, and asset checks.
4. Verify the correct Git branch and project/team ownership.
5. Confirm secrets are configured outside the repository.
6. Record the build ID and artifact hash.
7. Get operator approval before production promotion.

Never promote a production site directly from an unverified local build.

### Step 10 — Configure Cloudflare Edge and Fallback

After public nodes and Vercel staging are proven:

1. Verify DNS and Worker ownership for the intended domain.
2. Verify tunnel ingress only for the approved origin hostname.
3. Verify heartbeat freshness disables standby jobs while local AVA is awake.
4. Verify stale/missing heartbeat enables only the intended fallback behavior.
5. Verify Worker proxy retries, timeout, streaming, and offline response.
6. Verify private paths, `/ops`, account routes, and hidden products remain
  protected.
7. Test local origin up, origin slow, origin down, and public-node failure.

Do not change apex DNS to a tunnel or promote a route with unresolved account,
credential, or Worker ownership problems.

### Step 11 — 24–72 Hour Parallel Observation

Keep local AVA as rollback while the VPS/public nodes, Vercel sites, and
Cloudflare routes operate in parallel. Record:

- health and heartbeat age;
- scheduler and report freshness;
- public-node uptime;
- Vercel build/deploy results;
- Worker fallback transitions;
- backup success and restore availability;
- audio and public route behavior;
- resource use and unexpected restarts.

**Stop and roll back if:** data diverges, fallback loops, public routes point to
the wrong node, backups fail, or any service requires undocumented repair.

### Step 12 — Controlled Promotion and Cleanup

Promote one service or domain at a time. For each promotion:

1. Capture the pre-change state.
2. Announce the change window.
3. Promote the approved artifact/configuration.
4. Run local, node, Vercel, and Cloudflare checks.
5. Observe logs and health for the agreed window.
6. Confirm rollback remains possible.
7. Only then remove compatibility code, stale paths, old schedules, and
  duplicate data.

Never delete the old path before the new path has survived a real restart and
its output has been verified at the intended destination.

## Migration Completion Ledger

Update this checklist after each migration. Keep the current implementation
path and the next intended location visible; do not mark an item complete until
the live restart and rollback checks pass.

- [x] Hybrid Tracking Reports — `RootRecord Core Ops\Hybrid Tracking Reports`
- [x] EcoFlow local desk operation — `RootRecord Core Ops\Ecoflow`
- [x] WatchDog local supervision — `RootRecord Core Ops\WatchDog`
- [x] Weather and NWS reports — `RootRecord Core Ops\Weather` → `RootRecord Core Ops\Reports\YYYY\Month\Month Dth, YYYY`
- [x] Kilauea reports — `RootRecord Core Ops\Kilauea` → `RootRecord Core Ops\Reports\YYYY\Month\Month Dth, YYYY`
- [x] Earthquake reports — `RootRecord Core Ops\Earthquakes` → `RootRecord Core Ops\Reports\YYYY\Month\Month Dth, YYYY`
- [ ] Status and Health — `RootRecord Core Ops\Status and Health`
- [ ] Backup, Restore, and Rollback — `RootRecord Core Ops\Backup and Restore`
- [ ] Origin Lifecycle and Boot — `RootRecord Core Ops\Origin Lifecycle`
- [ ] Boot Prelims — `RootRecord Core Ops\Boot Prelims`
- [ ] Scheduler Control — `RootRecord Core Ops\Cron Control`
- [ ] Host, Solar, and remaining EcoFlow readers — `RootRecord Core Ops\Ecoflow`
- [ ] Remaining weather hazards — `RootRecord Core Ops\Weather and Hazards`
- [ ] Earthquakes and hazard tracking — `RootRecord Core Ops\Earthquakes and Hazards`
- [ ] Report generation and catchup — `RootRecord Core Ops\Reports`
- [ ] Voice and Audio — `RootRecord Core Ops\Voice and Audio`
- [ ] Radio Program — `RootRecord Core Ops\Radio Program`
- [ ] Accounts and Identity — `RootRecord Core Ops\Accounts and Identity`
- [ ] Inbox and D1 Sync — `RootRecord Core Ops\Inbox and D1 Sync`
- [ ] Economy and Finance — `RootRecord Core Ops\Economy and Finance`
- [ ] Governance — `RootRecord Core Ops\Governance`
- [ ] Public Node Connectivity — `RootRecord Core Ops\Node Connectivity`
- [ ] VPS Pull and Deployment — `RootRecord Core Ops\VPS Deployment`
- [ ] Vercel Site Flows — `RootRecord Core Ops\Vercel Site Flows`
- [ ] Cloudflare Edge and Fallback — `RootRecord Core Ops\Cloudflare Fallback`
- [ ] Media and Workstations — `RootRecord Core Ops\Media and Workstations`
- [ ] Minecraft, RCON, Plugins, and Node Apps — `RootRecord Core Ops\Node Apps`

When an operation is migrated, replace its old location in this ledger, add
the new path, record the compatibility boundary, and leave the checkbox marked
only after the full four-operation verification is complete.

## Status Labels

- **Landed** — code and runtime path exist and have been verified.
- **In progress** — code exists but migration, live proof, or hardening remains.
- **Planned** — documented next phase, not yet an operational guarantee.
- **Blocked** — a credential, account, route, host, or operator action is
  required before implementation can be considered complete.

## Processor Contract

Every migrated processor gets its own folder:

```text
C:\Users\rootr\RootRecord Core Ops\<Feature Name>\
    <feature_name>.py
    README.md
    tests or fixtures when needed
```

The processor owns its feature-specific functions, templates, state paths,
output paths, parsers, formatting, idempotence, and public entry points.

AVA keeps a thin compatibility boundary at:

```text
C:\Users\rootr\ava\apps\core\services\<feature_name>.py
```

Schedulers, lifecycle hooks, routes, Desk callers, and tests import through
that boundary. They do not load processor files by ad-hoc path.

For every migration:

1. Find all public callers.
2. Find all private helpers used only by the feature.
3. Find constants, state files, templates, and output roots.
4. Move the complete cluster together.
5. Remove the old implementation from the broad AVA file.
6. Rewire every caller.
7. Test idempotence, failure behavior, paths, and timing.
8. Restart through the real supervisor and verify live output.

## Migration 01: Hybrid Tracking Reports

**Status: Landed.**

Implementation:

```text
C:\Users\rootr\RootRecord Core Ops\Hybrid Tracking Reports\hybrid_reports.py
```

Feature README:

```text
C:\Users\rootr\RootRecord Core Ops\Hybrid Tracking Reports\README.md
```

AVA boundary:

```text
C:\Users\rootr\ava\apps\core\services\hybrid_reports.py
```

Report data:

```text
C:\Users\rootr\Documents\Hybrid Tracking Reports
```

Extracted from `apps/core/crons/since_last_fire/solar_weather.py`:

- `hybrid_daily_report_path`
- `ensure_hybrid_daily_report`
- `_automated_lines`
- `_charge_status_insert`
- `_power_automation_insert`
- `_strip_legacy_automation_lines`
- `_append_report_inserts`
- `append_hybrid_lifecycle_event`
- `_hybrid_prediction_inserts`
- `_replace_hybrid_prediction_sections`
- `_remove_legacy_prediction_inserts`
- `update_solar_notes`
- `update_hybrid_daily_report`
- `update_hybrid_charge_status`
- local report template and history-reading helpers

Preserved callers:

- `apps/core/scheduler.py` quarter-hour report update;
- `apps/core/scheduler.py` charge-status update;
- `apps/core/main.py` AVA STARTED lifecycle event;
- `apps/core/main.py` AVA STOPPED lifecycle event;
- `tests/test_hybrid_report_format.py` focused behavior suite.

Required proof:

- generated `◇ **HHMM** — ...` format;
- manual content survives automation;
- old generated lines are cleaned;
- inserts remain ordered and blank-separated;
- lines stay within 111 characters;
- repeated runs are idempotent;
- `:00`, `:15`, `:30`, and `:45` slots work;
- output is written under `Documents`.

## Migration 01A: EcoFlow Local Desk Operation

**Status: Data and AC-gate processor migrated; local AVA polling boundary
preserved.**

Implementation and local data root:

```text
C:\Users\rootr\RootRecord Core Ops\Ecoflow\
```

The live operation owns quota snapshots, public-pack history, load series,
three EcoFlow SQLite databases, and AC-gate state. AVA consumers must resolve
the root through `apps.core.services.data_layout.ecoflow_dir()`.

Preserved integration points:

- `ecoflow_quota` polling every two minutes;
- Delta 2 AC solar gate after fresh quota;
- status, solar history, Desk, OBS, report, voice, and chat readers;
- hidden-pack filtering and SQLite purge;
- local-only source of truth with optional D1/Worker mirror;
- hybrid report `POWER AUTOMATION` entries;
- operator `manual_ac_off` protection and post-PUT state verification.

Do not remove or rewrite AC automation while relocating EcoFlow. Verify the
gate's input, decision, skip reason, requested action, observed AC state, and
state path after every migration. The detailed local contract is in
`RootRecord Core Ops\Ecoflow\README.md`.

## Migration 02: VPS Pull and Deployment Coordinator

**Status: Pull-first landed; coordinator planned.**

Primary specification:

```text
ava/docs/migration-github-pull-first.md
```

Current updater:

```text
ava/scripts/auto-pull-server.py
```

Exact updater functions:

- `log`
- `git`
- `safe_output`
- `emit`
- `count`
- `main`
- nested `finish`

Current contract:

- VPS checkout is a clean clone of `Ava-Core-Dev/ava-core`.
- Pull is fast-forward-only and scheduled every ten minutes after boot.
- Dirty tree, detached HEAD, missing upstream, merge/rebase state, or fetch
  failure stops the operation.
- It never pushes, stashes, resets, force-updates, merges, or deletes runtime
  data.
- A shared `git-sync.lock` prevents overlapping Git operations.
- Logs redact token/password-looking output.

Systemd units:

```text
ava/operations/systemd/ava-github-pull.service
ava/operations/systemd/ava-github-pull.timer
```

Next processor extraction:

```text
C:\Users\rootr\RootRecord Core Ops\VPS Deployment\
```

Move the deployment-specific functions into a standalone processor only after
separating these responsibilities:

- Git state inspection;
- pull decision and lock ownership;
- dependency/install validation;
- changed-area classification;
- service restart selection;
- result reporting to the Desk;
- backup gating and rollback state.

The future deployment coordinator must detect changed runtime areas and restart
only the affected managed service. A content-only pull must not interrupt the
radio or API.

## Migration 03: Backup, Restore, and Rollback

**Status: Specification exists; processor planned.**

Primary specification:

```text
ava/docs/migration-github-pull-first.md
```

Responsibilities to migrate:

- consistent database export;
- schema/version marker;
- source commit and timestamp capture;
- database type capture;
- SHA-256 checksum generation and verification;
- daily and weekly rotation;
- available restore-point listing;
- restore confirmation and service coordination;
- temporary restore proof before production cutover;
- rollback observation and rollback execution.

Do not copy a live SQLite file over HTTP. Use SQLite backup/dump behavior or a
versioned PostgreSQL `pg_dump`, then prove restoration into a temporary target.
Backups remain outside Git and outside automatic push flows.

Suggested processor:

```text
C:\Users\rootr\RootRecord Core Ops\Backup and Restore\
```

Required operator facts:

- last successful backup;
- age and size;
- checksum status;
- source commit;
- database type;
- available generations;
- last tested restore.

## Migration 04: Windows Watchdog and 24/7 Supervision

**Status: Core implementation landed; extraction planned.**

Current owner:

```text
ava/windows/watchdog.py
```

Functions:

- `_port_open`
- `_health_ok`
- `_origin_pids`
- `_youngest_origin_age_s`
- `_origin_process_present`
- `_recycle_hung_origin`
- `_quiet_startupinfo`
- `_tunnel_running`
- `_ensure_tunnel`
- `_with_jdk`

Related registration:

```text
ava/windows/register-services.ps1
ava/windows/watchdog.xml
```

Registration function:

- `Register-SilentPythonw`

Managed scheduled tasks:

- `AVA-CORE\watchdog`;
- `auto-push`;
- `auto-pull`;
- `site-update`.

Required invariants:

- watchdog uses `pythonw.exe`;
- watchdog's long-running child escapes the Task Scheduler job;
- execution limit is `PT0S`;
- health, not port-open alone, decides whether origin is alive;
- hung origin recycling has a cooldown;
- one origin spawner remains authoritative;
- one cloudflared connector remains authoritative;
- watchdog output goes to `data/logs/origin-uvicorn.log`;
- tunnel output goes to `data/logs/cloudflared.log`.

Suggested processor:

```text
C:\Users\rootr\RootRecord Core Ops\Watchdog and Supervision\
```

Do not treat two uvicorn PIDs as two origins without checking parent/child
ownership and listener state. Do not kill by PID count alone.

## Migration 05: Origin Lifecycle and Boot

**Status: Landed in AVA; processor grouping planned.**

Current owner:

```text
ava/apps/core/main.py
```

Functions:

- `lifespan`
- `_startup_voice`
- `_boot_accounts`
- `_boot_governance`
- `_boot_api_prices`
- `_boot_prelims_and_day_board`
- `health`
- `maintenance`
- `api_config`
- `rootrecord_static_fallback`
- `cli`

Startup responsibilities:

- start FastAPI origin on `127.0.0.1:8787`;
- initialize scheduler;
- write heartbeat;
- start Stream Director/music bed and voice loops;
- drain inbox;
- start Python drop runner;
- run boot imports, governance, API ledger, and day-board prelims;
- append lifecycle events to standalone processors;
- avoid competing with watchdog or Desk lifecycle.

Suggested processors:

```text
C:\Users\rootr\RootRecord Core Ops\Origin Lifecycle\
C:\Users\rootr\RootRecord Core Ops\Boot Prelims\
```

Separate boot orchestration from feature implementation. Boot should call
processors through service boundaries and should not own their private state.

## Migration 06: Scheduler and Cronologicals

**Status: Core scheduler landed; processor-by-processor extraction required.**

Timing classes:

```text
always-on/          continuous or fixed interval work
since-last-fire/   interval, hourly, and catch-up work
on-time/           fixed HST clock slots
in-order-on-boot/  one ordered boot sequence
```

These directories are junctions into `apps/core/crons`; edit the target Python
modules, then verify the junction target and live scheduler.

Scheduler functions:

- `get_scheduler`
- `_job_wave`
- `Scheduler.__init__`
- `_register_jobs`
- `_sample_host`
- `_run_adsense_eod`
- `_run_admob_eod`
- `_run_clip_prebuild`
- `_run_solar_notes`
- `_run_hybrid_charge_status`
- `_eq_poll_m2`
- `_run`
- `start`
- `stop`
- `get_jobs`
- `ensure_midday_job`
- `run_job_now`

Cron family inventory:

### Always-on

- `broadcast_loop`
- `d1_sync`
- `ecoflow_quota`
- `inbox_drain`
- `kilauea_cams`
- `minecraft_live`
- `stripe_poll`
- `vercel_builds`

### Since-last-fire

- account import;
- earthquake hourly/polling;
- governance self-update;
- hourly chime and clip reports;
- hurricane tracking;
- Kilauea;
- NHC, NOAA, and NWS;
- radar archive;
- solar/weather and EcoFlow;
- system performance;
- user QR codes.

### On-time

- AdSense and AdMob;
- API prices;
- governance daily;
- economy;
- morning, midday, evening, and late reports;
- report audio/playback;
- hurricane fetch, desk, OBS, and radio;
- overnight;
- cleanup;
- cursor fallback;
- code review;
- daily report catchup.

### In-order-on-boot

- `boot_prelims`
- `day_board_boot`
- `governance_boot`
- `api_prices`
- `account_import`

Next migrations should create one processor per cohesive domain, not one
processor per tiny function. Preserve the timing class and the HST timezone in
the service boundary.

## Migration 07: Cron and Desk Control API

**Status: Landed; processor ownership planned.**

Current owner:

```text
ava/apps/core/routes/crons.py
```

Functions:

- `_cron_payload`
- `list_crons`
- `legacy_list_crons`
- `cron_runs`
- `ensure_midday`
- `run_cron`
- `legacy_run_cron`

This is the Desk-facing control plane for listing, history, hot registration,
and manual execution. It must remain a thin API layer. Cron behavior belongs
to the processor or cron module, not the route.

Suggested processor:

```text
C:\Users\rootr\RootRecord Core Ops\Cron Control\
```

## Migration 08: Heartbeat, Cloudflare, and Standby Fallback

**Status: Local heartbeat and Workers exist; credential/account paths remain a
known operational risk.**

Local heartbeat functions:

```text
ava/apps/core/heartbeat.py
```

- `_bearer_headers`
- `_legacy_headers`
- `_auth_modes`
- `_d1_url`
- `_d1_query`
- `write_heartbeat`
- `_missing_table`
- `last_success_age_s`

Heartbeat contract:

- AVA writes D1 approximately every 60 seconds.
- Fresh heartbeat under two minutes means local Ava is awake.
- Cloudflare scheduled handlers stand down while the heartbeat is fresh.
- Missing or stale heartbeat allows standby fallback logic to run.
- A D1 403/7403 credential mismatch breaks the gate and must be treated as a
  deployment blocker, not hidden as a normal offline state.

Cloudflare shared functions:

```text
ava/packages/workers/src/shared/heartbeat.ts
```

- `getHeartbeat`
- `avaIsAwake`
- `initHeartbeatTable`

```text
ava/packages/workers/src/shared/proxy.ts
```

- `outboundHeaders`
- `fetchFrontend`
- `proxyToOrigin`
- `offlineResponse`

```text
ava/packages/workers/src/shared/maintenancePage.ts
```

- `maintenanceHtml`
- `maintenancePage`

Worker entry points:

- `rootrecord-cloud/worker.ts` — public home, public proxy, feedback storage,
  scheduled uptime probe;
- `ava-api/worker.ts` — Ava API, chat/feedback fallback, context, radio, and
  hidden route policy;
- `rootrecord-api/worker.ts` — RootRecord API/frontend proxy, CORS, status,
  heartbeat gate, scheduled origin probe.

Suggested processors:

```text
C:\Users\rootr\RootRecord Core Ops\Heartbeat Gate\
C:\Users\rootr\RootRecord Core Ops\Cloudflare Fallback\
```

Do not move Cloudflare Workers into a Python processor. The processor boundary
for TypeScript Workers should be a matching standalone folder and deploy
boundary with its own tests and Wrangler configuration.

## Migration 09: Tunnel, Domain, and Node Connectivity

**Status: Windows tunnel landed; VPS/node topology remains staged.**

Tunnel configuration:

```text
ava/config/tunnel.yml
ava/windows/start-tunnel.ps1
```

Watchdog tunnel functions:

- `_tunnel_running`
- `_ensure_tunnel`

Connectivity responsibilities:

- `origin.avaivy.cloud` to local `127.0.0.1:8787`;
- fallback status when the origin is unavailable;
- no apex CNAME directly to the tunnel;
- no second cloudflared process;
- no use of `*.rootmc.net` for Ava origin;
- explicit domain ownership before a route cutover.

Suggested processor:

```text
C:\Users\rootr\RootRecord Core Ops\Node Connectivity\
```

For future VPS and node migration, document for each node:

- hostname and role;
- authoritative service set;
- SSH service/socket and port;
- systemd units;
- data and backup roots;
- health endpoint;
- deploy source and branch;
- rollback owner;
- which Cloudflare route or Worker can reach it.

## Migration 10: Vercel Builds and Site Flows

**Status: Polling/webhook/build retention landed; ownership and deployment
coordination remain in progress.**

Build service:

```text
ava/apps/core/services/vercel_builds.py
```

Functions:

- `builds_dir`
- `state_path`
- `_slug`
- `_redact`
- `_load_state`
- `_save_state`
- `_auth_headers`
- `_team_qs`
- `_key`
- `prune_expired`
- `delete_fixed`
- `_get_json`
- `fetch_build_log`
- `_write_error`
- `ingest_deployment`
- `sync_recent`

Webhook route:

```text
ava/apps/core/routes/vercel_builds.py
```

- `_valid_signature`
- `vercel_webhook`

Site updater:

```text
ava/scripts/site-update.py
```

- `_sources_hash`
- `_node_env`
- `_wrangler_cmd`
- `_run`
- `_http_status`
- `_sync_files`
- `_verify_public`
- `main`

Flow rules:

- Vercel hosts the Next.js frontends.
- Cloudflare owns DNS, Workers, tunnel, fallback, and edge routing.
- `test.*` Pages/Vercel projects receive visual QA before production.
- Auto-push is disabled during Emergent work so commits are not overwritten.
- Failed Vercel logs are stored privately, redacted, retained for five days,
  and removed after the deployment is fixed.
- A deploy coordinator must eventually classify changes and avoid restarting
  unrelated local services.

Staging projects:

- `test.avaivy.cloud` → `avaivy-cloud-test`;
- `test.alexrs94.site` → `alexrs94-site-test`;
- `test.rootrecord.online` → `rootrecord-online-test`;
- `test.rootmc.net` → `rootmc-web-test`;
- `test.rootrecord.info` → `rootrecord-info-test`.

Suggested processor:

```text
C:\Users\rootr\RootRecord Core Ops\Vercel Site Flows\
```

## Migration 11: Public Status and Health Surfaces

**Status: Landed; extraction planned.**

Current status route:

```text
ava/apps/core/routes/status.py
```

Functions:

- `health`
- `api_status`
- `api_live`
- `api_solar`
- `_solar_html`

Current site operations:

```text
ava/apps/core/services/site_ops.py
```

- `site_ops`
- `pv_line`

These surfaces must expose enough facts to verify 24/7 operation without
leaking credentials or private paths: uptime, heartbeat age, scheduler state,
CPU/memory/disk, GPU/NPU, host battery, EcoFlow, solar, and live status.

Suggested processor:

```text
C:\Users\rootr\RootRecord Core Ops\Status and Health\
```

## Migration 12: Voice, Radio, and Audio Priority

**Status: Core implementation landed; extraction planned.**

Architecture priority:

- P3 critical — earthquake and eruption alerts interrupt current audio;
- P2 scheduled — hourly chime and time announcements;
- P1 report — weather, solar, economy, and volcano reports queued FIFO;
- P0 ambient — rotating playlist paused by everything above it.

Primary areas to inventory before migration:

```text
ava/apps/voice/
ava/apps/core/services/report_periodic_audio.py
ava/apps/core/services/report_audio_manual.py
ava/apps/core/services/broadcast.py
ava/apps/core/services/radio.py
```

Migration must preserve:

- local Desk playback;
- program feed separation from desktop audio;
- music hold/duck/resume behavior;
- report/chime ordering;
- critical interruption behavior;
- local voice fallback when cloud voice is unavailable;
- no orphaned music processes after origin recycle.

Suggested processors:

```text
C:\Users\rootr\RootRecord Core Ops\Voice and Audio\
C:\Users\rootr\RootRecord Core Ops\Radio Program\
```

## Migration 13: Reports and Public Publishing

**Status: Multiple report processors landed; full separation ongoing.**

Architecture rule: automations save drafts locally first. Operator review is
required before public posting. The draft queue is `/api/reports/queue`.

Report families to migrate independently:

- NOAA/NWS weather;
- Kilauea and eruption status;
- earthquakes Hawaii/global;
- solar and EcoFlow;
- morning, midday, evening, and late reports;
- economy and finance;
- hurricane fetch/desk/OBS/radio;
- governance;
- code review;
- API prices;
- daily report catchup;
- hourly clips and chimes.

For every report processor, record:

- source reports and freshness rules;
- state/deduplication key;
- local draft path;
- audio path and priority;
- public publishing gate;
- Cloudflare fallback behavior;
- operator review action;
- rollback or deletion behavior.

## Migration 14: Economy, Accounts, Inbox, and Governance

**Status: Running families; extract by domain after report and infrastructure
boundaries are stable.**

Always-on domains:

- `d1_sync`;
- `inbox_drain`;
- `stripe_poll`;
- `player_economy`;
- `account_import`.

Boot and scheduled domains:

- `governance_boot`;
- `governance_daily`;
- `governance_self_update`;
- `api_prices`;
- `user_qrcodes`.

Before moving any of these, identify database tables, external APIs, retry
rules, credentials locations, and whether the function is local-authoritative
or edge-fallback-safe.

Suggested processors:

```text
C:\Users\rootr\RootRecord Core Ops\Accounts and Identity\
C:\Users\rootr\RootRecord Core Ops\Inbox and D1 Sync\
C:\Users\rootr\RootRecord Core Ops\Economy and Finance\
C:\Users\rootr\RootRecord Core Ops\Governance\
```

## Migration 15: Media, Workstations, and Node Apps

**Status: C-only cutover landed; external-drive cleanup and node ownership
remain in progress.**

Authoritative live layout is on C:. Do not reintroduce D: or E: runtime
requirements. Do not create a second copy of the application under `core` or
`ava-core-v2`.

Inventory before migration:

- media public/private layout;
- workstation imports and junctions;
- RootMC plugins and servers;
- Minecraft map/economy/RCON flows;
- Android/JAR build outputs;
- Java/JDK detection;
- static site sources and generated assets;
- external-drive archive versus live runtime.

Relevant verification paths:

```text
ava/windows/assert_c_only.py
ava/scripts/import_workstations.ps1
context/common-bugs/cutover/workstations-layout.md
context/common-bugs/cutover/external-drives-still-live.md
```

Each future node processor must document whether it is a local service, VPS
service, Cloudflare Worker, Vercel build, or static artifact. Do not mix these
ownership models in one processor.

## 24/7 Operating Model

While the desk is powered and connected:

1. Watchdog keeps the origin and tunnel supervised.
2. FastAPI origin runs on `127.0.0.1:8787`.
3. Scheduler runs all HST timing classes.
4. Heartbeat writes to D1.
5. Cloudflare Workers proxy local truth and stand down fallback jobs.
6. Voice/radio processors continue independently of public web traffic.
7. Reports are generated locally and remain drafts until reviewed.
8. GitHub auto-push and VPS pull remain separate from runtime state.
9. Backups remain outside Git and are independently restorable.
10. A real power-off allows Cloudflare standby behavior to take over.

24/7 verification must cover:

- one official origin spawner;
- one tunnel connector;
- healthy `/health`;
- fresh heartbeat age;
- scheduler jobs registered;
- no Task Scheduler execution-limit kill;
- no duplicate Desk/origin lifecycle;
- current report/output timestamps;
- Vercel and Worker fallback behavior;
- backup age and restore proof;
- public status when local origin is dark.

## VPS and Node Migration Phases

### Phase A — Pull first

**Current milestone.** Install the read-only GitHub pull service and ten-minute
timer on the VPS. Do not deploy live service restarts yet.

### Phase B — Deployment coordinator

Classify changed paths, validate dependencies, install only what changed, and
restart only the affected service. Report commit, service, validation, and
rollback state to the Desk.

### Phase C — External runtime state

Move `.env`, credentials, databases, media, logs, caches, and backups outside
Git. Verify permissions and restore paths before cutover.

### Phase D — Node ownership

For each VPS/node, define the service graph, SSH access, systemd units, health
checks, deployment branch, backup source, and Cloudflare/Vercel edge route.

### Phase E — Parallel observation

Keep the current PC as rollback. Observe the VPS/node for 24–72 hours with
health, heartbeat, logs, public routes, reports, audio, and backup checks.

### Phase F — Controlled cutover

Promote one domain or service at a time. Preserve rollback until the operator
accepts the evidence. Never cut over a credential-blocked or unverified route.

## Required Agent Report After Each Migration

Every agent finishing a processor migration must record:

- feature name and ownership;
- old files and exact functions removed;
- new processor path;
- AVA service boundary;
- all caller paths rewired;
- data/state paths moved or preserved;
- tests run and results;
- live restart method;
- health and output verification;
- known blockers and rollback procedure;
- the next migration candidate.

## Source Documents

Use these as the authoritative roadmap references:

- `ava/docs/architecture.md`
- `ava/docs/migration-github-pull-first.md`
- `ava/docs/STAGING-TEST-DOMAINS.md`
- `ava/docs/DOMAIN-CANONICAL.md`
- `ava/operations/cronologicals/README.md`
- `ava/windows/watchdog.py`
- `ava/apps/core/scheduler.py`
- `ava/apps/core/main.py`
- `ava/apps/core/heartbeat.py`
- `ava/apps/core/services/vercel_builds.py`
- `ava/scripts/site-update.py`
- `ava/scripts/auto-pull-server.py`
- `context/common-bugs/cronologicals/`
- `context/common-bugs/cloudflare/`
- `context/common-bugs/cutover/`
- `context/common-bugs/ssh/`

When a source document conflicts with actual live behavior, inspect the live
filesystem, process, service, log, and configuration first, then update this
list and the relevant operational note after verification.
