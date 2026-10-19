# IMPLEMENTATION PLAN: [<JIRA-SUBTASK-ID>] <Feature Keyword>

> **Status:** [PLANNED | IN_PROGRESS | BLOCKED | READY_FOR_REVIEW | COMPLETED]
> **Target Module:** `ad-backend-quotation`
> **Parent Story:** `<JIRA-PARENT-ID>`
> **Subtask ID:** `<JIRA-SUBTASK-ID>`
> **Last Updated:** YYYY-MM-DD HH:MM

---

## 1. Context & Scope

*Contextual summary written by the orchestrator outlining what needs to be implemented in this module.*

- **Parent User Story:** `<JIRA-PARENT-ID>`
- **Technical Subtask:** `<JIRA-SUBTASK-ID>`
- **Git Branch Reference:** `feature/<JIRA-SUBTASK-ID>-<keyword>`
- **Implementation Folder (Local to Repo Root):** `.claude/implementations/<JIRA-SUBTASK-ID>-<keyword>/`

---

## 2. Technical Requirements & Tasks

*High-level task checklist. The container agent marks items as completed.*

- [ ] Task 1: Create data model / database migration
- [ ] Task 2: Implement business logic / endpoint
- [ ] Task 3: Write integration and contract tests (`pytest`)

---

## 3. Black-Box Use Cases, Test Contracts & Associated Artifacts

*Explicit definition of inputs, outputs, required use cases, governing ADRs, and co-located files.*

### Co-located Specifications & Artifacts

- **Swagger / OpenAPI Spec:** [e.g., `swagger.yaml` in this folder]
- **Schema Definitions:** [e.g., `request-schema.json` in this folder]

### Applicable ADRs & Governance

- **Mandatory ADRs:** [e.g., ADR-0012: UUID v4 for Primary Keys]
- **Exceptions / Deviations:** [e.g., None]

### Use Case 1: [Happy Path Scenario Name]

- **Trigger / Route:** POST /api/v2/quotations
- **Input / Payload:**
  {
    "customer_id": "UUID",
    "amount": 150.00
  }
- **Expected Output:** Status 201 Created
  {
    "quotation_id": "UUID",
    "status": "pending"
  }

---

## 4. Container Agent Execution Log

*Reserved for the execution log updated by the agent inside the DevContainer.*

### Last Execution Summary

- **Execution Date:** YYYY-MM-DD HH:MM
- **Tests Passing:** [YES | NO | N/A]
- **Modified Files:**
  - path/to/modified_file1.py

### Step-by-Step Log

1. *Implemented changes in src/...*
2. *Executed pytest tests/... - All tests passed.*

---

## 5. Inter-Agent Communication Thread

> 📤 **Parent Orchestrator** `[YYYY-MM-DD HH:MM]`
> Plan generated and ready for execution. Refer to `swagger.yaml` for request validation.

> 📩 **Child Container** `[YYYY-MM-DD HH:MM]`
> *Awaiting execution logs or blockers from the child agent...*
