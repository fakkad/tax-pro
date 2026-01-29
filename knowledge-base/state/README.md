# State Tax Rules

This directory contains state-specific tax rules and strategies.

## Structure

```
state/
├── _TEMPLATE/           # Copy this to add a new state
│   ├── overview.yaml    # Tax structure, brackets, deadlines
│   └── strategies.yaml  # State-specific strategies
├── VA/                  # Virginia (example)
│   ├── overview.yaml
│   └── strategies.yaml
└── README.md            # This file
```

## Adding a New State

### 1. Create the directory

```bash
mkdir knowledge-base/state/[ST]
```

Use the two-letter state code (CA, NY, TX, etc.).

### 2. Copy the templates

```bash
cp knowledge-base/state/_TEMPLATE/*.yaml knowledge-base/state/[ST]/
```

### 3. Fill in the overview

Edit `overview.yaml` with:
- Tax structure (graduated, flat, or none)
- Tax brackets and rates
- Standard deduction amounts
- Federal conformity rules
- Key deadlines
- Notable features

### 4. Add strategies

Edit `strategies.yaml` with:
- State-specific deductions
- State-specific credits
- State-specific planning opportunities
- Probing questions for that state

## What Makes a Good State Entry

### Overview should include:

| Section | Why It Matters |
|---------|----------------|
| Tax brackets | Calculate state tax liability |
| Federal conformity | Know what carries over from federal |
| Deadlines | Avoid late filing penalties |
| Notable features | Surface unique opportunities |

### Strategies should include:

| Element | Example |
|---------|---------|
| Applicable conditions | "If you have children AND live in CA" |
| Benefit type | Deduction, credit, subtraction |
| Dollar impact | "$4,000 deduction = $400 savings" |
| Action steps | Concrete "do this" instructions |
| Source citation | State code reference |

## States with No Income Tax

For states with no income tax (TX, FL, WA, WY, NV, SD, AK, TN, NH*):

```yaml
tax_structure:
  type: none
  notes: "[State] has no state income tax"
```

Still worth documenting:
- Other taxes (property, sales, franchise)
- Residency rules (if moving from high-tax state)
- Any exceptions (e.g., NH taxes dividends/interest only)

## High-Priority States to Add

Based on population and tax complexity:

| State | Priority | Notes |
|-------|----------|-------|
| CA | High | Complex, high rates, many unique rules |
| NY | High | State + NYC taxes, complex |
| TX | Medium | No income tax, but other considerations |
| FL | Medium | No income tax, residency popular |
| IL | Medium | Flat tax, straightforward |
| NJ | Medium | High rates, complex |
| MA | Medium | Flat tax with nuances |
| PA | Low | Flat tax, relatively simple |

## Using State Rules in the Agent

The tax-strategist agent should:

1. Check the user's `state_of_residence` from their profile
2. Load `knowledge-base/state/[ST]/` if it exists
3. Include state-specific strategies in recommendations
4. Surface state-specific probing questions
5. Note state deadlines (especially if different from federal)

If no state rules exist, the agent should:
- Note that state-specific advice is limited
- Recommend the user research their state's rules
- Still provide federal-level advice

## Contributing State Rules

When adding a new state:

1. Research from official state tax authority website
2. Include source citations for all rules
3. Test with example scenarios
4. Submit PR with state code as branch name (e.g., `add-state-CA`)

### Research Sources

| State | Tax Authority |
|-------|---------------|
| CA | [Franchise Tax Board](https://www.ftb.ca.gov/) |
| NY | [NY Tax Dept](https://www.tax.ny.gov/) |
| TX | [Comptroller](https://comptroller.texas.gov/) |
| FL | [Dept of Revenue](https://floridarevenue.com/) |

## Example: Virginia

See `VA/` for a complete example including:
- Graduated tax brackets (2%, 3%, 5%, 5.75%)
- Virginia 529 deduction
- May 1 filing deadline (not April 15!)
- Retirement income subtraction
- VA vs DC residence comparison
