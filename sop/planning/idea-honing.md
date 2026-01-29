# Tax Pro — Requirements Clarification

## Process
One question at a time. Answers appended as we go.

---

## Q1: Who is the primary target user?

**Options to consider:**
- A) **DIY filers** who currently use TurboTax/FreeTaxUSA and want better strategy
- B) **People with CPAs** who want to show up prepared with strategic questions
- C) **High earners** ($200K+) with complex situations (rental property, equity comp, multi-state)
- D) **Self-employed/1099** workers who need deduction tracking + entity strategy
- E) **All of the above** (start broad, refine later)
- F) **Something else**

**Why this matters:** Determines complexity of intake, strategy depth, and whether we're replacing TurboTax or complementing a CPA relationship.

---

**A1:** E (all of the above), but **start with A (DIY filers)** as the MVP. Layer on complexity for B/C/D over time.

**Additional context:** This doesn't need to be a standalone app. Can run in Claude Code via prompting, agent profiles, slash commands, etc. Open to ideas on best implementation approach.

---

## Q2: What's the right technical form factor for Claude Code?

**Options to consider:**

| Option | How It Works | Pros | Cons |
|--------|--------------|------|------|
| **A** | **Agent profile** (`~/.claude/agents/tax-strategist.md`) | Loads context automatically, fits existing workflow | Static, no interactive intake |
| **B** | **Slash command** (`/tax-planning`) | Interactive, can run intake interview | One-off, doesn't persist state |
| **C** | **Project folder** with knowledge base + profile | Structured, shareable, version-controlled | Requires "resume project" to use |
| **D** | **Hybrid**: Profile schema (YAML) + slash command for intake + agent for strategy | Best of all worlds | More complex to build |
| **E** | **MCP server** (custom) | Could integrate with external data, APIs | Overkill for MVP, harder to share |
| **F** | **Something else** | Describe |

**My instinct:** Option D (Hybrid) feels right:
1. `/tax-intake` command runs interview → outputs `tax-profile.yaml`
2. `tax-strategist.md` agent reads profile + knowledge base → gives strategic advice
3. Knowledge base is shareable, profile is personal (gitignored)

But I want to hear your thinking. What feels right to you?

---

**A2:** D (Hybrid) — with structure based on popular Claude Code setup repos.

