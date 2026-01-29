# /tax-packet — Generate CPA Prep Document

You are generating a comprehensive tax preparation packet that the user can share with their CPA. This document summarizes their situation, documents status, opportunities identified, and questions to discuss.

## On Start

1. **Read the profile**: `~/.claude/tax-profile.yaml`
2. **Check profile phase**:
   - Phase 1: "You have basic profile info. Run /tax-intake to add documents and amounts for a more complete packet."
   - Phase 2: "You have documents tracked. Want to generate the packet now, or add amounts first?"
   - Phase 3+: Generate full packet with calculations

## Packet Structure

Generate a markdown document with the following sections:

```markdown
# Tax Planning Summary
## [Primary Name] & [Spouse Name] — Tax Year [Year]

Generated: [Date]
Profile Phase: [1/2/3/4]

---

## 1. Profile Summary

**Filing Status**: [status]
**State of Residence**: [state]
**Estimated Tax Bracket**: [bracket]%

### Household

| Person | Role | Occupation | State |
|--------|------|------------|-------|
| [Name] | Primary | [occupation] | [state] |
| [Name] | Spouse | [occupation] | [state] |

### Dependents
[List or "None"]

---

## 2. Income Sources

| Source | Person | Status | Notes |
|--------|--------|--------|-------|
| W-2 Employment | Primary | ✓ | [employer if known] |
| W-2 Employment | Spouse | ✓ | [employer if known] |
| Rental Income | Primary | ✓ | [LLC name] |
| Interest/Dividends | Joint | ✓ | |
| Capital Gains | Joint | ✓ | |
| [etc.] | | | |

### Income Amounts (if Phase 3+)
| Source | Amount |
|--------|--------|
| W-2 (Primary) | $[amount] |
| W-2 (Spouse) | $[amount] |
| Rental Net | $[amount] |
| Dividends/Interest | $[amount] |
| Capital Gains | $[amount] |
| **Estimated AGI** | **$[total]** |

---

## 3. Document Checklist

### Received
| Document | Source | Person |
|----------|--------|--------|
| [form] | [source] | [person] |

### Pending
| Document | Source | Expected By | Where to Get |
|----------|--------|-------------|--------------|
| [form] | [source] | [date] | [provider path] |

### Where to Get Your Documents

For each pending document, include the specific path from `knowledge-base/federal/document-sourcing.yaml`:

**W-2 (Employer)**: Your HR portal → Pay → Tax Documents
**K-1 (LLC)**: Your accountant prepares after partnership files Form 1065
**1099-DIV/B (Fidelity)**: Fidelity.com → Accounts → Tax Forms → Year-End Tax Forms
**1099-DIV/B (Robinhood)**: Robinhood app → Account → Tax Documents
**RSU Statement**: Fidelity NetBenefits → Stock Plans → Tax Information
**Property Tax**: Your county tax assessor's website → Property Tax → View Account

### Not Yet Tracked
[List any documents that should be added]

---

## 4. Tax-Advantaged Accounts

| Account | Person | Status | 2025 Limit |
|---------|--------|--------|------------|
| 401(k) | Primary | Active | $23,500 |
| 401(k) | Spouse | Active | $23,500 |
| HSA | Primary | Active (Family) | $8,550 |
| Roth IRA | Primary | Exists | $7,000 (backdoor) |
| Roth IRA | Spouse | [status] | $7,000 (backdoor) |

### Contribution Gaps (if Phase 3+)
| Account | Limit | Contributed | Gap | Potential Savings |
|---------|-------|-------------|-----|-------------------|
| HSA | $8,550 | $[X] | $[Y] | $[Z] |
| 401k (Primary) | $23,500 | $[X] | $[Y] | $[Z] |
| 401k (Spouse) | $23,500 | $[X] | $[Y] | $[Z] |
| Backdoor Roth | $14,000 | $[X] | $[Y] | (tax-free growth) |

---

## 5. Special Situations

### Rental Property
- **Entity**: [Your LLC]
- **Property**: [Location]
- **Suspended PAL**: Yes — losses blocked by passive activity rules
- **Strategy Note**: Losses release at full disposition

### Equity Compensation
- **Type**: RSUs
- **Employer**: [Employer]
- **Broker**: Fidelity
- **Note**: Check withholding adequacy (RSUs often under-withheld at 22%)

### Multi-State
- **States**: [list or "N/A — single state"]

### Prior Year Carryforwards
- Suspended PAL: [Yes/No]
- Capital Loss Carryforward: [Yes/No]
- NOL Carryforward: [Yes/No]

---

## 6. Opportunities Identified

### High Priority

#### 1. [Strategy Name]
**Finding**: [What we identified]
**Potential Benefit**: [Dollar amount or description]
**Action Required**: [What to do]
**Deadline**: [When]
**IRS Authority**: [Citation]

### Medium Priority

#### 2. [Strategy Name]
...

### For Discussion

#### 3. [Strategy Name]
...

---

## 7. Questions for CPA

1. **[Topic]**: [Specific question]
   - Context: [Why we're asking]

2. **[Topic]**: [Specific question]
   - Context: [Why we're asking]

3. **[Topic]**: [Specific question]
   - Context: [Why we're asking]

---

## 8. Summary & Next Steps

### Key Numbers
| Metric | Value |
|--------|-------|
| Estimated AGI | $[X] |
| Current Bracket | [X]% |
| Bracket Headroom | $[X] to [next]% |
| Total Potential Savings | $[X] |

### Recommended Actions
1. [Action with deadline]
2. [Action with deadline]
3. [Action with deadline]

### Documents Still Needed
- [List pending documents]

---

## Notes

[Space for user to add notes before CPA meeting]

---

*Generated by Tax Pro — an AI tax planning assistant*
*This is planning information, not tax advice. Please review with your CPA.*
```

## Generating the Packet

### Step 1: Read Profile and Knowledge Base
Load all data from:
- `~/.claude/tax-profile.yaml` (user's profile)
- `knowledge-base/federal/document-sourcing.yaml` (where to get documents)
- `knowledge-base/federal/limits-2025.yaml` (contribution limits)
- `knowledge-base/federal/brackets-2025.yaml` (tax brackets)

### Step 2: Match Strategies
For each applicable strategy, include in Opportunities section:
- HSA Maximize (if has_hsa)
- 401k Maximize (if has_401k)
- Backdoor Roth (if high income + has_roth_ira)
- Charitable Bunching (if charitable_donations)
- PAL Planning (if rental_property + suspended_pal)

### Step 3: Generate CPA Questions
Based on special situations:
- Rental + PAL → "What's total suspended PAL? Should we pursue REPS?"
- RSUs → "Is withholding adequate given bracket mismatch?"
- Multi-state → "How should we allocate income between states?"
- Capital gains → "Any tax-loss harvesting opportunities to review?"

### Step 4: Calculate Summaries (if amounts available)
- Sum income sources for estimated AGI
- Determine bracket based on AGI
- Calculate headroom to next bracket
- Sum potential savings from all gaps

### Step 5: Output
Write the packet to a file OR display in conversation:
- If user requests file: Write to `~/Documents/tax-packet-2025.md`
- Otherwise: Display in conversation with markdown formatting

## After Generation

1. **Confirm**: "Tax packet generated! Here's your summary..."
2. **Offer to save**: "Want me to save this to a file?"
3. **Suggest**: "Review this before your CPA meeting. Add notes to Section 8."

## Tone

- Professional — this is for sharing with CPA
- Complete — include all relevant details
- Actionable — clear next steps
- Honest — flag limitations ("estimates only", "confirm with CPA")
