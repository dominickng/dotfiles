---
name: nvim-news
description: |
  Check for neovim plugin updates, alternatives, and ecosystem news.

  Scans your plugin specs, researches recent updates via GitHub and web
  searches, and produces a structured report on what's changed, what's
  worth adopting, and neovim core developments.

  Invocation: /nvim-news
  Examples:
    /nvim-news
    /nvim-news lsp
    /nvim-news --since 6months
---

# Neovim Ecosystem News

Research and report on neovim plugin updates, community-validated
alternatives, and core neovim developments based on the user's actual
plugin setup.

## Arguments

- **Focus area** (optional, positional): One of `lsp`, `completion`,
  `treesitter`, `mini`, `git`, `formatting`, `debugging`, `editing`,
  `navigation`, `visual`, or `all`. Default: `all`.
- **`--since <period>`** (optional): Lookback period. Examples: `1month`,
  `3months`, `6months`. Default: `3months`.

When a focus area is specified, only that category gets deep research.
Other categories are skipped unless something major is found. The LSP
Developments section is always included regardless of focus area.

## Workflow

### Step 0: Check prior reports

Read all files in `.claude/skills/nvim-news/reports/` (if any exist).
These are summaries of previous runs including findings and actions taken.

Use prior reports to:
- **Skip re-researching unchanged plugins.** If the last report (within
  the lookback period) already covered a plugin and found nothing, don't
  deep-research it again — just verify via a quick check (latest release
  tag or a single WebFetch) that nothing new has happened since.
- **Track version state.** If the last report noted a plugin was at
  version X, only research what changed since version X.
- **Avoid re-recommending acted-on items.** If the "Actions Taken"
  section shows a recommendation was already applied, don't suggest it
  again.
- **Flag regressions or follow-ups.** If the last report noted something
  to "revisit" or "monitor", check on it.

If the lookback period extends before the earliest report, research that
uncovered gap normally.

After producing the report and completing any follow-up actions, save a
new summary to `.claude/skills/nvim-news/reports/{date}.md` using the
same format as existing reports. Include an "Actions Taken" section at
the end listing any config changes made during the conversation.

### Step 1: Build plugin inventory

Read all plugin spec files and the LSP server config to extract the
current plugin list:

```
nvim/lua/plugins/*.lua
nvim/lua/lsp/servers.lua
```

For each plugin, extract:
- The GitHub identifier (e.g., `saghen/blink.cmp`)
- The branch or version pin, if any (e.g., `version = "1.x"`)

Group plugins by category, inferred from their spec filename:
- `lsp.lua` -> LSP
- `completion.lua` -> Completion
- `treesitter.lua` -> Treesitter
- `mini.lua` -> Mini
- `git.lua` -> Git
- `formatting.lua` -> Formatting
- `debugging.lua` -> Debugging
- `editing.lua` -> Editing
- `navigation.lua` -> Navigation
- `visual.lua` -> Visual
- `colors.lua` -> Colors
- `lualine.lua` -> Status Line
- `files.lua` -> Files & Search
- `claude_code.lua`, `codex.lua` -> AI Integration

### Step 2: Research via GitHub

This is the primary source of truth. Use subagents to parallelize
research across categories.

For each plugin in the relevant categories (or all, if no focus area):

1. **Fetch the GitHub releases page** via WebFetch:
   `https://github.com/{owner}/{repo}/releases`
   Ask for a summary of releases within the lookback period.

2. If the releases page is sparse or empty, **fetch the CHANGELOG** or
   **README** instead:
   `https://github.com/{owner}/{repo}/blob/main/CHANGELOG.md`
   `https://github.com/{owner}/{repo}`

3. Note: For `echasnovski/mini.nvim`, check the main repo releases since
   all modules ship together.

Parallelize across categories using subagents. Each subagent handles one
category and returns a structured summary of what it found.

### Step 3: Broader web research

Complement GitHub data with web searches. Run these in parallel using
subagents:

**Category-level searches** (one per relevant category):
- Search for `"{plugin-name}" neovim updates {year}` for the most
  important plugins in each category (the 2-3 most central ones, not
  every plugin)

**Ecosystem searches** (always run):
- `neovim {version} new features {year}` — core neovim developments
- `best neovim plugins {year} reddit` — community-validated new plugins
- `neovim LSP improvements {year}` — always included since LSP is a
  priority area

**Community signals** (for alternatives):
- `neovim {current-plugin} alternative {year} reddit` — only for plugins
  where the GitHub research hinted at an actively-discussed successor

### Step 4: Filter for substance

Apply these criteria strictly. Prefer "nothing to report" over noise.

**Plugin updates** — only include if:
- Breaking change or deprecation that affects the user's config
- Significant new feature relevant to how the plugin is configured
- Major version bump with notable changes
- Skip: minor patches, dependency bumps, typo fixes

**Alternative plugins** — only include if:
- 500+ GitHub stars
- At least 3 months old (not a flash in the pan)
- Evidence of real migration from the user's current plugin (multiple
  community threads, not just one blog post)
- Solves a real pain point or offers a meaningful improvement

**New plugins** — only include if:
- Fills a gap in the current setup, OR
- Meaningfully improves on something already installed
- Has real adoption signals (stars, active discussions, endorsements
  from known community members)

**Neovim core** — only include if:
- Affects the user's actual workflow (LSP, treesitter, diagnostics,
  built-in features that overlap with installed plugins)
- New vim.* APIs that could simplify the config

### Step 5: Produce the report

Use this format:

```markdown
# Neovim Ecosystem Report — {date}
**Focus:** {area or "All"} | **Period:** last {timerange}

---

## Plugin Updates

### {Category Name}

**{plugin-name}** (`{owner/repo}`)
- Version: {version info, if known}
- Changes: {1-3 bullet points of what's relevant}
- Action: {None / Update recommended / Config change needed / Review breaking changes}

(Only list plugins with notable updates. Skip categories with nothing
to report.)

---

## Worth Considering

Plugins or tools that could replace or complement your current setup.

**{plugin-name}** (`{owner/repo}`) — {one-line pitch}
- Replaces/complements: `{current plugin}`
- Why: {concrete reason — not "it's popular"}
- Adoption: {stars, age, community evidence}
- Caveat: {any downside}

(Omit this section entirely if nothing meets the filtering criteria.)

---

## Neovim Core

- {Bullet points on neovim version changes, new APIs, built-in features}

---

## LSP Developments

- {TypeScript/JavaScript tooling — tsgo, vtsls, ts_ls ecosystem}
- {LSP protocol updates relevant to the user's languages}
- {Mason ecosystem changes}
- {Other LSP news for languages in the user's config}

(Always included regardless of focus area.)

---

## Summary

{2-3 sentences: what's most actionable, what to keep an eye on, what's
safe to ignore.}
```

### Step 6: Offer follow-up

After presenting the report, ask if the user wants to:
1. Deep-dive on a specific plugin or update
2. See the config changes needed for an update or migration
3. Try swapping a plugin (hand off to normal editing)