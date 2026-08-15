Adversarial Spec-Delta Review — Component Management (F2, pass 4). VERDICT: NOT CLEAN. Counts: 1 HIGH, 1 MEDIUM, 4 LOW, 2 INFO. Novelty MODERATE-to-LOW (heavily-litigated areas sound; findings at BC/doc seams).

HIGH-1 [bc-8 BC-8.1.004 L135-140 vs BC-8.1.008 EC-8.1.008-1 L363-364, BC-8.2.001 Inv1+EC-8.2.001-4 L432-464, BC-8.2.002 M1 L529-533]: BC-8.1.004 unconditionally exits 64 for edit/delete when no --project/config, no numeric carve-out; but BC-8.1.008 EC-8.1.008-1 (`edit 10042` no --project → numeric bypass GET), BC-8.2.001 EC-8.2.001-4 (`delete 999999999` no disposition no --project → disposition-guard msg; Inv1 exception reasons "no HTTP in neither-flag path" which requires 8.1.004 NOT already exiting 64), and BC-8.2.002 M1 (--project optional for numeric source) all assume numeric bypass proceeds without project. /component/{id} not URL-project-scoped → numeric needs no project. Contradiction: different exit outcomes; implementer can't satisfy both. Fix: numeric-id exemption in BC-8.1.004 OR require project for numeric + fix the three ECs.

MEDIUM-1 [bc-8 BC-8.1.006 L285-289 vs verification-delta §0.1 L56, §1.1 VP-002 L108-112]: BC-8.1.006 says VP-002 EXTENDED (H2) to include `create --lead ""` (EC-8.1.006-3) zero-POST pin, but verification-delta VP-002 still cites only EC-8.1.006-1/2, omitting EC-8.1.006-3 + H2. §7/§8 don't mention VP-002 either. Definition differs between two in-perimeter docs. Fix: update verification-delta VP-002.

LOW-1 [bc-8 BC-8.2.002 M1 L507-536, BC-8.2.001 Inv1 L432-446]: numeric-source --project mismatch GET+exit-64 fires ONLY under --move-to; under --orphan (irreversible) + no-disposition it doesn't → `delete <id∈B> --project A --orphan --yes` silently orphans B ignoring --project A. Stricter check on safer disposition (inverted). Also only checks --project flag, never config-default. Fix: apply to all dispositions; address config-default.

LOW-2 [bc-3 BC-3.4.021 L2233, BC-3.4.013 L1116, BC-3.4.012 L962-966]: dry-run plannedChanges.components = array-of-objects; live changed_fields.components = string (H1 fix). BC-3.4.012 "byte-for-byte across three surfaces" holds only for dry-run TABLE, not dry-run JSON. First field divergent-typed across changed_fields vs plannedChanges. Fix: note intentional dry-run-JSON type difference or reconcile.

LOW-3 [ADR-0018 §3 L132-143, §1 L80-92 — architect]: snapshot clause shown without ORDER BY key ASC (BC-8.2.007 H1 made it mandatory); §1/§3 don't reflect M1/M2 numeric source/target confirmation GET. ADR behind its BCs. Fix: refresh clause + note numeric-confirmation GET. [OWNED BY ARCHITECT — concurrent, not touched by this burst]

LOW-4 [bc-8 BC-8.2.001 Postconditions L413-426 vs BC-8.3.005 L1137-1158]: BC-8.3.005 carries explicit DEC-188 note (neither-scope MUST be app-level JrError::UserError exit 64, NOT ArgGroup::required→exit 2) and says it's "mechanically identical to BC-8.2.001", but BC-8.2.001 lacks the same mechanism note. Parity/clarity gap (exit code unambiguous via prd-delta taxonomy). Fix: propagate the DEC-188 mechanism note to BC-8.2.001.

INFO-1: BC-8.2.008 non-idempotent delete (source-not-found → exit 64 not 0) diverges from research Q1.6 + CLAUDE.md idempotency convention but is well-reasoned/documented — accepted, on record.

INFO-2 [process-gap]: VP-COMPONENT-* cited inline with NO VP-INDEX/verification-architecture registry (verification-delta §4 R-4); no automated BC-cited-VP↔formalization consistency guard — MEDIUM-1 is exactly that class. Recommend architect seed a VP registry + check.

Verified CLEAN: delete-safety snapshot pagination/anti-loop fail-closed, cross-project resolver scoping, wire-shape asymmetry, exit-code DEC-188 class, filter #606, rename #608, BC↔VP 001-026, ADR↔BC (aside LOW-3 staleness), output-channel profiles, Component.id split. No #607/#609 drift.

---

## Fix-burst disposition (this session)

- HIGH-1: FIXED — numeric-ID exemption added to BC-8.1.004; ECs reconciled.
- MEDIUM-1: FIXED — verification-delta VP-COMPONENT-002 updated to cite EC-8.1.006-3 + H2.
- LOW-1: FIXED — numeric-source --project mismatch check extended to all dispositions (--orphan, neither-flag); config-default-project handling documented.
- LOW-2: FIXED — BC-3.4.012 "byte-for-byte across three surfaces" claim scoped to exclude dry-run JSON (which is array-of-objects, not string).
- LOW-3: NOT TOUCHED — owned by architect (ADR-0018), concurrent work.
- LOW-4: FIXED — DEC-188 mechanism note propagated to BC-8.2.001.
- INFO-1, INFO-2: accepted / on record, no action required this burst.
