Adversarial Spec-Delta Review — Component Management (F2, pass 6). VERDICT: NOT CLEAN. 0 CRIT, 1 HIGH, 2 MEDIUM, 2 LOW, 2 INFO.

HIGH-1 [bc-8 BC-8.1.004 title L117 + Behavior L135-154 + H2-note L119-130 vs exclusion case2 L171-177 vs BC-8.3.001 numeric-OLD note L1245-1247/Precond1 L1268 vs BC-8.3.005 Behavior L1486-1499]: BC-8.1.004 enumerates rename --project among "four subcommands using single-project --project-or-config-fallback model" but its own exclusion case2 says "guard never fires for rename at all — BC-8.3.005 owns it" then contradictorily "rename --project KEY is the one rename sub-case this BC DOES cover"; BC-8.3.001 says --project UNCONDITIONALLY REQUIRED no config-fallback; BC-8.3.005 app-level project.is_none()&&!all_projects → exit 64. Divergence: `rename OLD NEW` w/ configured default → BC-8.1.004 proceeds vs BC-8.3.005 exit 64. Also literally asserts guard both fires + never fires for rename. Fix: remove rename from BC-8.1.004 config-fallback framing; scope EC-8.1.004-2 to list/edit/delete; delete contradictory parenthetical.

MEDIUM-1 [bc-8 BC-8.1.008 L504-515, BC-8.1.007 M1 L407-409, BC-8.3.001 EC-8.3.001-2 L1288-1291]: not-found message branches overlap for numeric+--project-supplied+GET-404; branch1="not found in project <key>", branch2=project-less; P5 resolved to project-less (wrong when --project supplied). rename always supplies --project → can NEVER legitimately emit project-less yet EC-8.3.001-2 prescribes it → user told "specify a project" they already specified. Also reachable on edit 999999 --project ENG. Fix: branch2 only when no --project/config; else project-qualified.

MEDIUM-2 [verification-delta §3 L543-556, §7 L663-665]: §3 mapping omits BC-8.1.007→004,024 and BC-8.3.001→004,024; still lists BC-8.3.001 as VP-less ("covered by VP-008/019"); contradicts §1 VP-004 L163-165/VP-024 L463-465 + BC bodies (BC-8.3.001 L1303-1311, BC-8.1.007 L471-480); §7 L663-665 falsely claims §3 updated no-stale-refs. Fix: update §3, remove BC-8.3.001 from VP-less, correct §7.

LOW-1 [bc-2 BC-2.1.019 not:, BC-2.1.021 all: L427-438]: not:/all:/comma reserved-syntax collisions undocumented while none: collision IS (EC-2.1.020-4 L400-411). Component named not:Deprecated / all:Backend unreachable; name with comma split by all: parser. Fix: document + --jql workaround.

LOW-2 [verification-delta §8 L708-713]: claims components echo "covered by VP-011/016" but those pin PUT body not echo string/bare→add: normalization. Fix: state echo deliberately VP-less.

INFO-1: numeric edit no-fields HTTP arity unspecified — EC-8.1.007-1 pins zero-HTTP for name+no-fields but numeric M1 GET (L393) unconditioned on fields; `edit 10042` no-fields could fire stray GET before exit 64. Recommend EC pinning zero-HTTP numeric no-fields.

INFO-2: "already requires" revisionist wording in BC-8.1.007 M1 L393-399 / BC-8.3.001 M1 L1253-1255 (pre-P5 existence was via PUT/DELETE, not dedicated GET); BC-8.4.001 P5 L1633-1647 reconciles correctly; no behavioral impact.

PASSED: ADR↔BC consistent (current w/ P4/P5, NOT stale); delete-safety (fail-closed+ORDER BY+anti-loop+numeric-id-JQL+pagination); DEC-188 exit-codes; bulk wire (multiselectComponents/integer/2*ceil chunking/VP-012 live); Component.id Option vs full String; output profiles; VP 001-026 gapless (only §3 staleness mars it). Novelty MEDIUM-HIGH — new contradictions on freshly-touched P4/P5 seams.

---

## Fix-burst resolutions applied (product-owner, pass-6 remediation)

- HIGH-1: BC-8.1.004 rewritten to a three-subcommand (list/edit/delete) config-fallback model; rename removed from title, H2-note, and Behavior enumeration; EC-8.1.004-2 scoped to list/edit/delete; the contradictory "one rename sub-case this BC DOES cover" parenthetical deleted, leaving only the correct "guard never fires for rename — BC-8.3.005 owns it."
- MEDIUM-1: BC-8.1.008 and BC-8.1.007 M1 not-found-message rule restricted the project-less branch to "no --project supplied AND no config default AND no project derived"; BC-8.3.001 EC-8.3.001-2 corrected to state rename's 404 message is ALWAYS the project-qualified form (rename's Precondition 1 guarantees --project is always present).
- MEDIUM-2: verification-delta §3 BC↔VP mapping table updated to add BC-8.1.007→{VP-004,VP-024} and BC-8.3.001→{VP-004,VP-024}; BC-8.3.001 removed from the VP-less set; §7 corrected to accurately describe §3's staleness fix instead of falsely claiming it was already current.
- LOW-1: BC-2.1.019 and BC-2.1.021 gained new edge cases documenting the `not:`/`all:`/comma reserved-syntax collisions, symmetric with the existing `none` collision (EC-2.1.020-4), each with the `--jql "component = <id>"` workaround.
- LOW-2: verification-delta §8 corrected to state the `components` field-echo string (BC-3.4.012/013) is deliberately VP-less per the codebase's display-echo convention, not covered by VP-011/016 (which pin the PUT wire body only).
- INFO-1: BC-8.1.007 gained an explicit ordering note/EC pinning that the "at least one field" check (Precondition 2, exit 64) fires BEFORE the numeric confirming GET (Precondition 3), so a numeric edit with no field flags fires zero HTTP calls, matching EC-8.1.007-1's zero-HTTP intent for the name case.
- INFO-2: no fix — documented as no behavioral impact, wording-only, left for a future pass if it recurs.
