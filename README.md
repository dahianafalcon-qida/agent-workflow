# 🤖 Agent Workflows Framework

A lightweight, portable architecture for orchestrating **AI Coding Agents (Claude Code / Cursor)** in multi-repository setups.

This framework decouples high-level architectural planning on the host machine from isolated, runtime-bound execution inside **DevContainers**.

---

## 🏛️ Architecture Overview

```text
┌─────────────────────────────────────────────────────────────────────────┐
│ HOST MACHINE (ad-parent Workspace)                                      │
│                                                                         │
│  [ Parent Orchestrator Agent ]                                          │
│   ├── Reads global architecture & domain context                        │
│   ├── Inspects company ADRs via `gh` CLI                                │
│   ├── Publishes accepted plans to Jira (Parent User Story & Subtasks)   │
│   ├── Generates task directories & contracts for child modules          │
│   └── Reviews the child's work (read-only on source code)               │
└────────────────────┬────────────────────────────────────────────────────┘
                     │ Writes `implementation.md` & contracts
                     ▲ Reads Sections 4 & 5 (log + review thread)
                     ▼ `.claude/implementations/<SUBTASK-ID>-<keyword>/`
┌─────────────────────────────────────────────────────────────────────────┐
│ DEVCONTAINER (e.g., ad-backend-quotation Submodule)                     │
│                                                                         │
│  [ Child Execution Agent ]                                              │
│   ├── Runs inside Docker / DevContainer runtime (Python, Pytest, etc.)  │
│   ├── Operates in Planned (default) or Direct mode                      │
│   ├── Reads `implementation.md` & co-located specs (Swagger, JSONs)     │
│   ├── Follows Add -> Migrate -> Remove refactoring pattern              │
│   ├── Follows strict TDD (Red -> Green -> Refactor)                     │
│   ├── Answers parent review feedback in Section 5                       │
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
│   └── implementation.md               # Task contract & execution log template
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
  "ad-backend"
  "ad-backend-quotation"
  "ad-openai-poc"
  "qida_videocalls"
)
```

### 3. Run the setup script targeting your workspace

The argument is the **name** of the workspace directory (default: `ad-parent`), which must be a **sibling** of this repository (the script resolves it as `../<name>`):

```bash
# Run from inside agent-workflows; the workspace lives at ../ad-parent
cd ~/agent-workflows
./setup.sh ad-parent
```

The script will:

- Copy `rules/orchestrator.md` to `.claude/rules.md` in the root workspace.
- Copy `templates/implementation.md` to `.claude/implementation_template.md` in the root workspace (the orchestrator reads it from there before generating any plan).
- Iterate over each directory in `CHILD_MODULES` to create `.claude/implementations/` and copy `rules/container.md` into `.claude/rules.md`. Missing submodules are skipped with a warning.

Re-run the script whenever the rules or the template change to propagate them to all child repositories.

---

## 📌 Reminder: Git Ignore Configuration

The `setup.sh` script **does not alter your Git configuration or edit repository files**.

To prevent local agent rules, temporary workspace files, and implementation logs from being accidentally committed to company repositories, manually add the following entries to `.git/info/exclude` (for local-only ignores) or the respective `.gitignore` files:

### In Root Workspace (`ad-parent`)

```gitignore
.claude/rules.md
.claude/implementation_template.md
```

### In Each Submodule Directory (`ad-backend-quotation`, etc.)

```gitignore
.claude/rules.md
.claude/implementations/
```

---

## 🔄 Daily Workflows

### 1. Standard Mode (Complex Features & Migrations)

1. **Design & Iterate:** Collaborate with the **Parent Agent** in `ad-parent`. It checks global ADRs via `gh` CLI and drafts the full architecture plan under the Parent User Story.
2. **Accept Plan:** Only upon your explicit acceptance, the Parent Agent:
   - **Posts the master design** as a comment on the Parent User Story (`<JIRA-PARENT-ID>`).
   - **Reads the template** at `ad-parent/.claude/implementation_template.md` and creates `{repository}/.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/` with `implementation.md` (all 5 sections) plus supporting specs (e.g., `swagger.yaml`).
