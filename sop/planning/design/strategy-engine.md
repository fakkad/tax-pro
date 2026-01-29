# Strategy Engine Design

## Overview

The strategy engine matches a user's profile against a library of tax strategies to identify applicable opportunities. This is the core value of Tax Pro — surfacing what users (and sometimes CPAs) miss.

---

## Architecture

```
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│  tax-profile.yaml │ ──▶ │  Strategy Engine │ ──▶ │  Opportunities   │
│  (user's data)    │     │  (pattern match) │     │  (ranked list)   │
└──────────────────┘     └──────────────────┘     └──────────────────┘
                                  ▲
                         ┌────────┴────────┐
                         │ Strategy Library │
                         │ (knowledge-base) │
                         └─────────────────┘
```

---

## Strategy Definition Format

Each strategy is a markdown file in `knowledge-base/strategies/` with structured frontmatter:

```yaml
---
id: hsa_maximize
name: "Maximize HSA Contributions"
category: retirement
priority_boost: 0  # Adjust base priority
applicable_when:
  - deduction_flags.has_hsa: true
  - amounts.contrib_hsa < amounts.limits.limit_hsa_family  # Or limit_hsa_self
not_applicable_when:
  - deduction_flags.has_hsa: false
requires_amounts: true  # Only match if Phase 3+
deadline: annual  # Or specific date like "2025-12-31"
savings_type: deduction  # deduction, credit, deferral, conversion
irs_authority: "IRC § 223, IRS Pub 969"
---

# Maximize HSA Contributions

## Why This Matters

Health Savings Accounts offer **triple tax advantage**:
1. Contributions reduce taxable income (like Traditional IRA)
2. Growth is tax-free (like Roth IRA)
3. Qualified withdrawals are tax-free (unlike either)

No other account offers all three.

## The Opportunity

[DYNAMIC: Calculated from profile]

**Your situation:**
- HSA coverage: {deduction_flags.hsa_coverage}
- Current contribution: ${amounts.contrib_hsa}
- Limit: ${limits.limit_hsa_family OR limit_hsa_self}
- Gap: ${limit - contrib_hsa}

**At your {analysis.estimated_bracket} bracket:**
- Federal tax savings: ${gap × bracket}
- State tax savings: ${gap × state_rate} (if state allows)
- Total first-year benefit: ${total}

## Action Steps

1. Calculate remaining contribution room
2. Contact HSA provider ({integrations.hsa_provider OR "your HSA administrator"})
3. Set up additional contribution before April 15 for prior year OR Dec 31 for current year
4. Consider payroll deduction increase for next year (also saves FICA)

## Special Cases

- **Age 55+**: Extra $1,000 catch-up contribution allowed
- **Mid-year coverage change**: Limit is prorated unless "last-month rule" applies
- **Employer contributions**: Count toward limit

## Source

{irs_authority}
```

---

## Strategy Categories

| Category | Description | Example Strategies |
|----------|-------------|-------------------|
| `retirement` | Tax-advantaged accounts | HSA max, 401k max, Roth conversion, backdoor Roth |
| `deduction` | Reducing taxable income | Charitable bunching, SALT optimization, QBI |
| `timing` | When to recognize income/deductions | Income deferral, acceleration, installment sales |
| `entity` | Business structure | S-Corp election, LLC formation, family employment |
| `credit` | Tax credits | EV credit, energy credits, child tax credit planning |
| `state` | State-specific | Remote work allocation, domicile planning |
| `investment` | Portfolio tax efficiency | Tax-loss harvesting, asset location, QSBS |
| `real_estate` | Property strategies | Cost segregation, 1031 exchange, PAL planning |

---

## Matching Logic

### Step 1: Filter by Applicability

```python
# Pseudocode
for strategy in strategy_library:
    if all(condition_met(profile, c) for c in strategy.applicable_when):
        if not any(condition_met(profile, c) for c in strategy.not_applicable_when):
            if strategy.requires_amounts and profile.phase >= 3:
                candidates.append(strategy)
            elif not strategy.requires_amounts:
                candidates.append(strategy)
```

### Step 2: Calculate Impact

For each candidate strategy, calculate estimated savings:

| Savings Type | Calculation |
|--------------|-------------|
| `deduction` | gap × marginal_bracket |
| `credit` | direct dollar value |
| `deferral` | present_value(future_tax_savings) |
| `conversion` | 0 now, but flag as "strategic" |

### Step 3: Rank by Priority

