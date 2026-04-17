---
name: hunt
description: Invoke when debugging any error, crash, unexpected behavior, or failing test. Finds root cause before applying any fix. Not for code review or new features.
metadata:
  version: "3.12.0"
---

# Hunt: Diagnose Before You Fix

A patch applied to a symptom creates a new bug somewhere else.

**Do not touch code until you can state the root cause in one sentence:**
> "I believe the root cause is [X] because [evidence]."

Name a specific file, function, line, or condition. "A state management issue" is not testable. "Stale cache in `useUser` at `src/hooks/user.ts:42` because the dependency array is missing `userId`" is testable. If you cannot be that specific, you do not have a hypothesis yet.

## Rationalization Watch

When these surface, stop and re-examine:

| What you're thinking | What it actually means | Rule |
|---|---|---|
| "I'll just try this one thing" | No hypothesis, random-walking | Stop. Write the hypothesis first. |
| "I'm confident it's X" | Confidence is not evidence | Run an instrument that proves it. |
| "Probably the same issue as before" | Treating a new symptom as a known pattern | Re-read the execution path from scratch. |
| "It works on my machine" | Environment difference IS the bug | Enumerate every env difference before dismissing. |
| "One more restart should fix it" | Avoiding the error message | Read the last error verbatim. Never restart more than twice without new evidence. |

## Progress Signals

When these appear, the diagnosis is moving in the right direction:

| What you're thinking | What it means | Next step |
|---|---|---|
| "This log line matches the hypothesis" | Positive evidence found | Find one more independent piece of evidence to cross-validate |
| "I can predict what the next error will be" | Mental model is forming | Run the prediction; if it matches, the model is correct |
| "Root cause is in A but symptoms appear in B" | Propagation path understood | Trace the call chain from A to B and confirm each link |
| "I can write a test that would fail on the old code" | Hypothesis is specific and testable | Write the test before applying the fix |

Do not claim progress without observable evidence matching at least one of these signals.

## Hard Rules

- **Same symptom after a fix is a hard stop; so is "let me just try this."** Both mean the hypothesis is unfinished. Re-read the execution path from scratch before touching code again.
- **After three failed hypotheses, stop.** Use the Handoff format below to surface what was checked, what was ruled out, and what is unknown. Ask how to proceed.
- **Verify before claiming.** Never state versions, function names, or file locations from memory. Run `sw_vers` / `node --version` / grep first. No results = re-examine the path.
- **Visual/rendering bugs: static analysis first.** Trace paint layers, stacking contexts, and layer order in DevTools before adding console.log or visual debug overlays. Logs cannot capture what the compositor does. Only add instrumentation after static analysis fails.
- **Fix the cause, not the symptom.** If the fix touches more than 5 files, pause and confirm scope with the user.

## Outcome

### Success Format

```
Root cause:        [what was wrong, file:line]
Fix:               [what changed, file:line]
Confirmed:         [evidence or test that proves the fix]
Tests:             [pass/fail count, regression test location]
Regression guard:  [test file:line] or [none, reason]
```

Status: **resolved**, **resolved with caveats** (state them), or **blocked** (state what is unknown).

**Regression guard rule**: for any bug that recurred or was previously "fixed", the fix is not done until:
1. A regression test exists that fails on the unfixed code and passes on the fixed code.
2. The test lives in the project's test suite, not a temporary file.
3. The commit message states why the bug recurred and why this fix prevents it.

### Handoff Format (after 3 failed hypotheses)

```
Symptom:
[Original error description, one sentence]

Hypotheses Tested:
1. [Hypothesis 1] → [Test method] → [Result: ruled out because...]
2. [Hypothesis 2] → [Test method] → [Result: ruled out because...]
3. [Hypothesis 3] → [Test method] → [Result: ruled out because...]

Evidence Collected:
- [Log snippets / stack traces / file content]
- [Reproduction steps]
- [Environment info: versions, config, runtime]

Ruled Out:
- [Root causes that have been eliminated]

Unknowns:
- [What is still unclear]
- [What information is missing]

Suggested Next Steps:
1. [Next investigation direction]
2. [External tools or permissions that may be needed]
3. [Additional context the user should provide]
```

Status: **blocked**
