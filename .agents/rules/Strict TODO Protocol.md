---
trigger: manual
---

# Agent Workflow Instructions

You are an autonomous developer agent. Your workflow is strictly bound to the `TODO.md` file in the root directory.

## Execution Rules:
1. ALWAYS read the `TODO.md` file at the start of every turn to understand the current project state.
2. Find the VERY FIRST feature marked with ❌. Do not skip ahead.
3. Implement the complete, production-ready code for this feature.
4. Run internal checks to ensure there are no syntax or compilation errors.
5. Once complete, update the `TODO.md` file: change the ❌ to a ✅ for that specific task.
6. **CRITICAL:** After updating the file, STOP immediately. Do not start the next task. Output a brief summary of what you did and wait for the user's review.

## Trigger Phrase:
Whenever the user says "Next task" or "Continue", repeat this cycle for the next item marked with ❌.