# Tax Pro — Project Memory

## Last Updated: 2026-01-29

---

## Project Overview

**Name**: Tax Pro
**Tagline**: "Your AI tax strategist — finds what CPAs miss"
**Status**: ✅ **v1.0 COMPLETE** — Deployed to GitHub
**Repo**: https://github.com/fakkad/tax-pro (PUBLIC)

**Core Concept**: An AI-powered tax planning system that goes beyond filing to provide strategic, proactive tax advice — the kind a $500/hr CPA would give if they had unlimited time for your specific situation.

**Target User**: Power users who want deeper analysis than DIY software offers. Not for basic filers.

**Technical Form**: Claude Code extension — slash commands, agent profiles, knowledge base, YAML profile storage.

---

## What's Built

### Commands
| Command | Purpose |
|---------|---------|
| `/tax-intake` | Build profile through conversational interview |
| `/tax-documents` | Process W-2s, 1099s, K-1s via OCR |
| `/tax-packet` | Generate CPA prep document |

### Knowledge Base
| Component | Contents |
|-----------|----------|
| `federal/limits-2025.yaml` | All 2025 contribution limits |
| `federal/brackets-2025.yaml` | Tax brackets, capital gains rates |
| `federal/document-mapping.yaml` | Flags → required documents |
| `federal/document-sourcing.yaml` | WHERE to get each document |
| `strategies/` | 6 tax optimization strategies |
| `state/VA/` | Virginia-specific rules |
| `state/_TEMPLATE/` | For adding other states |
| `probing-questions.yaml` | 15 "have you considered..." patterns |
| `expert-rules.yaml` | 10 compound patterns lazy preparers miss |

### Strategies Included
1. HSA Maximize
2. 401(k) Maximize
3. Backdoor Roth IRA
4. Roth Conversion
5. Charitable Bunching
6. PAL (Passive Activity Loss) Planning

### Virginia State Rules
- Tax brackets (2%, 3%, 5%, 5.75%)
- 529 deduction ($4K/account)
- May 1 filing deadline
- VA vs DC comparison
- Estimated tax timing

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            USER INTERACTION                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│  /tax-intake      │  /tax-documents   │  /tax-packet    │  tax-strategist   │
│  Build profile    │  Process docs     │  Generate CPA   │  Get advice       │
│                   │  (OCR extract)    │  prep packet    │                   │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         ~/.claude/tax-profile.yaml                           │
│  Phase 1: Flags → Phase 2: Documents → Phase 3: Amounts → Phase 4: Analysis │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                            KNOWLEDGE BASE                                    │
│  federal/ │ strategies/ │ state/VA/ │ probing-questions │ expert-rules     │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Data Security Model

```
PERSONAL (never in repo)             SHAREABLE (in repo)
────────────────────────             ───────────────────
~/.claude/tax-profile.yaml           knowledge-base/*
~/.claude/tax-history.yaml           .claude/agents/*
~/Documents/tax-packet-*.md          .claude/commands/*
                                     install/*.example.yaml
```

- All personal data stays in `~/.claude/` (gitignored)
- No SSNs, account numbers, or real amounts in repo
- Examples use generic placeholders (TechCorp, $180K, etc.)

---

## Key Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Target user | Power users, not DIY basics | DIY has enough tools |
| Document sourcing | Tell WHERE to get docs | More useful than just "what" |
| Probing questions | Pattern-triggered Qs | Elite CPA behavior |
| Expert rules | Compound patterns | Things lazy preparers miss |
| State support | VA complete + template | Easy to add others |
| Personal data | YAML in ~/.claude/ | Never touches repo |

---

## Milestones Completed

| # | Milestone | Status |
|---|-----------|--------|
| 1 | Core Structure + Basic Intake | ✅ |
| 2 | Document Checklist with Sourcing | ✅ |
| 3 | Tax Strategist Agent | ✅ |
| 4 | Amount Entry + Calculations | ✅ |
| 5 | CPA Packet Generation | ✅ |
| 6 | Enhancement: Document Sourcing | ✅ |
| 7 | Enhancement: Prior Year Data | ✅ |
| 8 | Enhancement: Probing Questions | ✅ |
| 9 | Enhancement: Expert Rules | ✅ |
| 10 | Enhancement: Multi-Year Projections | ✅ |
| 11 | Enhancement: VA State Rules | ✅ |
| 12 | Enhancement: Document OCR Command | ✅ |
| 13 | Security Audit + Personal Data Removal | ✅ |
| 14 | GitHub Deploy | ✅ |

---

## GitHub Status

**Repo**: https://github.com/fakkad/tax-pro
**Visibility**: PUBLIC
**Commits**: 1 (clean squashed release)

All personal data removed:
- ✅ No names (Ferris, Diana, etc.)
- ✅ No employers (AWS removed)
- ✅ No locations (Fairfax, McLean removed)
- ✅ No specific amounts ($326K removed)
- ✅ Generic examples only
- ✅ Git history squashed — no trace of removed data in commit history

---

## Session Log

| Date | What Happened |
|------|---------------|
| 2026-01-29 AM | Project inception. Research. PDD started. |
| 2026-01-29 PM | Requirements complete. Design docs created. |
| 2026-01-29 PM | M1-M5 built. Full system working. |
| 2026-01-29 PM | Enhancement plan: 5 phases designed. |
| 2026-01-29 EVE | All enhancements implemented. VA state rules. Document OCR. |
| 2026-01-29 EVE | Security audit. Personal data removed. GitHub deployed. |
| 2026-01-29 EVE | Made other repos private (fin-ai, camp-lejeune, cloud-migration). |
| 2026-01-29 EVE | Squashed git history to single clean commit (no trace of removed data). |

---

## To Use

```bash
# Clone and setup
git clone https://github.com/fakkad/tax-pro.git
cd tax-pro
./install/setup.sh

# In Claude Code:
/tax-intake           # Build your profile
/tax-documents        # Process tax documents
/tax-packet           # Generate CPA prep doc

# Or load the agent:
"Use the tax-strategist agent and review my situation"
```

---

## Future Ideas

- [ ] Add more states (CA, NY, TX, FL)
- [ ] Monarch Money integration for transaction import
- [ ] More strategies (ESPP, AMT, estate planning)
- [ ] Web interface version
- [ ] Share on LinkedIn for feedback