3. **Child Execution:** You open the target submodule's DevContainer and ask the **Child Agent** to execute the plan (Mode A). It works via TDD and logs progress in Sections 2, 4 and 5.
4. **Review Loop:** When the Child finishes, ask the Parent to review. It reads Sections 4 & 5, inspects the modified files and audits them against the black-box contracts and ADRs.
   - **Issues found:** the Parent appends a `📤 Parent Orchestrator (Review)` entry to Section 5. The Child picks it up as high-priority work and answers with a `📩 Child Container` entry. Repeat until approved.
   - **Approved:** the Parent appends an approval note to Section 5.
5. **Closure:** The Parent posts the completed log (Sections 2, 4 and 5) as a closing comment on the Technical Subtask and syncs progress to the Parent User Story.

> The Parent never runs `docker`, so the hand-off to the Child is always triggered by you.

### 2. Fast-Track Mode (Quick Tasks, Minor Fixes, Test-Only Updates)

- Triggered for simple tasks that do not need global orchestration.
- The Parent skips global design files and ADR checks and may create a short plan directly.

### 3. Direct Work Mode (Manual Tasks & Pair Programming)

- Work directly inside the **DevContainer terminal** (e.g., `ad-backend-quotation`).
- Bypasses the Parent Agent and formal `implementation.md` plans entirely.
- The Child Agent acts as a direct pair programmer for quick bug fixes, refactoring, or writing unit tests, without plan files or ADR audits.

---

## 📄 The `implementation.md` Contract

Every planned task is a folder, `.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/`, whose `implementation.md` follows the template structure strictly:

| Section | Owner | Content |
| --- | --- | --- |
| 1. Context & Scope | Parent | Story, subtask, branch and folder references |
| 2. Technical Requirements & Tasks | Parent writes, Child ticks `[x]` | Task checklist |
| 3. Black-Box Use Cases, Test Contracts & Artifacts | Parent | Inputs/outputs, co-located specs, applicable ADRs |
| 4. Container Agent Execution Log | Child | Execution summary, modified files, step log, PR description & commit message |
| 5. Inter-Agent Communication Thread | Both | Review feedback and replies, one entry per message |

Paths inside the plan are always repository-relative (container perspective); the Parent uses the `{repository}/` prefix only on the host.

### Timestamps

Timestamps are never guessed. The Parent uses the host clock (`date +"%Y-%m-%d %H:%M"`); the Child runs on UTC and must use `TZ="Europe/Madrid" date +"%Y-%m-%d %H:%M"`, so both logs share the same timezone.

---

## 🛡️ Core Rules & Safety Guarantees

### File Ownership

- **The Parent is Architect & Reviewer, not Implementer.** It does not write implementation code nor run it locally (`python`, `pytest`, `npm`, `docker` are forbidden on the host).
- **Parent allowed files:** the implementation folder and `implementation.md`, static contract data inside that folder (`swagger.yaml`, JSON schemas, mocks), and files under `ad-parent/`.
- **Parent forbidden files:** source code, tests, migrations, configuration and dependency files in the child repository; PR descriptions and commit messages. Corrections are logged as review feedback in Section 5, never fixed by the Parent.
- **Forbidden paths:** plans or drafts are never written in `.djkit/`, `.git/`, `.vscode/` or root framework directories.

### Execution Safety

- **Strict TDD:** Production code is never written before tests (Red -> Green -> Refactor), as mandated by ADR.
- **Live-Reload Preservation:** Refactoring strictly follows **Add -> Migrate -> Remove** to avoid crashing active development servers (`uvicorn`, `django`, etc.) mid-task.
- **Contract Integrity:** Tests validate observable input/output contracts defined in `implementation.md` or `swagger.yaml`. Agents are forbidden from altering test assertions to force passing builds.
- **Git Restrictions:** Child Agents are strictly forbidden from `git commit`, `git push`, `git merge` or modifying branches/history (only `git status` / `git diff` allowed).
- **PR Protocol:** The Child drafts PR descriptions and commit messages following the repository's `.github/PULL_REQUEST_TEMPLATE.md`, referencing the Parent Story and Subtask IDs, and logs them in Section 4.
- **Tool Separation:** `gh` CLI and global ADR lookups are reserved for the Host (Parent Orchestrator); the Child never uses `gh` nor `docker`.
- **Timestamp Integrity:** No invented or UTC timestamps; see [Timestamps](#timestamps).
