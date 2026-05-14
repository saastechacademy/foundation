# Claude Code Workflow Guide
## How we used Claude Chat + Claude Code to build ec.ai

This document is a practical guide for engineers on the team who want to use
the same AI-assisted development workflow used to build the `ec.ai` facade.
It covers the mental model, the tools, the prompt architecture, and the habits
that made it work.

---

## The two tools and how they differ

Two distinct Anthropic tools were used throughout this project — and they play
different roles:

| | Claude Chat | Claude Code |
|---|---|---|
| What it is | Conversational AI in the browser | Agentic CLI that operates on your codebase |
| What it does | Thinks, designs, reviews, drafts | Reads files, writes files, runs commands |
| Reads `CLAUDE.md` | No | Yes — automatically at session start |
| Writes to disk | No | Yes — with permission prompts |
| Runs shell commands | No | Yes |
| Good for | Architecture, naming, prompt drafting, reviewing proposals | Executing those decisions against real code |

**The key insight:** Claude Chat is the thinking partner. Claude Code is the
hands. Never confuse the two roles.

In this project, every naming decision (`model-config` vs `provider`,
`generate` vs `chat`), every architecture question (LangChain4j vs direct HTTP,
Java 11 vs Java 21), and every prompt that was sent to Claude Code — was
designed in Claude Chat first.

---

## Setting up Claude Code

### Installation

```bash
npm install -g @anthropic-ai/claude-code
claude --version
```

### IDE integration

Both IntelliJ and VS Code have Claude Code plugins. The plugin is a UI wrapper
around the same CLI — the underlying behavior is identical. Use whichever IDE
you prefer.

### Starting a session

```bash
cd /path/to/your/project
claude
```

Claude Code reads `CLAUDE.md` at startup automatically.

---

## CLAUDE.md — the project memory file

`CLAUDE.md` is the most important file in the workflow. Claude Code reads it
at the start of every session. Without it, every session starts blind.

### What goes in it

```markdown
# Project Name

## Session start
At the start of every session, before doing anything:
1. Read this file
2. Fetch the active issue: gh issue view N --repo org/repo
3. Confirm current step and file to touch
4. Wait for explicit go-ahead

## Project layout
- Where source files are
- Where config files are
- Any directories that must NOT be touched

## What we are building
- One paragraph description
- Reference files to read before making changes

## Rules — always follow these
1. Never modify runtime/component/ files
2. Never run gradle build unless explicitly asked
3. One step at a time — do not proceed until asked
4. After every file change, show diff before saving
5. Do not read files outside framework/src/ unless told to

## Build system
- How to compile, how to test
- What NOT to run

## Git
- Feature branch name
- Where to push

## Active issue
https://github.com/org/repo/issues/N

## Current step
Step N — what we are doing right now, which file

## Completed steps
Step 1 — DONE. Brief description. Commit: abc1234
Step 2 — DONE. Brief description. Commit: def5678
```

### Critical habits

**Update `CLAUDE.md` at the end of every step.** Move the completed step to
`Completed steps` and update `Current step`. This is the equivalent of saving
your work. If you skip this, the next session starts with wrong assumptions.

**Behavioral instructions go at the top.** Things you want Claude Code to *do*
— the session start ritual, the rules — go above reference material. Claude
Code reads top to bottom.

**`Session start` section is the highest leverage line in the file.** It tells
Claude Code to fetch the GitHub issue and confirm its understanding before
touching anything. This prevents the most common failure mode: Claude Code
charging ahead on stale assumptions.

---

## GitHub issues as session controller

Every step in the project had its own GitHub issue. This is not bureaucracy —
it serves a specific technical purpose.

Claude Code has the `gh` CLI available. When you include an issue URL in
`CLAUDE.md`, Claude Code fetches it at session start:

```bash
gh issue view 3 --repo hotwax/moqui-ai
```

This gives Claude Code:
- The current step's requirements
- Key design decisions already made
- Acceptance criteria to verify against
- A record of what was decided and why

When a session is interrupted (IDE crash, end of day, context reset), the next
session opens by reading `CLAUDE.md` and fetching the issue. Claude Code
reconstructs full context from those two sources alone. No re-explaining needed.

