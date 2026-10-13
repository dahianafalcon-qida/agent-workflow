# 🤖 Agent Workflows Framework

A lightweight, portable architecture for orchestrating **AI Coding Agents (Claude Code / Cursor)** in multi-repository setups.

This framework decouples high-level architectural planning on the host machine from isolated, runtime-bound execution inside **DevContainers**.

---

## 🏛️ Architecture Overview

```text
┌─────────────────────────────────────────────────────────────────────────┐
│ HOST MACHINE (ad-parent Workspace)                                      │
│                                                                         │
│  [ Parent Orchestrator Agent ]                                         │
│   ├── Reads global architecture & domain context                        │
│   ├── Inspects company ADRs via `gh` CLI                                │
│   ├── Publishes accepted plans to Jira (Parent User Story & Subtasks)   │
│   └── Generates task directories & contracts for child modules          │
└────────────────────┬────────────────────────────────────────────────────┘
                     │ Writes task directory & contracts
                     ▼ `.claude/implementations/<SUBTASK-ID>-<keyword>/`
┌─────────────────────────────────────────────────────────────────────────┐
│ DEVCONTAINER (e.g., ad-backend-quotation Submodule)                     │
│                                                                         │
│  [ Child Execution Agent ]                                              │
│   ├── Runs inside Docker / DevContainer runtime (Python, Pytest, etc.)  │
│   ├── Operates in Direct or Planned mode                                │
│   ├── Reads `implementation.md` & co-located specs (Swagger, JSONs)     │
│   ├── Follows Add -> Migrate -> Remove refactoring pattern              │
│   └── Validates Black-Box Test Contracts (No tailored assertions)       │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 📁 Repository Structure

```text
agent-workflows/
├── README.md                           # Framework documentation
├── setup.sh                            # Workspace initialization script
├── templates/
│   └── implementation-template.md      # Task contract & execution log template
└── rules/
    ├── orchestrator.md                 # Rules for the Host / Parent Orchestrator
    └── container.md                    # Rules for DevContainer / Child Agents
```

---

## ⚡ Setup & Installation

The `setup.sh` script initializes target workspace directories by copying the appropriate parent and child agent rules and preparing task workspace folders.

### 1. Clone your personal workflows repository

```bash
git clone git@github.com:your-username/agent-workflows.git ~/agent-workflows
```

### 2. Configure target submodules in `setup.sh`

Open `setup.sh` and update the `CHILD_MODULES` array with your workspace submodules:

```bash
CHILD_MODULES=(
  "ad-backend-quotation"
  "ad-frontend-dashboard"
  "ad-service-notifications"
)
```

### 3. Run the setup script targeting your workspace

```bash
# Navigate to your workspace root or pass it as an argument
~/agent-workflows/setup.sh ~/projects/ad-parent
```

The script will:

- Copy `parent-orchestrator.md` to `.claude/rules.md` in the root workspace.
- Copy `implementation-template.md` to `design/templates/` in the root workspace.
- Iterate over each directory in `CHILD_MODULES` to create `.claude/implementations/` and copy `child-container.md` into `.claude/rules.md`.

---

## 📌 Reminder: Git Ignore Configuration

The `setup.sh` script **does not alter your Git configuration or edit repository files**.

To prevent local agent rules, temporary workspace files, and implementation logs from being accidentally committed to company repositories, manually add the following entries to `.git/info/exclude` (for local-only ignores) or the respective `.gitignore` files:

### In Root Workspace (`ad-parent`)

```gitignore
.claude/rules.md
```

### In Each Submodule Directory (`ad-backend-quotation`, etc.)

```gitignore
.claude/rules.md
.claude/implementations/
```

---

## 🔄 Daily Workflows

### 1. Fully Autonomous Mode (Standard for Complex Features)

1. **Design & Iterate:** Collaborate with the **Parent Agent** in `ad-parent`. It checks global ADRs via `gh` CLI and drafts the full architecture plan.
2. **Accept Plan:** Upon your explicit acceptance, the Parent Agent automatically executes the following atomic sequence:
   - **Jira Story Sync:** Posts the master design as a comment on the Parent User Story (`<JIRA-PARENT-ID>`).
   - **Workspace Creation:** Creates `.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/` in the target submodule.
   - **Contract Generation:** Populates `implementation.md` and generates supporting specs (e.g., `swagger.yaml`).
   - **Autonomous Execution:** Triggers the Child Agent inside the DevContainer via `docker exec`.
   - **Automatic Inspection & Closure:** Waits for execution completion, reads Sections 4 & 5 of `implementation.md`, and posts the completion log as a closing comment on the Jira Technical Subtask (`<JIRA-SUBTASK-ID>`).

### 2. Direct Work Mode (Quick Fixes, Manual Tasks & Pair Programming)

- Work directly inside the **DevContainer terminal** (`ad-backend-quotation`).
- Bypasses the Parent Agent, `docker exec`, and formal `.md` plans entirely.
- The Child Agent acts as a direct pair programmer for quick bug fixes, refactoring, or writing unit tests for existing code without needing formal contracts.

---

## 🛡️ Core Rules & Safety Guarantees

- **Live-Reload Preservation:** Code refactoring strictly follows the **Add $\rightarrow$ Migrate $\rightarrow$ Remove** sequence to avoid crashing active development servers (`uvicorn`, `django`, etc.) mid-task.
- **Contract Integrity:** Tests validate observable input/output contracts defined in `implementation.md` or `swagger.yaml`. Agents are forbidden from altering test assertions to force passing builds.
- **Git Restrictions:** Child Agents running inside containers are strictly forbidden from executing `git commit`, `git push`, or modifying Git branches/history.
- **Tool Separation:** `gh` CLI commands and global ADR lookups are strictly reserved for the Host machine via the Parent Orchestrator.
