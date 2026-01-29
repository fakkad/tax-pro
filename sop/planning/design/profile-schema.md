# Tax Profile Schema Design

## Overview

The `tax-profile.yaml` file stores the user's complete tax situation. Data is collected in **four phases** to avoid overwhelming new users while enabling deep analysis for returning users.

---

## Phase Model

```
Phase 1: FLAGS          "What applies to you?" (5 min)
    ↓
Phase 2: DOCUMENTS      "Here's what we need" (ongoing)
    ↓
Phase 3: AMOUNTS        "Numbers from your docs" (as received)
    ↓
Phase 4: ANALYSIS       "Here's what we found" (generated)
```

The `profile_phase` field tracks where the user is:
- `1` = Just started, only flags filled
- `2` = Documents checklist generated, collecting
- `3` = Key amounts entered, ready for analysis
- `4` = Analysis complete, opportunities identified

---

## Full Schema

```yaml
# =============================================================================
# TAX-PROFILE.YAML — Your tax situation
# =============================================================================
# This file is PERSONAL and should NOT be committed to git.
# Run /tax-intake to generate or update this file.
# =============================================================================

profile_version: "1.0"
tax_year: 2025
profile_phase: 1  # 1=flags, 2=documents, 3=amounts, 4=analysis
last_updated: "2026-01-29"

# =============================================================================
# PHASE 1: PERSONAL INFO + FLAGS
# =============================================================================
# Collected via quick interview. Determines document checklist.

personal:
  filing_status: married_filing_jointly
  # Options: single, married_filing_jointly, married_filing_separately,
  #          head_of_household, qualifying_surviving_spouse

  primary:
    name: ""
    state_of_residence: ""  # Two-letter code (VA, CA, etc.)
    occupation: ""
    date_of_birth: ""       # For age-based rules (catch-up, RMDs)

  spouse:  # Omit section if single
    name: ""
    state_of_residence: ""
    occupation: ""
    date_of_birth: ""

  dependents: []
  # Example:
  # - name: "Child Name"
  #   relationship: child  # child, parent, other
  #   date_of_birth: "2015-03-15"
  #   student: false
  #   disabled: false

# -----------------------------------------------------------------------------
# Income Flags (check all that apply)
# -----------------------------------------------------------------------------
income_flags:
  w2_employment: true
  self_employment_1099: false
  rental_income: false
  interest_dividends: true
  capital_gains: false
  retirement_distributions: false
  social_security: false
  unemployment: false
  alimony_received: false
  gambling_winnings: false
  other: []  # Free-form list

# -----------------------------------------------------------------------------
# Deduction & Account Flags
# -----------------------------------------------------------------------------
deduction_flags:
  # Retirement accounts
  has_401k: true
  has_403b: false
  has_457: false
  has_traditional_ira: false
  has_roth_ira: true
  has_sep_ira: false
  has_solo_401k: false

  # Health accounts
  has_hsa: true
  hsa_coverage: family  # self_only, family
  has_fsa: false

  # Itemized deductions
  mortgage_interest: false
  home_equity_loan: false
  state_local_taxes: true
  property_taxes: true
  charitable_donations: true
  medical_expenses: false

  # Other deductions
  student_loan_interest: false
  educator_expenses: false
  home_office: false

# -----------------------------------------------------------------------------
# Special Situations Flags
# -----------------------------------------------------------------------------
situation_flags:
  multi_state: true
  states_involved: ["VA", "DC"]

  equity_compensation: false  # RSUs, ISOs, ESPP, NQSOs
  equity_types: []  # [rsu, iso, espp, nqso]

  crypto_transactions: false
  foreign_income: false
  foreign_accounts: false  # FBAR requirement

  rental_property: true
  num_rental_properties: 1

  home_sale: false
  business_ownership: false
  business_entity_type: ""  # sole_prop, llc, s_corp, c_corp, partnership

  prior_year:
    suspended_pal_losses: false
    capital_loss_carryforward: false
    nol_carryforward: false
    amt_credit_carryforward: false

# -----------------------------------------------------------------------------
# Life Events (This Year)
# -----------------------------------------------------------------------------
life_events:
  married: false
  divorced: false
  had_child: false
  child_turned_17: false  # Affects child tax credit
  child_turned_24: false  # Affects dependent status if student
  bought_home: false
  sold_home: false
  started_business: false
  changed_jobs: false
  retired: false
  turned_55: false   # HSA catch-up
  turned_59_5: false # Penalty-free IRA
  turned_65: false   # Medicare
  turned_73: false   # RMD start

# =============================================================================
# PHASE 2: DOCUMENTS
# =============================================================================
# Generated from flags. Tracks what's needed vs received.

documents:
  # Example entries — populated by /tax-intake based on flags
  - form: W-2
    source: "Employer"
    person: primary
    expected_by: "2026-01-31"
    status: pending  # pending, received, not_applicable, not_expected
    file_path: ""
    notes: ""

  - form: 1099-DIV
    source: "Fidelity"
    person: primary
    expected_by: "2026-02-15"
    status: pending
    file_path: ""
    notes: ""

  - form: 1098
    source: "Mortgage Lender"
    person: joint
    expected_by: "2026-01-31"
    status: not_applicable  # No mortgage
    file_path: ""
    notes: ""

  # K-1s often arrive late
  - form: K-1
    source: "Rental LLC"
    person: primary
    expected_by: "2026-03-15"
    status: pending
    notes: "Usually arrives late March"

# =============================================================================
# PHASE 3: AMOUNTS
# =============================================================================
# Extracted from documents. Used for analysis calculations.

amounts:
  income:
    # W-2 income
    w2_primary: 0
    w2_spouse: 0
    w2_total: 0

    # Self-employment
    self_employment_gross: 0
    self_employment_expenses: 0
    self_employment_net: 0

    # Investments
    interest: 0
    qualified_dividends: 0
    ordinary_dividends: 0
    short_term_gains: 0
    long_term_gains: 0

    # Rental
    rental_gross: 0
    rental_expenses: 0
    rental_depreciation: 0
    rental_net: 0

    # Other
    retirement_distributions: 0
    social_security: 0
    other_income: 0

  deductions:
    # Retirement contributions (YTD + planned)
    contrib_401k_primary: 0
    contrib_401k_spouse: 0
    contrib_401k_employer_match: 0
    contrib_ira_traditional: 0
    contrib_ira_roth: 0
    contrib_hsa: 0

    # Itemized
    mortgage_interest: 0
    state_local_taxes_paid: 0
    property_taxes: 0
    charitable_cash: 0
    charitable_non_cash: 0
    medical_expenses: 0

    # Above-the-line
    student_loan_interest: 0
    educator_expenses: 0
    self_employment_deductions: 0

  limits:
    # Current year limits (for gap analysis)
    limit_401k: 23500      # 2025 limit
    limit_401k_catchup: 7500
    limit_ira: 7000
    limit_ira_catchup: 1000
    limit_hsa_self: 4300
    limit_hsa_family: 8550
    limit_hsa_catchup: 1000

  withholding:
    federal_withheld: 0
    state_withheld: 0
    estimated_payments: 0
    extension_payment: 0

  carryforwards:
    suspended_pal: 0
    capital_loss: 0
    nol: 0
    amt_credit: 0

# =============================================================================
# PHASE 4: ANALYSIS
# =============================================================================
# Generated by tax-strategist agent. Refreshed on demand.

analysis:
  last_run: ""
  estimated_agi: 0
  estimated_taxable_income: 0
  estimated_bracket: ""  # "32%", "24%", etc.
  estimated_federal_tax: 0
  estimated_state_tax: 0
  effective_rate: 0

  # Opportunities identified
  opportunities:
    - id: hsa_gap
      priority: high  # high, medium, low
      category: retirement  # retirement, deduction, timing, entity, credit, state
      title: "HSA Under-Contribution"
      finding: "You've contributed $5,350 to HSA but limit is $8,550 (family)"
      action: "Contribute additional $3,200 before April 15, 2026"
      estimated_savings: 1024
      deadline: "2026-04-15"
      source: "IRC § 223, IRS Pub 969"
      status: open  # open, in_progress, completed, declined

    - id: roth_conversion
      priority: medium
      category: retirement
      title: "Roth Conversion Opportunity"
      finding: "You have $8,000 of bracket headroom before hitting 35%"
      action: "Consider converting $8,000 from Traditional to Roth IRA"
      estimated_savings: 0  # Tax now, but future benefit
      deadline: "2025-12-31"
      source: "IRC § 408A"
      status: open

  # Questions to discuss with CPA
  questions_for_cpa:
    - question: "Should we pursue real estate professional status for PAL release?"
      context: "Suspended losses from rental LLC"
      priority: high

    - question: "Is cost segregation worthwhile for the rental property?"
      context: "Accelerated depreciation could offset other income"
      priority: medium

  # Risks or concerns
  flags:
    - type: audit_risk
      description: "Home office deduction with W-2 income"
      severity: low

    - type: deadline
      description: "Q4 estimated payment due Jan 15"
      severity: high

# =============================================================================
# INTEGRATIONS
# =============================================================================

integrations:
  monarch:
    connected: false
    last_sync: ""
    account_ids: []  # For filtering transactions

  documents_folder: ""  # Path to tax documents (e.g., ~/Documents/Tax/2025/)
```

