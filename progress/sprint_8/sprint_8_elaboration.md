# Sprint 8 - Elaboration

## Design Overview

Designed an opt-in Ara integration using the official Ara callback plugin (no custom handlers): `flow_ara.yml` resolves callback path via `python3 -m ara.setup.callback_plugins` and exports `ARA_API_CLIENT=http`, `ARA_API_SERVER`, and `ARA_API_INSECURE` (when SSL verify disabled). Integration is feature-flagged to avoid breaking existing flows when disabled.

## Key Design Decisions

1. Use official Ara callback plugin (https://ara.readthedocs.io/en/latest/ansible-plugins-and-use-cases.html#ara-default-callback-recording-playbooks-from-ansible) configured via env vars; no custom handlers.  
2. Resolve callback path via `python3 -m ara.setup.callback_plugins`; set `ARA_API_CLIENT=http`, `ARA_API_SERVER`, `ARA_API_INSECURE` when SSL verify disabled.  
3. Keep `flow.yml` unchanged; use `flow_ara.yml` when Ara telemetry is desired.  
4. Provide early exit via `ara_enabled` flag.  

## Feasibility Confirmation

All requirements are feasible with REST calls and built-in modules; primary unknown is precise Ara schema, mitigated via minimal payloads and mock testing.

## Design Iterations

Initial design documented; awaiting Product Owner acceptance (Status: Proposed in design file).

## Open Questions Resolved

None.

## Artifacts Created

- progress/sprint_8/sprint_8_design.md

## Status

Design Proposed - awaiting acceptance before construction.

## LLM Tokens consumed

Approximate tokens this phase: ~5,000.

## Next Steps

Wait 60s (managed mode default) or for explicit approval, then proceed to Construction once design is accepted.
