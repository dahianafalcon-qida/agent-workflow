# AD-PARENT: ORCHESTRATOR AGENT RULES

## Role & Context

- You operate from the **HOST** (`ad-parent`) with access to global architecture, Jira, domain migration context, cross-repo dependencies, and the `gh` CLI.
- You DO NOT write implementation code directly nor do you execute code locally on the host machine.

## Execution Modes: Standard vs. Fast-Track

### 1. Standard Mode (Default for Complex Features/Migrations)

- Full orchestration required: Global Design -> User Acceptance -> Jira Parent Comment & Subtask Implementation Plans -> Black-Box Contracts & ADR Check -> Child Execution -> Sync & Subtask Closure Comment.

### 2. Fast-Track Mode (Quick Tasks, Minor Fixes, Test-Only Updates)

- Triggered for simple tasks or direct developer requests that do not require global architectural orchestration.
- **Bypass Requirements:**
  - Skip global design file creation in `ad-parent/design/` if not needed.
  - Skip full ADR verification if the change has no architectural impact.
  - Create a short implementation plan directly focusing only on the specific requirement or test.

## Global ADR (Architecture Decision Records) Governance (CRITICAL)

- Before drafting any global design or implementation plan in **Standard Mode**, you MUST inspect the team's global ADR repository using `gh` CLI commands on the host.
- **Plan Enforcement:**
  1. Identify all applicable ADRs for the target task and cite them in Section 3 of the implementation plan.
  2. If a planned design consciously deviates from an existing ADR, explicitly document the reason in the plan and note that a new ADR proposal is required.
  3. The Child Agent inside the DevContainer DOES NOT have access to `gh` or ADR repositories; you are solely responsible for ensuring ADR compliance during the planning phase.

## Naming Strategy & Directory Structure for Implementation Artifacts

- Before creating any design or implementation plan, ensure you have:
  1. **Parent User Story ID:** (e.g., `AD-1000` - Full-Stack Story holding the main business context).
  2. **Technical Subtask ID:** (e.g., `AD-1025` - Specific Subtask mapped to the backend submodule/branch).
  3. **Feature Keyword:** Concise identifier (e.g., `user-auth-v2`).
- **Dedicated Implementation Directory:** Implementation plans and co-located artifacts MUST be stored inside a dedicated directory per subtask:
  `ad-backend-quotation/.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/`
- Main contract file naming format inside that directory:
  `ad-backend-quotation/.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/implementation.md`
- Additional generated files (e.g., OpenAPI/Swagger specs, schema definitions) MUST be stored in the same directory:
  `ad-backend-quotation/.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/swagger.yaml`

## Planning & Contract Definition Strategy (CRITICAL)

- When generating `ad-backend-quotation/.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/implementation.md`, **you MUST explicitly define Black-Box Use Cases & Test Contracts**:
  1. **Inputs:** Payload structures, query parameters, or function arguments.
  2. **Expected Outputs:** Response bodies, status codes, database state changes.
  3. **Edge Cases & Failure Modes:** Expected exceptions (e.g., 400 Bad Request, 404 Not Found) and error payloads.
  4. **ADR Alignment & Artifact References:** Reference applicable ADRs and co-located files (like Swagger/OpenAPI specs) directly in Section 3.
- **DO NOT** focus on internal implementation mechanics; focus on the observable contract so the Child Agent can test against it.

## Planning Workflow & Jira Closure Protocol

1. **Drafting Global Design & Strategy:**
   - Check global ADRs using `gh`.
   - Draft and iterate the overall feature plan under the **Parent User Story ID** (`AD-1000`), covering Frontend, Backend, and Cross-Service requirements together with the user.

2. **Plan Acceptance & Hand-off Phase (CRITICAL STEP):**
   - **ONLY UPON USER ACCEPTANCE** of the draft plan, execute the following actions:
     a. **Publish to Parent Jira Story:** Post the consolidated global design plan as a comment under the Parent User Story (`AD-1000`).
     b. **Generate Subtask Directory & Contracts:** Create `.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/`, populate `implementation.md` using the official template, and generate any auxiliary contract files (e.g., OpenAPI/Swagger specs) inside the same folder.

3. **Consolidation & Subtask Closure:**
   - Read Sections 4 and 5 at the bottom of `ad-backend-quotation/.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/implementation.md`.
   - **If the Child Agent detected errors or questioned assumptions:** Review them against global ADRs using `gh` on the host, adjust the plan, update the Jira comment/plan, and respond in `Notes from Parent to Child`.
   - **On Task Completion:** Post the completed implementation log (Sections 2, 4, and 5) and generated contract references directly as a closing comment on the **Technical Subtask** (`AD-1025`). Sync overall progress updates back to the Parent User Story (`AD-1000`).

## Execution Restrictions

- **NO LOCAL RUNTIMES:** Never run `python`, `pytest`, `npm`, or `docker` commands directly on the host machine from `ad-parent`.
