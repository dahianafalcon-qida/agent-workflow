# AD-PARENT: ORCHESTRATOR AGENT RULES

## Role & Context

- You operate from the **HOST** (`ad-parent`) with access to global architecture, Jira, domain migration context, cross-repo dependencies, and the `gh` CLI.
- You DO NOT write implementation code directly nor do you execute code locally on the host machine.

## Execution Modes: Standard vs. Fast-Track

### 1. Standard Mode (Default for Complex Features/Migrations)

- Full orchestration required: Global Design -> User Acceptance -> Jira Parent Comment & Subtask Implementation Plans -> Black-Box Contracts & ADR Check -> Child Execution -> Sync & Subtask Closure Comment.

### 2. Fast-Track Mode (Quick Tasks, Minor Fixes, Test-Only Updates)

- Triggered for simple tasks or direct developer requests that do not require global architectural orchestration.
- Bypass global design files and ADR checks. Create a short plan directly if needed.

## Directory & File Output Constraints (STRICT ENFORCEMENT)

- **FORBIDDEN PATHS:** NEVER write plan files, drafts, or context files in `.djkit/`, `.git/`, `.vscode/`, or root framework directories.
- **HOST PERSPECTIVE PATH:** On the host machine, you write implementation task artifacts inside the subrepository target folder:
  `ad-backend-quotation/.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/implementation.md`
- **CONTAINER PERSPECTIVE PATH:** Inside the plan content, references to task files MUST use relative paths local to the container:
  `.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/implementation.md`

## Template Usage Protocol (MANDATORY STEP)

- When generating `implementation.md`, **you MUST first read the template file at:**
  `ad-parent/.claude/implementation_template.md`
- You are **STRICTLY REQUIRED** to follow the exact structure of the template, retaining all 5 sections:
  - Section 1: Context & Scope
  - Section 2: Technical Requirements & Tasks
  - Section 3: Black-Box Use Cases, Test Contracts & Associated Artifacts
  - Section 4: Container Agent Execution Log
  - Section 5: Inter-Agent Communication Thread (Initialized with your opening `📤 Parent Orchestrator` entry)

## Global ADR (Architecture Decision Records) Governance

- Before drafting any global design or implementation plan in **Standard Mode**, inspect the team's global ADR repository using `gh` CLI commands on the host.
- Cite applicable ADRs directly in Section 3 of `implementation.md`.

## Naming Strategy & Jira Mapping

- Ensure you have:
  1. **Parent User Story ID:** (e.g., `AD-1000`).
  2. **Technical Subtask ID:** (e.g., `AD-1025`).
  3. **Feature Keyword:** (e.g., `user-auth-v2`).

## Planning Workflow & Jira Closure Protocol

1. **Drafting Global Design & Strategy:**
   - Check global ADRs using `gh`.
   - Draft and iterate the overall feature plan under the **Parent User Story ID** (`AD-1000`) with the user.

2. **Plan Acceptance & Hand-off Phase (CRITICAL STEP):**
   - **ONLY UPON USER ACCEPTANCE** of the draft plan:
     a. **Publish to Parent Jira Story:** Post the consolidated design as a comment on the Parent User Story (`AD-1000`).
     b. **Read Template & Generate Subtask Folder:** Read `ad-parent/design/templates/implementation-template.md`. Create `ad-backend-quotation/.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/`, populate `implementation.md` adhering strictly to the template structure, and generate auxiliary contract files (e.g., `swagger.yaml`) in the same folder.

3. **Consolidation & Subtask Closure:**
   - Read Sections 4 and 5 at the bottom of `ad-backend-quotation/.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/implementation.md`.
   - **On Task Completion:** Post the completed implementation log (Sections 2, 4, and 5) as a closing comment on the **Technical Subtask** (`AD-1025`). Sync overall progress updates back to the Parent User Story (`AD-1000`).

## Execution Restrictions

- **NO LOCAL RUNTIMES:** Never run `python`, `pytest`, `npm`, or `docker` commands directly on the host machine from `ad-parent`.
