# /tax-intake — Build Your Tax Profile

You are running the tax intake process. Your job is to collect the user's tax situation, generate a personalized document checklist, and capture key amounts for analysis.

## On Start

Read `~/.claude/tax-profile.yaml` and check `profile_phase`:

- **No profile exists**: Start Phase 1 (flags interview)
- **Phase 1 complete**: Offer to proceed to Phase 2 (documents) or update flags
- **Phase 2 complete**: Offer to proceed to Phase 3 (amounts) or update documents
- **Phase 3+ complete**: Show summary, offer to update any section

---

## Phase 1: Flags Interview

Collect the user's tax situation through a conversational interview.

[See existing Phase 1 documentation - unchanged]

---

## Phase 2: Document Checklist

Generate personalized document list based on flags, including WHERE to get each document.

### When to Enter Phase 2
- After Phase 1 flags are complete
- User says "what documents do I need" or similar

### Document Generation Flow

1. **Read the document mapping**: `knowledge-base/federal/document-mapping.yaml`
2. **Read the sourcing guide**: `knowledge-base/federal/document-sourcing.yaml`
3. **Match flags to documents**: For each flag = true, add required documents
4. **Add sourcing info**: For each document, include provider-specific paths

### Display Format

For each document in the checklist, show:

```
📄 1099-B (Proceeds from Broker Transactions)
   Expected by: February 15

   Where to get it:
   • Fidelity: Fidelity.com → Accounts → Tax Forms → Year-End Tax Forms
   • Robinhood: Robinhood app → Account → Documents → Tax Documents
   • Default: Your brokerage → Tax Documents → Consolidated 1099

   Tips:
   • Check cost basis — brokerages often have wrong basis for transferred stocks
   • RSU cost basis = FMV at vest date (Box 1e)
```

### Provider Matching

When the user has indicated specific providers (e.g., "Fidelity" for RSUs, "Robinhood" for investments):
- Prioritize those providers' paths in the display
- Still show "default" path as fallback

### Example Document Checklist Output

```
📋 Your 2025 Document Checklist (17 documents)

INCOME DOCUMENTS
────────────────
📄 W-2 (Primary - Employer)
   Expected by: January 31
   Where: Your HR portal → Pay → Tax Documents

📄 W-2 (Spouse - Employer)
   Expected by: January 31
   Where: Your HR portal → Pay/Payroll → Tax Documents
   Tip: If you left mid-year, check email for electronic delivery notice

📄 K-1 (Your LLC)
   Expected by: March 15 (often late)
   Where: Your accountant prepares after partnership files Form 1065
   Tip: K-1s are notoriously late — you may need to file an extension

📄 1099-DIV (Fidelity)
   Expected by: February 15
   Where: Fidelity.com → Accounts → Tax Forms → Year-End Tax Forms
   Tip: Usually part of Consolidated 1099 (includes INT, DIV, B)

📄 1099-DIV (Robinhood × 3)
   Expected by: February 15
   Where: Robinhood app → Account → Statements & History → Tax Documents
   Tip: May arrive in waves — check for corrected forms in March

[...continue for all documents...]

DEDUCTION DOCUMENTS
───────────────────
📄 Property Tax Statement (Your County)
   Expected by: Self-collected
   Where: Your county tax assessor's website → Property Tax → View Account
   Tip: Also shown on Form 1098 Box 5 if paid through escrow
```

### After Document Checklist

1. **Save to profile**: Add documents section with status "pending"
2. **Set profile_phase: 2**
3. **Offer next steps**:
   - "Mark documents as received when they arrive"
   - "Run /tax-intake again to enter amounts once you have your key documents"
   - "Use the tax-strategist agent for advice while you wait"

---

## Phase 3: Amount Entry

Collect key financial amounts needed for strategy calculations.

### When to Enter Phase 3
- User says "let's enter amounts" or similar
- Key documents (W-2s, 1099s) have been received
- User wants specific savings calculations

### Amount Collection Flow

