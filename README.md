# Tax Pro

> **Your AI tax strategist — finds what CPAs miss.**

A Claude Code extension that provides strategic tax planning advice. Built for power users who want deeper analysis than DIY software offers.

Tax Pro is a Claude Code extension that provides strategic tax planning advice. It goes beyond tax filing software to give you the kind of forward-looking, personalized advice that wealthy clients get from expensive advisors.

## What It Does

| Traditional Tax Software | Tax Pro |
|--------------------------|---------|
| "Here's what you owe" | "Here's what you could save" |
| Fills out forms | Finds opportunities |
| Current year only | Multi-year planning |
| Same for everyone | Personalized to your situation |

## Quick Start

### Option 1: Guided Setup (Recommended)

```bash
# Clone the repo
git clone https://github.com/fakkad/tax-pro.git
cd tax-pro

# Run setup
./install/setup.sh
```

### Option 2: Manual Setup

```bash
# Copy Claude Code extensions to your config
cp -r .claude/* ~/.claude/

# Copy the example profile
cp install/tax-profile.example.yaml ~/.claude/tax-profile.yaml

# Edit your profile (or run /tax-intake to do it interactively)
```

## Usage

### 1. Build Your Profile

Run the intake interview to create your tax profile:

```
/tax-intake
```

This asks about your income sources, deductions, and special situations. Takes about 5 minutes.

### 2. Process Your Documents

As your tax documents arrive (W-2s, 1099s, K-1s), process them:

```
/tax-documents
```

Drop a PDF or image, and Claude will:
- Extract the key fields (wages, withholding, contributions)
- Update your profile with the amounts
- Mark the document as received

### 3. Get Strategic Advice

Load the tax strategist agent:

```
Use the tax-strategist agent and review my tax situation
```

You'll get personalized recommendations like:
- "You have $3,200 of unused HSA contribution room — that's $1,024 in tax savings"
- "Consider a Roth conversion — you have bracket headroom before hitting 35%"
- "Your rental property losses are suspended by PAL rules — here's what to discuss with your CPA"

### 4. Generate CPA Packet

When ready for your CPA meeting:

```
/tax-packet
```

Generates a comprehensive document with your situation, opportunities identified, and questions to discuss.

### 5. Update as Needed

Run `/tax-intake` again anytime to update your profile as your situation changes.

## What's Included

```
tax-pro/
├── .claude/
│   ├── agents/tax-strategist.md      # The strategy advisor
│   ├── commands/
│   │   ├── tax-intake.md             # Profile builder
│   │   ├── tax-documents.md          # Document processor (OCR)
│   │   └── tax-packet.md             # CPA prep generator
│   └── rules/tax-security.md         # Data protection rules
├── knowledge-base/
│   ├── federal/                      # Federal rules
│   │   ├── limits-2025.yaml          # Contribution limits
│   │   ├── brackets-2025.yaml        # Tax brackets
│   │   ├── document-mapping.yaml     # What docs you need
│   │   └── document-sourcing.yaml    # WHERE to get them
│   ├── strategies/                   # Tax optimization strategies
│   ├── state/                        # State-specific rules
│   │   ├── VA/                       # Virginia (included)
│   │   └── _TEMPLATE/                # For adding other states
│   ├── probing-questions.yaml        # "Have you considered..."
│   └── expert-rules.yaml             # Non-obvious patterns
├── install/
│   ├── setup.sh                      # Bootstrap script
│   ├── tax-profile.example.yaml      # Profile template
│   └── tax-history.example.yaml      # Prior year template
└── README.md
```

## Data Architecture

Tax Pro separates **personal data** from **shareable code**:

```
YOUR DATA (private, never shared)     THE FRAMEWORK (shareable, open source)
─────────────────────────────────     ──────────────────────────────────────
~/.claude/tax-profile.yaml            tax-pro/knowledge-base/*
~/.claude/tax-history.yaml            tax-pro/.claude/agents/*
~/Documents/tax-packet-2025.md        tax-pro/.claude/commands/*
                                      tax-pro/install/*.example.yaml
```

### Why This Matters

| Your Data | Framework Code |
|-----------|----------------|
| Your income, employer names | Tax brackets, contribution limits |
| Your account balances | Strategy logic ("if X, consider Y") |
| Your CPA prep documents | Document checklists, interview flows |
| **Lives in `~/.claude/`** | **Lives in repo, shareable** |

### Privacy Guarantees

- **Your data stays local** — Profile stored in `~/.claude/`, never in the repo
- **No SSNs needed** — We track structure, not sensitive identifiers
- **Git-safe** — `.gitignore` prevents accidental commits
- **Delete anytime** — Remove `~/.claude/tax-profile.yaml` to clear your data

## What This Is NOT

- ❌ Tax filing software (use TurboTax, FreeTaxUSA, etc. for that)
- ❌ Legal advice (consult a tax attorney for entity decisions)
- ❌ CPA replacement (we help you prepare for your CPA, not replace them)
- ❌ Guaranteed savings (all estimates are just that — estimates)

## Requirements

- [Claude Code](https://claude.ai/code) CLI installed
- macOS, Linux, or WSL on Windows

## Contributing

Contributions welcome! Here's what you can add:

### What to Contribute

| Type | Location | Example |
|------|----------|---------|
| New strategies | `knowledge-base/strategies/` | ESPP optimization, AMT planning |
| State rules | `knowledge-base/state/[ST]/` | California-specific deductions |
| Probing questions | `knowledge-base/probing-questions.yaml` | New "have you considered..." patterns |
| Expert rules | `knowledge-base/expert-rules.yaml` | Non-obvious tax interactions |
| Bug fixes | Anywhere | Typos, incorrect limits, broken logic |

### Rules for Contributors

**The golden rule: No personal data in code.**

When writing strategies or examples:

```yaml
# ✅ DO: Use placeholders
example:
  name: "Alex Smith"
  income: 150000
  employer: "Tech Company"

# ❌ DON'T: Use real data
example:
  name: "John Doe"          # Real name!
  income: 350000            # Real amount!
  employer: "BigCorp"       # Tied to real person!
```

### Before Submitting a PR

1. [ ] No real names, employers, or amounts in code
2. [ ] Examples use generic placeholders
3. [ ] `git diff` shows no files from `~/.claude/`
4. [ ] New strategies include IRS citations
5. [ ] Test with your own profile (which stays in `~/.claude/`)

## License

MIT License — Use freely, no warranty provided. Tax advice should be verified with a qualified professional.
