# Tax Pro — Project Memory

## Last Updated: 2026-01-29

---

## Project Overview

**Name**: Tax Pro (working title)
**Tagline**: "Your AI tax strategist — finds what CPAs miss"
**Status**: PDD Phase 3 — Requirements Clarification (Q3 answered, Q4 proposed)

**Core Concept**: An AI-powered tax planning system that goes beyond filing to provide strategic, proactive tax advice — the kind a $500/hr CPA would give if they had unlimited time for your specific situation.

**Technical Form**: Claude Code hybrid — slash commands, agent profiles, knowledge base, YAML profile storage. NOT a standalone app.

---

## Key Decisions Made

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Target user | Start with DIY filers (A), expand to all (E) | MVPable, then layer complexity |
| Technical form | Hybrid (D): Command + Profile + Agent | Best of all approaches |
| Profile schema | Phased collection (flags → docs → amounts → analysis) | Don't overwhelm users |
| State rules | Dynamic research | Better than hardcoding 50 states |
| Sources | IRS authority hierarchy | Trustworthy, verifiable advice |
| Analysis persona | Elite tax professional methodology | Strategy over compliance |

---

## Three Layers

```
┌─────────────────────────────────────────────────────────────┐
│  Layer 3: OUTPUT                                            │
│  "Here's what to discuss with your CPA"                     │
│  - Opportunities identified                                 │
│  - Questions to ask                                         │
│  - Forward-looking recommendations                          │
└─────────────────────────────────────────────────────────────┘
                              ▲
┌─────────────────────────────────────────────────────────────┐
│  Layer 2: STRATEGY ENGINE                    ← THE VALUE    │
│  Profile + Tax Code + State Rules → Opportunities           │
│  - Pattern matching against 100+ strategies                 │
│  - Multi-year projections                                   │
│  - What-if scenarios                                        │
└─────────────────────────────────────────────────────────────┘
                              ▲
┌─────────────────────────────────────────────────────────────┐
│  Layer 1: INTAKE                             (table stakes) │
│  Interview + Documents → Structured Profile (YAML)          │
│  - Phased collection (flags → docs → amounts)               │
│  - Document import                                          │
│  - Transaction integration (Monarch)                        │
└─────────────────────────────────────────────────────────────┘
```

---

## Agreed Repo Structure

```
tax-pro/
├── README.md                      ← Quick start + full setup
├── SYSTEM.md                      ← How it all works
├── install/
│   ├── setup.sh                   ← Bootstrap script
│   └── tax-profile.example.yaml   ← Template profile
├── .claude/
│   ├── agents/tax-strategist.md   ← Main agent (elite CPA persona)
│   ├── commands/
│   │   ├── tax-intake.md          ← Interactive profile builder
│   │   └── tax-packet.md          ← Generate CPA prep doc
│   ├── skills/tax-planning.md     ← Domain knowledge pointer
│   └── rules/tax-security.md      ← Never commit financial data
├── knowledge-base/                ← Shareable tax rules
│   ├── federal/
│   ├── state/
│   └── strategies/
└── .gitignore
```

---

## Research Completed

| Document | Summary |
|----------|---------|
| `research/competitive-landscape.md` | Range, Instead, FlyFin, TaxGPT analysis |
| `research/setup-patterns.md` | How claude-config, everything-claude-code, etc. do setup |
| `research/authoritative-sources.md` | IRS source hierarchy (IRC > Regs > Pubs > Rulings) |
| `research/tax-professional-methodology.md` | How elite CPAs think — multi-year, strategy-first |

---

## Design Artifacts

| Document | Summary |
|----------|---------|
| `design/tax-strategist-agent.md` | Agent persona design — philosophy, framework, red flags, modes |
| `design/profile-schema.md` | Full YAML schema with 4-phase collection model |
| `design/strategy-engine.md` | Strategy matching architecture, library structure, red flags |
| `implementation/plan.md` | 5-milestone build plan with demoable increments |

---

## Requirements Complete

- **Q1**: Target user? → All (E), start with DIY filers (A)
- **Q2**: Technical form? → Hybrid (D) — command + profile + agent
- **Q3**: Profile schema? → Phased collection + authoritative sources + elite CPA methodology
- **Q4**: Document intake flow? → Flags → personalized checklist, status tracking, manual entry MVP

---

## Implementation Milestones

| # | Milestone | Demo |
|---|-----------|------|
| 1 | Core Structure + Basic Intake | Run `/tax-intake`, get profile.yaml |
| 2 | Document Checklist | Flags → personalized doc list with status |
| 3 | Tax Strategist Agent (Basic) | Load agent, get strategic advice |
| 4 | Amount Entry + Calculations | Enter amounts → see dollar savings |
| 5 | CPA Packet + Polish | `/tax-packet` → markdown for CPA |

---

## Session Log

| Date | What Happened |
|------|---------------|
| 2026-01-29 AM | Project inception. Researched competitors. Defined three-layer architecture. Started PDD. |
| 2026-01-29 PM | Completed Q1-Q4 requirements. Created research docs (authoritative sources, tax professional methodology). Designed agent persona, full profile schema, strategy engine. Created 5-milestone implementation plan. |

---

## Next Steps

**Milestone 1 complete.** Ready for M2 (document checklist) or testing.

To test M1:
1. Run `./install/setup.sh` from the tax-pro directory
2. Open Claude Code, run `/tax-intake`
3. Complete interview, verify profile created at `~/.claude/tax-profile.yaml`
