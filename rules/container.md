# BACKEND SUBMODULE: CONTAINER AGENT RULES

## Role & Environment

- You are executing **INSIDE a DevContainer**.
- Your working directory root is the mounted repository root inside the container (e.g., `/app` or `/workspace`).
- Python, Pipenv/Poetry, Pytest, and all backend tools are directly available in your PATH.

## Timezone & Timestamps (CRITICAL)

- The container OS environment runs on **UTC**.
- You MUST report all timestamps using the **Europe/Madrid** timezone so your logs align with the Parent Orchestrator.
- Before logging any timestamp in Section 4 or Section 5, obtain the exact local time by running:
  `TZ="Europe/Madrid" date +"%Y-%m-%d %H:%M"`
- NEVER guess, invent, or output UTC timestamps.

## File & Directory Convention (CONTAINER PERSPECTIVE)

- Implementation task context and artifacts are located inside your local repository folder:
  `.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/`
- The core contract file to read and update is:
  `.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/implementation.md`
- Do NOT expect or search for parent repository names or host folders (e.g., `{repository}/`). Your relative root begins at `.claude/...`.
- Inspect co-located artifacts in the same folder (e.g., `swagger.yaml`, schema JSONs) when planning tests and implementation.

## Execution Modes: Planned vs. Direct Work

### Mode A: Planned Implementation & Review Iteration (Default)

- Applies when executing tasks assigned via `.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/implementation.md`.
- Handles both initial implementation and subsequent **Review Feedback Loops** from the Parent Orchestrator.
- Requires validating the plan, enforcing ADR-mandated TDD, following Add-Migrate-Remove pattern, adhering to PR templates, and updating Sections 4 & 5.

### Mode B: Direct Work Mode (Manual Dev Tasks, Quick Fixes, Adding Tests)

- Triggered when the user interacts with you directly in the DevContainer terminal WITHOUT a formal parent implementation folder.
- Act immediately on the user's prompt without requiring a plan file or ADR audit.

## Strict TDD (Test-Driven Development) Protocol (MANDATORY PER ADR)

Per team ADR governance, **writing production code before tests is strictly forbidden**:

1. **RED:** Write the black-box contract tests first (`pytest`) based on Section 3 of `implementation.md`. Run the test suite and verify that the new tests fail for the expected reason.
2. **GREEN:** Write the minimal production code necessary to make the tests pass, adhering to the Add-Migrate-Remove pattern.
3. **REFACTOR:** Clean up and optimize the implementation while ensuring the test suite remains fully green.
4. **NO WEAKENING ASSERTIONS:** Never alter test contracts to accommodate internal implementation bugs. Fix the business code.

## Safe Refactoring & Live-Reload Preservation

- The DevContainer runs active development servers with live-reload enabled.
- **NEVER START BY DELETING CODE:**
  1. **ADD FIRST:** Implement new functions or endpoints alongside existing ones.
  2. **MIGRATE & USE:** Switch references, imports, and tests to the new implementation.
  3. **VERIFY:** Run `pytest` and verify stability.
  4. **REMOVE LAST:** Safely delete deprecated code only after full verification.

## Execution Rules & Restrictions (ALWAYS ACTIVE)

- **DIRECT RUNTIMES ONLY:** Run `python`, `pytest`, etc., directly in the terminal.
- **NO DOCKER:** NEVER attempt to run `docker` or `docker compose`.
- **NO GH / ADR LOOKUPS:** DO NOT attempt to use `gh` CLI. ADR enforcement is delegated from the Parent Orchestrator.
- **STRICT GIT RESTRICTION:** Under NO circumstances execute `git commit`, `git push`, `git merge`, or modify history/branches. Only read-only commands (`git status`, `git diff`) are allowed if necessary.

## PR Description & Commit Message Protocol (MANDATORY STEP)

- When generating a Pull Request description or commit message:
  1. **Check for Official PR Template:** Inspect and read `.github/PULL_REQUEST_TEMPLATE.md` (or `.github/PULL_REQUEST_TEMPLATE/*.md`).
  2. **Follow the Template Structure:** Populate the PR draft strictly following all sections and checklists defined in `.github/PULL_REQUEST_TEMPLATE.md`.
  3. **Include Task IDs:** Ensure Parent Story ID and Technical Subtask ID are referenced.
  4. **Output:** Provide the formatted PR description and suggested commit message to the user and log them in Section 4 of `implementation.md`.

## Workflow: Implementation & Review Feedback Loop (Mode A)

1. **Fetch & Inspect Plan / Review Feedback:**
   - Open `.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/implementation.md`.
   - **Check Section 5 for Review Notes:** If the Parent Orchestrator left review feedback (`📤 Parent Orchestrator (Review)`), treat these items as high-priority revision tasks.
   - Read specs/swagger files in the same directory.
   - Run initial tests (`pytest`) to verify baseline stability.

2. **Execute / Correct via TDD (Red -> Green -> Refactor):**
   - For new features OR review corrections: write or adjust tests first to cover the feedback.
   - Implement production code safely using Add -> Migrate -> Remove.
   - Verify all tests pass (`pytest`).

3. **Log Progress & Reply in Section 5:**
   - Mark completed tasks in Section 2 as `[x]`.
   - Update Section 4 (`Container Agent Execution Log`) with exact timestamps (`TZ="Europe/Madrid"`).
   - If responding to a review, append a response entry in Section 5:
     `> 📩 **Child Container** [YYYY-MM-DD HH:MM]`
     `> Addressed review feedback: [Summary of changes made, tests added, or clarifications].`
   - Read `.github/PULL_REQUEST_TEMPLATE.md` and generate or update the compliant PR description & commit message in Section 4.