---

## Phase Transitions

### Flags → Documents (1 → 2)
When user completes `/tax-intake` flags section:
1. Generate personalized `documents` array based on flags
2. Set `profile_phase: 2`
3. Show document checklist dashboard

### Documents → Amounts (2 → 3)
When key documents received (W-2s, 1099s):
1. Prompt user to enter amounts OR parse from files
2. Populate `amounts` section
3. Set `profile_phase: 3`

### Amounts → Analysis (3 → 4)
When user requests analysis (loads tax-strategist agent):
1. Calculate estimated AGI, bracket, tax
2. Run strategy matching
3. Populate `opportunities`, `questions_for_cpa`, `flags`
4. Set `profile_phase: 4`

---

## Security Notes

1. **Never commit this file** — `.gitignore` must include `tax-profile.yaml`
2. **No SSNs or account numbers** — Profile has structure, not PII
3. **File paths are local** — Don't sync to cloud without encryption
4. **Clear on uninstall** — User can delete `~/.claude/tax-profile.yaml`

---

## Example: Minimal New User

```yaml
profile_version: "1.0"
tax_year: 2025
profile_phase: 1
last_updated: "2026-01-29"

personal:
  filing_status: single
  primary:
    name: "New User"
    state_of_residence: "CA"

income_flags:
  w2_employment: true
  interest_dividends: true

deduction_flags:
  has_401k: true
  has_hsa: false

situation_flags:
  multi_state: false

life_events: {}

documents: []
amounts: {}
analysis: {}
integrations: {}
```

---

## Example: Power User (Phase 4)

See full schema above — all sections populated, opportunities identified, CPA questions generated.
