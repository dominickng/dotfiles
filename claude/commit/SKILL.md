---
name: commit
description: |
  Format a git commit message following Dom's usual conventions

  Use this skill when asked to create a commit message

  Invocation: /commit
  Example: /commit
---

# Commit Message Formatter

This skill analyzes staged git changes and crafts a well-structured commit
message following the conventions below, then presents the draft for
confirmation before committing.

## Commit Message Structure

```
<summary line>

<problem/context paragraph>

<solution/what-changed paragraph>

<other changes paragraph (optional)>

<ticket reference (optional)>
```

### Rules for Each Section

1. **Summary line** (first line):
   - Imperative, active language where first word is a verb (completes "This
     commit will...")
   - Brief — ideally under 72 characters

2. **Problem/context paragraph**:
   - Explain _why_ this change is needed — describe the problem solved or the
     motivation for the change

3. **Solution/what-changed paragraph**:
   - Explain _what_ the commit does in more detail
   - Link the implementation back to the problem described above
   - Gives reviewers context to compare against the actual code

4. **Other changes paragraph** (if needed):
   - Describes secondary changes (tests, refactors, gotchas)
   - Contextualizes why changes beyond the summary were needed
   - Omit if there are no secondary changes

5. **Ticket reference** (if applicable):
   - `Fixes: XXXX` if this commit should close the linked issue
   - `Ref: XXXX` if this is one of a series of changes for that issue
   - Omit entirely if there is no ticket

## Universal rules

- Format all lines to max 72 characters in width
- Use blank lines between paragraphs in the body
- Split or combine paragraphs as needed to enhance readability

## Workflow

### Step 1: Context

Run these commands to understand the changes:

```bash
# See what's staged
git diff --cached --stat
git diff --cached

# Get branch name (may contain ticket ID)
git branch --show-current
```

### Step 2: Extract ticket

1. Check the branch name for a ticket pattern (e.g. `XXX-1234`, or
   `feat/XXX-1234-description`)
2. If found, propose it as the ticket reference and ask whether to use
   `Fixes:` (closes the issue) or `Ref:` (one of a series)
3. If not found, ask the user for the ticket number — if they confirm
   there is none, omit the ticket reference section entirely

### Step 3: Draft commit message

Based on the staged diff, draft a complete commit message following the
structure above. Think about:

- What problem does this solve? What was broken or missing?
- What does the code actually change to address it?
- Are there any secondary changes (tests, cleanup, workarounds) worth calling out?

### Step 4: Confirm

Present the full draft and ask the user to confirm or suggest edits:

```
Here's the proposed commit message:

---
<full commit message>
---

Does this look good, or would you like to change anything?
```

### Step 5: Commit

Once confirmed, create the commit:

```bash
git commit -m "$(cat <<'EOF'
<final commit message>
EOF
)"
```

## Edge cases

- **Nothing staged, no unstaged changes**:
  1. Check if the previous commit is local-only: `git log origin/HEAD..HEAD --oneline`
  2. If the result is empty, the commit is already on the remote — tell the
     user there's nothing to commit and stop. Do NOT offer to amend pushed commits.
  3. If there are local unpushed commits, show the commit summary and ask if
     they want to amend the most recent one's message
  4. If they confirm, read the message with `git log -1 --format=%B`,
     reformat it, present for review, then amend with `git commit --amend -m "..."`

- **Nothing staged but unstaged changes exist**:
  Tell the user and ask them to stage changes first before proceeding.

## Examples

### Example: Feature commit

```
Introduce a handles_intents property for the App Service

Currently, apps are filtered for use in intent picking and file opening
surfaces by whether they appear in the launcher. However, there are some
apps (like the Gallery) which are hidden from the launcher but should
appear in these surfaces.

Introduce a new handles_intents property on the App Service App struct
to communicate this distinction. This allows
AppServiceProxyBase::GetAppsForIntent to be simplified to avoid
special-case checking for specific apps. Instead, publishers can
appropriately set the handles_intents property for apps.

This allows the removal of a hack that previously existed to ensure
Gallery appeared for intents. There are no behaviour changes resulting
from this change.

A test is added to ensure that Gallery properly appears as an intent
target even though it is hidden in the launcher.

Ref: CHR-1240906
```

### Example: Bug fix commit

```
Do not clear WebsiteMetrics on history expiration

At browser startup, a task is scheduled to expire history entries >90
days old. This means that cached WebsiteMetrics entries are cleared
indiscriminately as the task runs before the cached entries are
uploaded. Additionally, in-memory metric values are also
indiscriminately cleared whenever the task runs, resulting in
~30-40% of website usage metrics being lost and never reported.

Address the issue by skipping clearing metrics when the deletion is due
to history expiration. This is permissible as the metrics are cached for
at most 2 hours of usage, while expired history entries are at least 90
days old. Update the test to exercise this case.

Fixes: CHR-1427645
```
