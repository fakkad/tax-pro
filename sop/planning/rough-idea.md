# Tax Pro — Rough Idea

## The Problem

1. **Tax software is reactive, not strategic**
   - TurboTax asks "what do you have?" and fills forms
   - It doesn't ask "what could you be doing better?"

2. **CPAs are expensive and time-constrained**
   - Good tax strategy costs $300-500/hr
   - CPAs handle many clients, can't deep-dive on each
   - Strategic advice often missed due to time pressure

3. **Forward-looking advice is rare**
   - Most tools focus on current year filing
   - "You should have done X" is too late
   - Proactive planning requires ongoing attention

4. **Knowledge is scattered**
   - Tax code is complex (federal + state + local)
   - Strategies exist but aren't surfaced to average filers
   - Life changes trigger opportunities most people miss

---

## The Solution

An AI tax strategist that:

1. **Understands your complete situation** (profile)
   - Filing status, income types, bracket, states
   - Assets, entities, life events
   - Built through interview + documents + transaction data

2. **Matches your situation against strategies** (strategy engine)
   - 100+ tax optimization strategies in knowledge base
   - Pattern matching: "You have X → consider Y"
   - State-specific rules applied

3. **Provides proactive, forward-looking advice** (the differentiator)
   - "You had 1099 income — have you considered an LLC?"
   - "Your kid turns 18 next year — last year for child tax credit"
   - "You're under-contributing to 401K by $8K — that's $2,560 in tax savings"
   - "Consider bunching charitable donations into a DAF"

4. **Prepares you for strategic CPA conversations** (output)
   - Not just a folder of documents
   - Summary of opportunities identified
   - Questions to ask your CPA
   - What-if scenario comparisons

---

## Three Modes

| Mode | When | What It Does |
|------|------|--------------|
| **Intake** | First use / annual refresh | Interview → structured profile (JSON/YAML) |
| **Current Year** | Tax season (Jan-Apr) | Process docs, find deductions, prep CPA packet |
| **Next Year Planning** | Year-round | Proactive recommendations based on profile + life changes |

---

## Example User Journey

### New User (January)
1. Quick interview: filing status, income types, states (5 min)
2. Connect Monarch (optional) — auto-detect patterns
3. Upload documents as they arrive (W-2, 1099s)
4. System analyzes and surfaces opportunities
5. Generate CPA prep packet with strategic summary

### Returning User (Year-round)
1. Profile already exists
2. "Anything change since last year?"
3. Proactive alerts: "Dec 15 deadline for estimated payments"
4. Life event triggers: "You got married — here's what changes"
5. Strategic recommendations based on YTD data

---

## Example Strategic Recommendations

| Trigger | Recommendation |
|---------|----------------|
| High bracket + rental property | "Have you explored cost segregation for accelerated depreciation?" |
| HSA eligible, not maxed | "You have $3,200 unused HSA space — triple tax-advantaged" |
| Suspended PAL losses | "These release at sale — plan exit timing" |
| Multi-state (VA + DC) | "How is remote work allocated? Could optimize" |
| Charitable donations | "Consider bunching with a Donor-Advised Fund" |
| 1099 income > $50K | "Have you considered S-Corp election to save SE tax?" |
| Capital gains + losses | "Tax-loss harvesting opportunity before year-end" |
| Age 55+ | "HSA catch-up contribution now available (+$1,000)" |
| Kids approaching 18 | "Last year for child tax credit — plan accordingly" |

---

## Key Differentiator: Forward-Looking Advice

**Most tools**: "Here's what you owe based on what happened"

**Tax Pro**: "Here's what you could do differently next year to owe less"

This shifts from **tax filing** to **tax planning** — from reactive to proactive.

---

## Technical Approach (Initial Thoughts)

- **Profile storage**: JSON/YAML, local (privacy-first)
- **Strategy engine**: Rules/patterns that match profile attributes to opportunities
- **Knowledge base**: Federal + state tax rules, 100+ strategies
- **Integrations**: Monarch Money (transactions), document parsing
- **Output**: Markdown reports, CPA prep packets

---

## Open Questions

1. Who is the target user?
2. What scope? (Federal, state, entities)
3. What's the technical form factor?
4. How does it integrate with existing tools?
5. What's the business model?

---

*Created: 2026-01-29*
*Status: Ready for requirements clarification*
