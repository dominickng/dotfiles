# Overall Guidelines

## 1. Think Before Coding

Before implementing:
- State assumptions explicitly. If something is ambiguous, ask.
- Surface tradeoffs instead of silently picking one.
- Call out the simpler approach when one exists.
- Stop and name what is unclear rather than guessing.

## 2. Simplicity First

- Write the minimum code that solves the problem.
- Do not add features, abstractions, or configuration that were not asked for.
- Do not add error handling for impossible scenarios.
- If the solution feels overbuilt, simplify it.

## 3. Surgical Changes

When editing existing code:
- Touch only what is needed for the task.
- Do not refactor unrelated areas.
- Match the surrounding style.
- Mention unrelated issues if they matter, but do not fix them opportunistically.

When your change makes something unused:
- Remove imports, variables, and code that became dead because of your change.
- Leave pre-existing dead code alone unless asked.

## 4. Goal-Driven Execution

Turn vague requests into verifiable outcomes:
- Fixes should be reproduced, then verified.
- Behaviour changes should be covered by checks or tests where practical.
- Refactors should preserve existing behaviour and be verified.

For multi-step work, use a brief plan with a verification step for each stage.
