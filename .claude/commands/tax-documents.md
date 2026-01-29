# /tax-documents — Process Tax Documents

You are helping the user extract data from their tax documents (W-2s, 1099s, K-1s, etc.) and populate their tax profile with the amounts.

## How It Works

1. User provides document (image, PDF, or path to file)
2. You read it using Claude's vision/PDF capabilities
3. Extract relevant fields
4. Update `~/.claude/tax-profile.yaml` with the amounts
5. Mark document as "received" in the profile

## On Start

Ask: "What document do you want to process? You can:
- Drag and drop a file into the chat
- Paste a screenshot
- Give me a file path (e.g., `~/Downloads/w2-2025.pdf`)"

## Document Extraction Templates

### W-2 (Wage and Tax Statement)

Extract these boxes:
| Box | Field | Profile Location |
|-----|-------|------------------|
| 1 | Wages, tips, other compensation | `amounts.w2_[person]` |
| 2 | Federal income tax withheld | `amounts.federal_withheld` |
| 3 | Social security wages | (informational) |
| 4 | Social security tax withheld | (informational) |
| 5 | Medicare wages | (informational) |
| 6 | Medicare tax withheld | (informational) |
| 12a-d | Codes (401k contributions, HSA, etc.) | Various |
| 16 | State wages | `amounts.state_wages` |
| 17 | State income tax | `amounts.state_withheld` |

**Box 12 Codes to Watch:**
- D = 401(k) elective deferrals → `amounts.traditional_401k_[person]`
- E = 403(b) contributions
- W = HSA employer contributions → `amounts.hsa_employer`
- AA = Roth 401(k) → `amounts.roth_401k_[person]`
- DD = Health insurance cost (informational)

**After extraction, confirm:**
```
From your W-2 ([Employer Name]):
• Wages (Box 1): $[X]
• Federal withheld (Box 2): $[X]
• 401(k) contributions (Box 12 Code D): $[X]
• State wages (Box 16): $[X]
• State withheld (Box 17): $[X]

Should I add this to your profile?
```

### 1099-DIV (Dividends)

Extract:
| Box | Field | Profile Location |
|-----|-------|------------------|
| 1a | Total ordinary dividends | `amounts.dividends_ordinary` |
| 1b | Qualified dividends | `amounts.dividends_qualified` |
| 2a | Total capital gain distributions | `amounts.cap_gains_distributions` |
| 4 | Federal income tax withheld | Add to `amounts.federal_withheld` |

### 1099-INT (Interest)

Extract:
| Box | Field | Profile Location |
|-----|-------|------------------|
| 1 | Interest income | `amounts.interest` |
| 4 | Federal income tax withheld | Add to `amounts.federal_withheld` |

### 1099-B (Brokerage/Capital Gains)

This is complex. Extract summary totals:
| Section | Field | Profile Location |
|---------|-------|------------------|
| Short-term | Total proceeds | (informational) |
| Short-term | Total cost basis | (informational) |
| Short-term | Net gain/loss | `amounts.cap_gains_short_term` |
| Long-term | Net gain/loss | `amounts.cap_gains_long_term` |

**Note:** For RSUs, verify cost basis is correct (should be FMV at vesting).

### 1099-R (Retirement Distributions)

Extract:
| Box | Field | Notes |
|-----|-------|-------|
| 1 | Gross distribution | |
| 2a | Taxable amount | `amounts.retirement_distributions` |
| 4 | Federal tax withheld | Add to `amounts.federal_withheld` |
| 7 | Distribution code | Important for tax treatment |

**Code 7 meanings:**
- 1 = Early distribution (10% penalty likely)
- 7 = Normal distribution
- G = Direct rollover (not taxable)

### K-1 (Partnership/S-Corp)

Extract from Schedule K-1:
| Line | Field | Profile Location |
|------|-------|------------------|
| 1 | Ordinary business income/loss | `amounts.k1_ordinary` |
| 2 | Net rental income/loss | `amounts.rental_net` |
| 11 | Section 179 deduction | (note for CPA) |
| Various | Self-employment earnings | (if applicable) |

**For rental K-1s, also note:**
- Passive vs non-passive classification
- Any suspended losses from prior years

### 1099-SA (HSA Distributions)

Extract:
| Box | Field | Notes |
|-----|-------|-------|
| 1 | Gross distribution | `amounts.hsa_distributions` |
| 2 | Earnings on excess contributions | (taxable) |
| 3 | Distribution code | 1=normal, 2=excess |

### 1098 (Mortgage Interest)

Extract:
| Box | Field | Profile Location |
|-----|-------|------------------|
| 1 | Mortgage interest received | `amounts.mortgage_interest` |
| 5 | Property taxes | `amounts.property_tax_escrowed` |

### 1098-E (Student Loan Interest)

Extract:
| Box | Field | Profile Location |
|-----|-------|------------------|
| 1 | Student loan interest | `amounts.student_loan_interest` |

## Processing Multiple Documents

If user provides multiple documents:
1. Process each one sequentially
2. Show running totals
3. At the end, show summary:

```
📋 Documents Processed: 4

INCOME
• W-2 (Primary - TechCorp): $180,000
• W-2 (Spouse - Employer): $65,000
• 1099-DIV (Fidelity): $3,200
• 1099-B (Fidelity): $8,400 net gain

WITHHOLDING
• Federal: $52,000
• State: $11,200

RETIREMENT CONTRIBUTIONS
• 401(k) Primary: $23,500
• 401(k) Spouse: $18,000
• HSA: $5,350

Should I update your profile with all of this?
```

## Updating the Profile

After confirmation, update `~/.claude/tax-profile.yaml`:

1. Add amounts to the `amounts:` section
2. Mark documents as received in `documents:` section
3. Update `profile_phase: 3` if amounts are now populated
4. Set `last_updated:` to today

## Security Reminders

- **Don't store the documents** — Extract data, don't save files
- **Don't repeat SSNs** — W-2s have SSNs; ignore them
- **Confirm before saving** — Always show extracted data first
- **Documents stay local** — User's files never touch the repo

## After Processing

Suggest next steps:
- "Run `/tax-packet` to generate your updated CPA document"
- "Load the tax-strategist agent for recommendations based on these numbers"
- "Any more documents to process?"
