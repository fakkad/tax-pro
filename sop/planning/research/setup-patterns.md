# Claude Code Setup Patterns Research

## Research Date: 2026-01-29

---

## Key Repos Analyzed

### 1. claude-config ([sumchattering/claude-config](https://github.com/sumchattering/claude-config))

**Pattern:** Bootstrap script

**How it works:**
1. Clone to `~/claude-config`
2. Edit `bootstrap-config.json` with projects and preferences
3. Run `~/claude-config/bootstrap.sh`

**What bootstrap does:**
- Installs status display tool
- Links config files to system locations
- Merges settings into Claude Code global config
- Creates symlinks for credentials
- Generates `.mcp.json` in repositories
- Updates `.gitignore` files

**Key insight:** One config file, one script, everything set up.

---

### 2. everything-claude-code ([affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code))

**Pattern:** Plugin marketplace + NPX

**Installation options:**
```bash
# Plugin install
/plugin marketplace add affaan-m/everything-claude-code
/plugin install everything-claude-code@everything-claude-code

# Manual install
Copy agents → ~/.claude/agents/
Copy rules → ~/.claude/rules/
Copy commands → ~/.claude/commands/
```

**Structure:**
- `agents/` — Specialized subagents
- `skills/` — Workflow definitions
- `commands/` — Slash commands
- `rules/` — Always-follow guidelines
- `hooks/` — Trigger-based automations

**Key insight:** Plugin system enables one-liner install.

---

### 3. claude-code-showcase ([ChrisWiles/claude-code-showcase](https://github.com/ChrisWiles/claude-code-showcase))

**Pattern:** Standard folder structure with documentation

**Structure:**
```
.claude/
├── settings.json    ← Hooks, environment, permissions
├── agents/          ← Custom AI agents
├── commands/        ← Slash commands
├── hooks/           ← Hook scripts
├── skills/          ← Domain knowledge
└── rules/           ← Modular instructions

CLAUDE.md            ← Project memory
.mcp.json            ← External integrations
```

**Onboarding progression:**
1. Create `.claude` directory
2. Add `CLAUDE.md` with project essentials
3. Configure `settings.json` with hooks
4. Create first skill
5. Add GitHub workflows

**Key insight:** Progressive setup, start simple.

---

### 4. my-claude-code-setup ([centminmod/my-claude-code-setup](https://github.com/centminmod/my-claude-code-setup))

**Pattern:** Memory bank system + example files

**Setup steps:**
1. Copy files to project directory
2. Modify template files and CLAUDE.md
3. Run `/init` to analyze codebase
4. Install faster tools (`brew install ripgrep fd jq`)

**Features:**
- Memory bank system for context retention
- Git worktrees for parallel sessions
- Shell functions for workflow
- Platform support (macOS, Linux, Windows)

**Key insight:** Example files show users what to fill in.

---

## Common Patterns

### 1. Bootstrap Script
Most repos use a shell script that:
- Creates directories
- Copies/symlinks files
- Sets permissions
- Configures settings

### 2. Example/Template Files
```
config.example.yaml  ← Checked into git, shows structure
config.yaml          ← User's actual data, gitignored
```

### 3. Progressive README
```markdown
## Quick Start (2 min)
[minimal steps to get running]

## Full Setup (15 min)
[complete configuration]

## Customization
[optional tweaks]
```

### 4. Standard Folder Structure
Following `.claude/` conventions:
- `agents/` — AI personas
- `commands/` — Slash commands
- `skills/` — Domain knowledge
- `rules/` — Guidelines
- `hooks/` — Automation

### 5. Separation of Concerns
- **Shareable:** Agents, commands, skills, rules, knowledge base
- **Personal:** Config files, credentials, profile data

---

## Recommended Approach for Tax Pro

**Quick Start:**
```bash
git clone https://github.com/[user]/tax-pro
cd tax-pro
./install/setup.sh
```

**What setup.sh does:**
1. Copies agents/commands to `~/.claude/`
2. Creates `~/.claude/tax-profile.yaml` from example
3. Prompts user to edit profile (or run `/tax-intake`)

**Alternative (no script):**
```bash
cp -r .claude/* ~/.claude/
cp install/tax-profile.example.yaml ~/.claude/tax-profile.yaml
# Edit ~/.claude/tax-profile.yaml with your info
```

---

## Sources

- https://github.com/sumchattering/claude-config
- https://github.com/affaan-m/everything-claude-code
- https://github.com/ChrisWiles/claude-code-showcase
- https://github.com/centminmod/my-claude-code-setup
