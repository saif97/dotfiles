---
description: Add AI Context Management section to CLAUDE.md
---

# Add AI Context Management Section

Your task is to update the project's CLAUDE.md file to include the AI Context Management section.

## Steps:

1. **Detect if CLAUDE.md exists** in the current project:
   - Check for `CLAUDE.md` in the project root
   - If it doesn't exist, create `CLAUDE.md`

2. **Add the AI Context Management section** after the main project description but before detailed technical sections. The section to add is:

```markdown
## AI Context Management (`.AI/`)
You are responsible for creating and strictly maintaining the `.AI/` directory as the central source of truth for all project context and planning relevant to your operation.

### Directory Structure
-   **`.AI/`**: This directory holds all files used by you (the AI agent) to manage project context.
    -   **`PLAN.md`**: This is the high-level project plan. You MUST ensure this file is always up-to-date whenever a high-level change occurs or a new task is initiated. It MUST contain:
        -   **Current Task**: A clear statement of the current task at hand.
        -   **Strategy**: Your detailed plan or approach to address the current task.
        -   **Backlog/Context**: A list of upcoming tasks, relevant background information, or important considerations.
    -   **Topic-Specific `.md` Files**: You may create additional `.md` files within the `.AI/` directory as you deem necessary to organize context for specific aspects of the project. Examples include `PROJECT_STRUCTURE.md`, `DATA_STRUCTURES.md`, `BACKEND_ARCH.md`, etc. These files should be used to store detailed information that is too extensive for `PLAN.md`.

### Your Responsibilities
-   **Creation**: You MUST create the `.AI/` directory and `PLAN.md` immediately upon project initialization or when first informed of this instruction.
-   **Maintenance**: You MUST update `PLAN.md` (and other topic-specific `.md` files as appropriate) whenever:
    -   A new task is assigned.
    -   The strategy for the current task changes.
    -   Significant progress is made or milestones are reached.
    -   New critical project information becomes available.
    -   You observe any high-level changes in the project structure, dependencies, or goals.
-   **Source of Truth**: Always refer to the files within the `.AI/` directory for project context and planning. Do not rely solely on chat memory for persistent project knowledge.
```

3. **Position the section appropriately**:
   - If there's already an existing section about AI or project management, integrate it there
   - Otherwise, place it after the main "Overview" or "Introduction" section
   - Ensure it doesn't disrupt the existing documentation flow

4. **Preserve all existing content** - do not remove or modify any other sections

5. **Create the file using the Edit or Write tool** - update the appropriate markdown file(s)

After completing the update, confirm which file(s) were updated and where the section was placed.