**Issue as decision log:** Add comments to issues as decisions are made.
The naming debate (`ai-gateway` vs `llm-config` vs `model-config`) lived in
Claude Chat — in a production workflow it should have been captured as a
comment on the GitHub issue so any engineer opening that session later
understands why `model-config` was chosen.

---

## Prompt architecture

Every prompt to Claude Code has five layers. Most people only write the middle
one. The other four prevent the most common failures.

```
CONTEXT    → Where are we in the plan? Which step?
READ       → Which files to read before doing anything
TASK       → Exactly one thing to do
OUTPUT     → What to show before writing anything
DO NOT     → Explicit guardrails
```

### Example — a well-structured prompt

```
We are on Step 2 of the ec.ai development plan.

Before writing anything, read these files:
1. framework/src/main/java/org/moqui/context/ElasticFacade.java
   — study the interface structure and Javadoc style
2. framework/src/main/java/org/moqui/context/ExecutionContext.java
   — understand how existing facades are declared

Then propose (do NOT write yet) a new file:
framework/src/main/java/org/moqui/context/AiFacade.java

Requirements:
- AiFacade interface with getDefault() and getConfig(String name)
- Nested AiClient interface with generate() and generateStructured()
- Javadoc on every method
- Package: org.moqui.context
- License header: copy exactly from ElasticFacade.java

Show the complete proposed file. Do not write yet.
```

### What each layer does

**CONTEXT** stops Claude Code from inferring the wrong starting point.
Without it, Claude Code may assume you're starting fresh or continuing
from a different state.

**READ** is the most important instruction for code quality. Claude Code
will pattern-match its output against what it reads. If you don't specify
which files to read, it patterns against its training data — which may be
outdated or wrong for your specific codebase.

**TASK** must be singular. One file, one change. As soon as a prompt contains
"and also", split it into two prompts.

**OUTPUT** is the "propose before write" gate. The phrase `do NOT write yet`
is not optional — without it, Claude Code will write immediately after thinking.

**DO NOT** is where you prevent the most common mistakes: reading outside
the allowed scope, running expensive commands, proceeding to the next step.

---

## The session opening ritual

Start every Claude Code session with this exact prompt before anything else:

```
Read CLAUDE.md and fetch the active issue:
gh issue view N --repo org/repo

Confirm:
1. Current step and file we are working on
2. Last action taken
3. What is pending before writing any files

Do not make any changes yet.
```

This forces Claude Code to demonstrate its understanding before touching
anything. If it misunderstands something, you catch it before any file is
written. This takes 10-15 seconds and prevents an entire class of mistakes.

---

## The propose-before-write discipline

**Always see the output before it hits the filesystem.**

The flow for every change:

1. Send prompt with `do NOT write yet`
2. Read the proposal carefully
3. If correct → send `Approved. Write the files.`
4. If needs correction → send `One correction before writing: [specific change]. Show updated proposal. Do not write yet.`
5. If wrong → send `Stop. [Explain the problem]. Revised instruction: [...]`

**Approval is not binary.** You can approve with corrections:

```
Approved with one correction before writing:
Change the attribute name from "provider" to "type" in the
<model-config> element. Show the corrected diff. Do not write yet.
```

**You can course-correct mid-session** before anything is written. The
`do not write yet` pattern gives you that control. Once you say `Approved.
Write the files.` the file hits disk — that's when it matters.

---

## Breaking tasks into smaller pieces

Step 3 (AiFacadeImpl) was originally proposed as a single large task.
The first two proposals both had bugs — duplicate methods, incorrect schema
conversion, wrong attribute naming. The fix was to break it into three
sub-tasks:

- **3a** — Add LangChain4j to `build.gradle` only. Verify dependencies resolve.
- **3b** — Outer class skeleton only. No LangChain4j imports, no inner class.
  Compile and verify.
- **3c** — Inner class with full implementation. Compile and verify.

Each sub-task produced a proposal of ~20-30 lines. Easy to read in full.
Bugs were caught immediately. The compile step at the end of each sub-task
caught API mismatches (like `ResponseFormatType.JSON_SCHEMA` not existing
in LangChain4j 1.8.0) before they accumulated.

**Rule of thumb:** If a proposal is more than 50 lines, break the task.

---

## Compile at every step

Every task ended with a compile:

