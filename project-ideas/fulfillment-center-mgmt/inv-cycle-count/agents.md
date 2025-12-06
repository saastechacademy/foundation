# Agent guide

- Purpose: working notes for Inventory Count / Maarg doc updates.
- Audience: junior devs and interns (ESL-friendly), focusing on Moqui/OMS implementation details.

## Style guide highlights
- Start with a short “What this is / Who this is for.”
- Use short, direct sentences; avoid idioms; define acronyms on first use.
- Prefer bullets and numbered steps; one concept per bullet.
- Explain workflow → data/entities → APIs/messages → edge cases.
- Use backticks for field names/states; keep paragraphs ≤3 sentences; examples in fenced blocks with ISO/UTC times.

## Current focus
- Align all Inventory Count docs to the style guide.
- Clarify Moqui/OMS behaviors: locks, state flows, integration messages, and entity fields.

## Next steps
- Review and rewrite: `entities-and-workflows.md`, `inventory_count_locking_design.md`, `cycle_count_integration_entities.md`, `entities_owned_by_cycle_count_microservice.md`, `directed-cycle-count-story.md`.
- Add checklists and quick examples to each doc (state transitions, key fields, sample payloads).
- Note edge cases and failure modes (timeouts, retries, lock contention) in each relevant section.