**Researched patterns from:**
- [claude-config](https://github.com/sumchattering/claude-config) — Bootstrap script pattern
- [everything-claude-code](https://github.com/affaan-m/everything-claude-code) — Plugin/NPX install pattern
- [claude-code-showcase](https://github.com/ChrisWiles/claude-code-showcase) — Standard folder structure
- [my-claude-code-setup](https://github.com/centminmod/my-claude-code-setup) — Example files pattern

**Agreed structure:**
```
tax-pro/
├── README.md                      ← Quick start + full setup
├── SYSTEM.md                      ← How it all works
├── install/
│   ├── setup.sh                   ← Bootstrap script
│   └── tax-profile.example.yaml   ← Template profile
├── .claude/
│   ├── agents/tax-strategist.md   ← Main agent
│   ├── commands/
│   │   ├── tax-intake.md          ← Interactive profile builder
│   │   └── tax-packet.md          ← Generate CPA prep doc
│   ├── skills/tax-planning.md     ← Domain knowledge pointer
│   └── rules/tax-security.md      ← Never commit financial data
├── knowledge-base/                ← Shareable tax rules
└── .gitignore
```

**User flow:**
1. Clone repo
2. Run `./install/setup.sh` (or manual copy)
3. Edit `tax-profile.yaml` (or run `/tax-intake`)
4. Use: "Load tax-strategist agent" or `/tax-packet`

---

## Q3: What should the tax-profile.yaml schema include?

Based on research (IRS Form 13614-C, TurboTax intake, competitive analysis), here's a proposed schema. What's missing or unnecessary?

```yaml
# tax-profile.yaml — Your tax situation
# Edit this file or run /tax-intake to generate

profile_version: "1.0"
tax_year: 2025

# ============================================
# SECTION 1: PERSONAL INFO
# ============================================
personal:
  filing_status: married_filing_jointly  # single, married_filing_jointly, married_filing_separately, head_of_household, qualifying_surviving_spouse

  primary:
    name: ""
    state_of_residence: ""
    occupation: ""

  spouse:  # Remove if single
    name: ""
    state_of_residence: ""
    occupation: ""

  dependents: []  # List of {name, relationship, age}

# ============================================
# SECTION 2: INCOME SOURCES (check all that apply)
# ============================================
income:
  w2_employment: true
  self_employment_1099: false
  rental_income: false
  interest_dividends: true
  capital_gains: false
  retirement_distributions: false
  social_security: false
  unemployment: false
  other: []

# ============================================
# SECTION 3: DEDUCTIONS & ACCOUNTS
# ============================================
deductions:
  retirement:
    has_401k: true
    has_ira: false
    has_hsa: true
    hsa_coverage: family  # self_only, family

  itemized:
    mortgage_interest: false
    state_local_taxes: true
    charitable_donations: true
    medical_expenses: false

  other:
    student_loan_interest: false
    educator_expenses: false

# ============================================
# SECTION 4: TAX SITUATIONS (special circumstances)
# ============================================
situations:
  multi_state: true
  states_involved: ["VA", "DC"]

  equity_compensation: false  # RSUs, ISOs, ESPP
  crypto_transactions: false
  foreign_income: false
  rental_property: true
  home_sale: false

  prior_year:
    suspended_pal_losses: false
    carryforward_losses: false

# ============================================
# SECTION 5: GOALS (what do you want to optimize?)
# ============================================
goals:
  - reduce_current_year_taxes
  - maximize_retirement_savings
  - plan_for_next_year

# ============================================
# SECTION 6: INTEGRATIONS (optional)
# ============================================
integrations:
  monarch_connected: false
  documents_folder: ""  # Path to tax documents
```

**Questions:**
- Is this too complex for MVP?
- What's missing?
- What would you remove?

---

**A3:** Not too complex — think big. Key enhancements:

1. **Phased data collection** — Don't overwhelm users upfront:
   - Phase 1: Boolean flags (what applies to you?)
   - Phase 2: Document checklist (personalized based on flags)
   - Phase 3: Amount extraction (from documents)
   - Phase 4: Analysis (opportunities, CPA questions)

2. **Official amounts over manual entry** — Prefer document extraction over user typing numbers. More accurate, less work.

3. **Dynamic state research** — Don't hardcode 50 states. Claude researches state-specific rules on-demand.

4. **Authoritative sources** — All advice cites IRS authority hierarchy (IRC > Treasury Regs > IRS Pubs > Revenue Rulings)

5. **Elite tax professional methodology** — The analysis persona should embody how top CPAs think, not just form-filling.

See research documents created:
- `research/authoritative-sources.md` — IRS source hierarchy
- `research/tax-professional-methodology.md` — Elite CPA methodology
- `design/tax-strategist-agent.md` — Agent persona design

---

## Q4: What should the document intake flow look like?

Based on the phased approach, the user's flags in Phase 1 determine which documents to expect in Phase 2. Here's a proposed mapping:

### Flag → Documents Mapping

| If flag is TRUE | Expect these documents |
|-----------------|------------------------|
| `w2_employment` | W-2 (one per employer, per person) |
| `self_employment_1099` | 1099-NEC, 1099-MISC, 1099-K |
| `interest_dividends` | 1099-INT, 1099-DIV |
| `capital_gains` | 1099-B, Cost basis statements |
| `retirement_distributions` | 1099-R |
| `rental_income` | 1099-MISC (if reported), Profit/Loss statement |
| `mortgage_interest` | 1098 |
| `student_loan_interest` | 1098-E |
| `has_hsa` | 1099-SA, 5498-SA |
| `charitable_donations` | Donation receipts, 1098-C (vehicle) |
| `crypto_transactions` | Exchange statements (Coinbase, etc.) |
| `equity_compensation` | 3921 (ISO), 3922 (ESPP), RSU statements |

### Timing & Reminders

| Document | Typically available by |
|----------|------------------------|
| W-2 | January 31 |
| 1099-INT/DIV/B | February 15 |
| 1099-NEC/MISC | January 31 |
| 1098 (mortgage) | January 31 |
| K-1 (partnerships) | March 15 (often later) |

### Document Status Tracking

```yaml
documents:
  - form: W-2
    source: Employer
    person: primary
    expected_by: 2026-01-31
    status: received    # pending, received, not_applicable
    file_path: "~/tax-docs/2025/w2-employer.pdf"
    amounts_extracted: true
```

**Questions:**
- Should we support document upload/parsing via MCP (Playwright for scraping, or file reading)?
- How should we handle the "waiting for documents" phase?

---

**A4:** Approved. Key decisions:

1. **Flags → checklist**: Yes, use the mapping table above
2. **Waiting phase**: Status tracking per document with expected dates, dashboard view in `/tax-intake`
3. **Document parsing**: MVP = manual entry. Later = file reading/Playwright. Don't block on this.

---

## Requirements Complete — Moving to Design

All core requirements clarified:
- **Q1**: Target DIY filers first, expand later
- **Q2**: Hybrid technical form (command + profile + agent)
- **Q3**: Phased collection, authoritative sources, elite CPA methodology
- **Q4**: Flags → personalized checklist, status tracking, manual entry MVP

**Next**: Full profile schema design in `design/profile-schema.md`