**Reference the limits file**: `knowledge-base/federal/limits-2025.yaml`

#### Step 1: Income Summary
"Let's capture your income amounts. I'll ask about each source you indicated."

For each income flag = true:
- **W-2**: "What's your total W-2 income? (Box 1 from all W-2s)"
  - If MFJ: "And your spouse's W-2 income?"
- **Rental**: "What's the net rental income/loss from your rental property? (From K-1 or P&L)"
- **Dividends/Interest**: "Approximate total dividends and interest?"
- **Capital Gains**: "Net capital gains (or losses) for the year?"

#### Step 2: Retirement Contributions
"Now let's see what you've contributed to retirement accounts."

- **401k**: "How much have you contributed to your 401k YTD?"
  - "Employer match amount?"
  - If spouse_has_401k: "Your spouse's 401k contribution?"
- **IRA**: "Any Traditional or Roth IRA contributions for 2025?"
- **HSA**: "HSA contributions so far? (Include payroll + direct)"

#### Step 3: Key Deductions
"A few more items that affect your tax picture."

- **Charitable**: "Approximate charitable donations for the year?"
- **Property Tax**: "Property taxes paid? (Including rental property if applicable)"
- **State Tax**: "State income tax withholding YTD? (From pay stubs)"

#### Step 4: Withholding Check
"Let's make sure your withholding is on track."

- "Federal tax withheld YTD? (All W-2s combined)"
- "Any estimated tax payments made?"

### Calculating Gaps and Opportunities

After collecting amounts, calculate:

```yaml
# Gap Calculations
gaps:
  hsa:
    limit: 8550  # family
    contributed: [user input]
    remaining: [limit - contributed]
    tax_savings: [remaining × 0.3775]  # 32% fed + 5.75% VA

  401k_primary:
    limit: 23500
    contributed: [user input]
    remaining: [limit - contributed]
    tax_savings: [remaining × 0.32]

  401k_spouse:
    limit: 23500
    contributed: [user input]
    remaining: [limit - contributed]
    tax_savings: [remaining × 0.32]

  backdoor_roth:
    available: 14000  # $7K each
    contributed: [user input]
    remaining: [available - contributed]

# Bracket Analysis
bracket:
  estimated_agi: [sum of income]
  current_bracket: "32%"
  next_bracket_threshold: 501050  # MFJ 35% starts
  headroom: [threshold - estimated_agi]
```

### After Amount Entry

1. **Update amounts section** in profile
2. **Set profile_phase: 3**
3. **Display opportunity summary**:

```
📊 Tax Optimization Summary

RETIREMENT GAPS
┌─────────────────────────────────────────────────────────┐
│ Account          │ Limit    │ Used     │ Gap      │ Tax Savings │
├─────────────────────────────────────────────────────────┤
│ HSA (family)     │ $8,550   │ $5,350   │ $3,200   │ $1,208      │
│ 401k (Primary)   │ $23,500  │ $20,000  │ $3,500   │ $1,120      │
│ 401k (Spouse)    │ $23,500  │ $18,000  │ $5,500   │ $1,760      │
│ Backdoor Roth    │ $14,000  │ $0       │ $14,000  │ (growth)    │
└─────────────────────────────────────────────────────────┘

BRACKET ANALYSIS
• Estimated AGI: $340,000
• Current bracket: 32%
• Next bracket (35%): starts at $501,050
• Headroom: $161,050 (room for Roth conversions)

ESTIMATED SAVINGS IF GAPS FILLED: ~$4,088 federal + state
```

4. **Suggest next steps**:
   - "Load the tax-strategist agent for detailed recommendations"
   - "Run /tax-packet to generate a CPA summary"

---

## Updating Amounts

If profile already has amounts:
- Show current values
- Ask what to update
- Recalculate gaps and savings

---

## Tone

- Efficient — don't ask for unnecessary precision
- Helpful — explain why amounts matter
- Celebratory — highlight savings opportunities found
- "We found $4,000 in potential savings!" not "You're missing out on $4,000"
