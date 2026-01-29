# Tax Security Rules

## The Golden Rule

**Personal data lives in YAML files in `~/.claude/`. Everything else is shareable.**

```
PERSONAL (never commit)              SHAREABLE (commit freely)
─────────────────────────            ────────────────────────
~/.claude/tax-profile.yaml           knowledge-base/*
~/.claude/tax-history.yaml           .claude/agents/*
~/Documents/tax-packet-*.md          .claude/commands/*
                                     .claude/rules/*
                                     install/*.example.yaml
```

## What Goes Where

### Personal Data → `~/.claude/` (NEVER in repo)

| Data Type | Location | Example |
|-----------|----------|---------|
| Tax profile | `~/.claude/tax-profile.yaml` | Income amounts, employer names |
| Tax history | `~/.claude/tax-history.yaml` | Prior year AGI, carryforwards |
| Generated packets | `~/Documents/tax-packet-*.md` | CPA prep documents |

### Shareable Code → Repo (safe to commit)

| Content Type | Location | Example |
|--------------|----------|---------|
| Tax rules | `knowledge-base/federal/` | Limits, brackets, document mapping |
| Strategies | `knowledge-base/strategies/` | HSA maximize, backdoor Roth |
| Agent logic | `.claude/agents/` | How to analyze profiles |
| Commands | `.claude/commands/` | Interview flows |
| Templates | `install/*.example.yaml` | Blank profile structure |

## Rules for Writing Code

### In Strategy Files, Commands, and Agents

**DO use placeholders:**
```markdown
If your AGI is $[X], you're in the [Y]% bracket...
At 32% federal + [state]% state, your combined rate is...
```

**DON'T use real values:**
```markdown
❌ If your AGI is $350,000 like John...
❌ Your employer BigCorp uses Fidelity for...
```

### In Examples and Documentation

**DO use realistic but fake examples:**
```yaml
# Example profile (not real)
personal:
  primary:
    name: "Alex Smith"
    occupation: "Software Engineer"
amounts:
  w2_primary: 150000
```

**DON'T copy from real profiles:**
```yaml
❌ personal:
❌   primary:
❌     name: "John Smith"  # Real name!
```

## Never Store These (Anywhere)

| Data | Why |
|------|-----|
| Social Security Numbers | Never needed for tax strategy |
| Bank account numbers | Not relevant to planning |
| Credit card numbers | Not relevant to planning |
| Full addresses | City/state is enough |
| Employer EINs | Not needed |

## Pre-Commit Checklist

Before every commit, verify:

1. [ ] `git status` shows NO files from `~/.claude/`
2. [ ] No real names in strategy files or examples
3. [ ] No dollar amounts that look like real data
4. [ ] No employer names tied to specific people
5. [ ] Example YAMLs use placeholder values

## If You See Personal Data in Code

If you notice personal data accidentally in a file:

1. **Remove it immediately** — Replace with placeholder
2. **Check git history** — If committed, consider rewriting history
3. **Don't spread it** — Don't copy to other files
4. **Notify owner** — If it's not your data

## If a User Shares Sensitive Data in Chat

1. Don't repeat it back verbatim
2. Don't store it in any file
3. Use it for the conversation, then forget it
4. Suggest they review chat history if concerned
5. Continue working with structure, not raw PII

## Testing with Real Profiles

When testing with your own profile:

1. Keep `tax-profile.yaml` in `~/.claude/` (already gitignored)
2. Run commands normally — they read from `~/.claude/`
3. Generated outputs go to `~/Documents/` (also not in repo)
4. Nothing personal ever touches the repo directory
