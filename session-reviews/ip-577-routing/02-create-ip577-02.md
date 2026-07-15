## Summary

An adversary review pass may assert that mutation coverage is adequate without having run `cargo-mutants`. When this happens, the coverage claim is unverified. The mutation gate then catches survivors that the adversary missed, requiring a fix round.

## Trigger (jira-cli SOH-COMMENT-CRUD-1, 2026-07-14 — PG-F4-10)

The adversary for story S-577-6 (comment view handler), at step-4.5 pass-4, stated mutation coverage was adequate. No `cargo-mutants` run was performed. CI mutation gate subsequently measured an **86% kill rate** (below the ≥90% threshold), requiring 3 additional mutant-kill tests (commit `32e8991`) and a full fix round before the PR could merge.

The adversary was operating in standard tier-1 read-only configuration; it reasoned from test coverage patterns rather than empirical mutation results. The assessment appeared authoritative in the review output but had no verified basis.

## Distinction from #576

Issue #576 covers the verdict-vs-findings-list contradiction (adversary declares CLEAN while reporting findings). This issue is orthogonal: the adversary may correctly emit a verdict consistent with its finding count, but the mutation-coverage assessment embedded in that review may be an unverified claim about kill rate that the orchestrator accepts without challenge.

## Proposed Fix

**Adversary checklist addition (mutation-coverage lens):** When the adversary review reaches mutation coverage, it MUST explicitly state one of:

1. `Mutation gate: cargo mutants --in-diff was run. Kill rate: N%. Result: PASS / FAIL.` — empirical, valid.
2. `Mutation coverage: NOT VERIFIED EMPIRICALLY — no cargo-mutants run performed in this pass. Coverage assessment is based on test-structure reasoning only.` — declared unverified.

**Orchestrator check:** If an adversary review pass asserts adequate mutation coverage without an explicit empirical result statement, the orchestrator MUST treat the coverage assessment as UNVERIFIED and require the formal-verifier to run the mutation gate before advancing the convergence counter.

**"Looks well-covered" and "test suite covers the main paths" are not mutation results.**

## Severity

LOW process-gap. Undetected in-cycle: 1 extra fix round per adversary pass that claims false coverage adequacy.

## Source

jira-cli SOH-COMMENT-CRUD-1 session review 2026-07-15 (IP-577-02). Codified in `.factory/cycles/cycle-001/lessons.md` as PG-F4-10 (ADVERSARY-MUTATION-COVERAGE-CLAIM-WITHOUT-EMPIRICAL-RUN). Related: #576 (verdict-vs-count), and the general adversary empirical execution gap addressed in #485 (adversary misses CLI-mode-gated defects without empirical execution).
