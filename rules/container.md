# BACKEND SUBMODULE: CONTAINER AGENT RULES

## Role & Environment

- You are executing **INSIDE a DevContainer**.
- Python, Pipenv/Poetry, Pytest, and all backend tools are directly available in your PATH.

## File & Directory Convention

- Implementation task context and artifacts are located inside a dedicated folder per subtask:
  `.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/`
- The core contract file to read and update is:
  `.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/implementation.md`
- Inspect co-located artifacts in the same folder if present (e.g., `swagger.yaml`, schema JSONs) when writing implementation or test code.

## Execution Modes: Planned vs. Direct Work

### Mode A: Planned Implementation (Default for Epics/Features from Parent)

- Applies when executing tasks assigned via `.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/implementation.md`.
- Requires validating the plan, inspecting co-located artifacts (like Swagger/OpenAPI specs), following Black-Box testing, Add-Migrate-Remove pattern, and updating Sections 4 & 5.

### Mode B: Direct Work Mode (Manual Dev Tasks, Quick Fixes, Adding Tests)

- Triggered when the user interacts with you directly in the DevContainer terminal WITHOUT a formal parent implementation folder (e.g., *"Write tests for this function"*, *"Help me debug this error"*, *"Fix this typo"*).
- **NO PARENT PLAN REQUIRED:** Act immediately on the user's prompt. Do NOT demand an implementation file, ADR check, or formal contracts.
- Write, refactor, or test code directly as instructed.

## Execution Rules & Restrictions (ALWAYS ACTIVE IN ALL MODES)

- **DIRECT RUNTIMES ONLY:** Run `python`, `pytest`, etc., directly in the terminal.
- **NO DOCKER:** NEVER attempt to run `docker` or `docker compose`.
- **NO GH / ADR LOOKUPS:** DO NOT attempt to use `gh` CLI or access external ADR repositories. The `gh` CLI is intentionally unavailable in this DevContainer. ADR compliance for complex tasks is handled by the Parent Orchestrator.
- **STRICT GIT RESTRICTION:**
  - UNDER NO CIRCUMSTANCES are you allowed to execute `git commit`, `git push`, `git merge`, `git rebase`, or any command that modifies Git history/branches.
  - You MAY ONLY use read-only inspection commands like `git status` or `git diff` if strictly necessary.

## Safe Refactoring & Live-Reload Preservation (CRITICAL)

- **Live-Reload Awareness:** The DevContainer runs active development servers (e.g., FastAPI/Uvicorn, Django runserver) with live-reload enabled.
- **NEVER START BY DELETING CODE:**
  1. **ADD FIRST:** Implement new code, functions, or endpoints alongside existing ones.
  2. **MIGRATE & USE:** Switch references, imports, and tests to the new implementation.
  3. **VERIFY:** Run `pytest` and verify the live-reload server remains stable.
  4. **REMOVE LAST:** Safely delete old/deprecated code only after full verification.

## Test Integrity & Contract Enforcement (CRITICAL)

- **NO TAILORED TESTS:** NEVER write or alter tests to match your internal implementation details.
- **BLACK-BOX / CONTRACT TESTING:** Tests MUST validate input/output contracts and business requirements specified in Section 3 of `implementation.md` and any associated Swagger/OpenAPI specs.
- **CORRECT THE CODE, NOT THE TEST:** If a test asserting valid business output fails, fix the code logic. DO NOT weaken test assertions or mocks just to make tests green.

## Workflow for Planned Mode (Mode A)

1. **Fetch & Validate Plan:**
   - Open `.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/implementation.md`.
   - Read associated specs/swagger files in the same directory.
   - **Critical Sanity Check:** Inspect the plan against the active codebase and run initial tests (`pytest`) to verify if technical assumptions hold true.

2. **Handle Inconsistencies or Execution Blockers:**
   - **If the plan contains flaws, failing edge cases, or ADR concerns:**
     - Document runtime failure, failing test logs, or architectural concerns in Section 5 (`Notes from Child to Parent`).
     - Pause execution or adapt implementation safely, documenting the decision.

3. **Execute & Verify:**
   - Write code using the **Add -> Migrate -> Remove** pattern.
   - Verify logic against contract-based tests (`pytest`).

4. **Log Progress:**
   - Mark completed tasks in Section 2 as `[x]`.
   - Update Section 4 (`Container Agent Execution Log`) in `implementation.md`.
   - Record any architectural corrections in Section 5 (`Notes from Child to Parent`).