```
priority_score = base_priority + priority_boost + impact_score + urgency_score

where:
  base_priority = category defaults (retirement=80, credit=70, etc.)
  priority_boost = strategy-specific adjustment
  impact_score = estimated_savings / 1000 (normalize to 0-100)
  urgency_score = days_until_deadline < 30 ? 20 : 0
```

### Step 4: Generate Opportunities

Top 5-10 strategies become `analysis.opportunities[]` with:
- Personalized finding (profile values interpolated)
- Specific action steps
- Calculated savings estimate
- Deadline if applicable
- Source citation

---

## Strategy Library Structure

```
knowledge-base/
├── strategies/
│   ├── retirement/
│   │   ├── hsa-maximize.md
│   │   ├── 401k-maximize.md
│   │   ├── roth-conversion.md
│   │   ├── backdoor-roth.md
│   │   ├── mega-backdoor-roth.md
│   │   └── catch-up-contributions.md
│   ├── deduction/
│   │   ├── charitable-bunching.md
│   │   ├── donor-advised-fund.md
│   │   ├── salt-optimization.md
│   │   └── qbi-deduction.md
│   ├── timing/
│   │   ├── income-deferral.md
│   │   ├── deduction-acceleration.md
│   │   └── installment-sale.md
│   ├── entity/
│   │   ├── s-corp-election.md
│   │   ├── llc-formation.md
│   │   └── family-employment.md
│   ├── credit/
│   │   ├── ev-credit.md
│   │   ├── energy-credits.md
│   │   └── child-tax-credit.md
│   ├── state/
│   │   ├── remote-work-allocation.md
│   │   └── domicile-planning.md
│   ├── investment/
│   │   ├── tax-loss-harvesting.md
│   │   ├── asset-location.md
│   │   └── qsbs-exclusion.md
│   └── real_estate/
│       ├── cost-segregation.md
│       ├── 1031-exchange.md
│       ├── pal-planning.md
│       └── real-estate-professional.md
└── federal/
    ├── brackets-2025.yaml
    ├── limits-2025.yaml
    └── deadlines-2025.yaml
```

---

## Dynamic State Research

Rather than hardcoding 50 states, the agent researches state rules on-demand:

**When state-specific question arises:**
1. Check `knowledge-base/state/{state_code}/` for cached rules
2. If not found, research via web search or IRS/state DOR sites
3. Cache findings for future use
4. Always cite source and date

**Example cached file:** `knowledge-base/state/VA/income-tax.md`
```yaml
---
state: VA
topic: income_tax
last_verified: 2026-01-15
source: "Virginia Tax - https://www.tax.virginia.gov/"
---
# Virginia Income Tax

## Rates (2025)
- 2% on first $3,000
- 3% on $3,001 - $5,000
- 5% on $5,001 - $17,000
- 5.75% on $17,001+

## Notable Rules
- Follows federal AGI as starting point
- Retirement income: Age 65+ can deduct up to $12,000
- Military pay: Exempt for active duty stationed outside VA
```

---

## Red Flag Detection

Separate from opportunities, the engine also detects risks:

```yaml
red_flags:
  - trigger: "home_office: true AND w2_employment: true AND self_employment: false"
    flag:
      type: audit_risk
      description: "Home office deduction without self-employment income is frequently audited"
      severity: medium
      recommendation: "Ensure you have a legitimate business use. Document carefully."

  - trigger: "charitable_donations > (0.6 * agi)"
    flag:
      type: limit_exceeded
      description: "Charitable deductions may exceed 60% AGI limit"
      severity: high
      recommendation: "Carryforward rules apply. Consider spreading donations."

  - trigger: "estimated_tax_due > 0 AND withholding + estimated_payments < 0.9 * tax_liability"
    flag:
      type: penalty_risk
      description: "Underpayment penalty may apply"
      severity: high
      recommendation: "Consider Q4 estimated payment before Jan 15"
```

---

## Implementation Notes

### MVP Approach
1. Start with 10-15 high-impact strategies (HSA, 401k, Roth, charitable, rental)
2. Hard-code matching logic in agent prompt
3. Expand to full library over time

### Full Implementation
1. Strategy files with frontmatter (as shown above)
2. Parser that extracts conditions and templates
3. Matching engine that evaluates conditions against profile
4. Renderer that interpolates profile values into findings

### Agent Integration
The tax-strategist agent:
1. Reads profile
2. Runs strategy matching (or has it embedded in prompt)
3. Generates `analysis.opportunities[]`
4. Presents findings conversationally with sources