```
After writing, show only the diff.
Then run: ./gradlew compileGroovy 2>&1 | tail -20
```

This is not optional. Compile errors caught in this project:

- `OpenAiChatModel.Builder` — Lombok names the builder `OpenAiChatModelBuilder`,
  not `Builder`. Claude Code couldn't know this from training data. The compile
  caught it immediately.
- `ResponseFormatType.JSON_SCHEMA` — doesn't exist in LangChain4j 1.8.0.
  The enum only has `TEXT` and `JSON`.
- `ExecutionContextFactory` missing `getAi()` — the `@Override` in ECFI
  failed to compile, revealing that `getAi()` needed to be declared on the
  factory interface too.

None of these would have been caught by reading the proposal. All were caught
in under a minute by the compile step.

---

## Commit discipline

Every completed step gets its own commit with a meaningful message:

```bash
git commit -m "Step N: Brief description

- What was added or changed
- Key design decision if any

Ref: https://github.com/org/repo/issues/N"
```

**Why this matters for Claude Code workflows:**
If a session produces bad output that gets written and committed, a clean
per-step commit history means you can revert exactly that step without
losing anything else. The `Ref:` line connects the commit to the issue
where the decisions were recorded.

---

## Handling environment issues

Two environment issues arose during this project. Both are worth documenting
for future sessions.

### JDK version

Gradle picks up `JAVA_HOME` from the environment. When VS Code opens a new
terminal, it may not source `~/.zshrc`. Set it permanently:

```bash
echo 'export JAVA_HOME="$HOME/.sdkman/candidates/java/current"' >> ~/.zprofile
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.zprofile
```

`~/.zprofile` is sourced by login shells (which VS Code uses).
`~/.zshrc` is sourced by interactive shells. Both need the export for
consistent behavior.

### API credentials

Never put API keys in files that are committed. The `runtime/` directory
is in `.gitignore` — credentials go in `runtime/conf/MoquiDevConf.xml`:

```xml
<default-property name="ai_api_key" value="sk-your-actual-key"/>
```

Before adding any credential, verify the file is gitignored:

```bash
git check-ignore -v runtime/conf/MoquiDevConf.xml
```

---

## What to do when Claude Code goes wrong

**Duplicate methods in a proposal:** This happened twice in Step 3. Always
scroll to the bottom of a long proposal and check for repeated method
signatures. If found, send:

```
Stop. The proposal has duplicate methods — [method name] appears twice.
Remove the duplicate. Show corrected [section] only. Do not write yet.
```

**Claude Code charges ahead without permission:** If you see file writes
happening before you approved, type `/esc` to interrupt. Then restate
the rules clearly in your next prompt and add them to `CLAUDE.md`.

**Claude Code reads the wrong files:** If the output patterns don't match
your codebase, add more explicit READ instructions. Name the exact file
and line range if needed.

**Session loses context after IDE restart:** Run the session opening ritual.
Claude Code will reconstruct from `CLAUDE.md` and the GitHub issue.
This is the system working as designed.

---

## Prompt patterns reference

### Starting a session
```
Read CLAUDE.md and fetch: gh issue view N --repo org/repo
Confirm current step and what is pending. Do not make any changes yet.
```

### Proposing a new file
```
Read [file1] and [file2] as references.
Then propose (do NOT write yet) [new file path] with these requirements:
[requirements]
Show the complete proposed file. Do not write yet.
```

### Approving with a correction
```
Approved with one correction before writing:
[specific change]
Show the corrected [section/file]. Do not write yet.
```

### Writing after approval
```
Approved. Write the file(s).
After writing show only the diff.
Then run: ./gradlew compileGroovy 2>&1 | tail -20
Do not proceed further.
```

### Course-correcting mid-session
```
Stop. Do not write yet.
[Explain what's wrong]
Revised instruction: [new requirements]
Show updated proposal. Do not write yet.
```

### Investigating a compile error
```
The compile failed with this error:
[error text]

Before fixing, read [relevant file] at line [N] to understand the context.
Then propose the minimal fix. Do not write yet.
```

### End of step
```
[After verifying the diff and compile output]
Commit with this message: "[message]"
Then stop. Do not proceed to the next step.
```

---

*For the project deliverables, architecture, and HotWax Commerce possibilities,
see `ec-ai-project.md`.*
