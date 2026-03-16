The user wants to scope new work for an existing project.

If the user provided a description: $ARGUMENTS

First, read `docs/project-brief.md` and `docs/roadmap.md` (if it exists) so you understand the project context, constraints, audience, and what's already been built or planned. If `docs/project-brief.md` doesn't exist, tell the user to run `/interview` and `/vision` first — this command is for adding to an existing project.

## Step 1: Assess Complexity

Before starting the interview, assess the complexity of the request based on the user's description (if provided) and the project context.

Consider:
- How many files, experts, or system boundaries does this likely touch?
- Is the scope obvious from the description, or are there ambiguities that need exploration?
- Does it interact with existing functionality in non-trivial ways?
- Could a competent developer scope this in their head, or does it need structured discovery?

Classify as:
- **Small** — Scope is obvious, touches 1-2 files or one expert, no ambiguous interactions, could be a single task. Examples: fixing a template, adding a field, tweaking a rule.
- **Medium** — Touches multiple files or experts, some interaction with existing functionality, but the shape of the work is mostly clear. Examples: adding a new skill to an existing expert, modifying a workflow step.
- **Large** — Crosses system boundaries, has unclear scope or significant trade-offs, touches many components, or could affect multiple experts. Examples: adding a new expert, restructuring a core workflow, changing a cross-cutting concern.

## Step 2: Run the Appropriate Interview

### If Small: Abbreviated Interview

Present a single-pass summary covering all 5 categories (What, Why, Scope, Success, Risks). Explicitly state your assumptions for each:

> Based on your description, here's my understanding:
>
> **What:** [your interpretation]
> **Why:** [your inference]
> **Scope — In:** [what you think is in] / **Out:** [what you think is out]
> **Success:** [how you'd know it's done]
> **Risks:** [what could go wrong]
>
> **Assumptions I'm making:** [list each assumption clearly]
>
> Does this look right, or should I adjust anything? If this is more complex than it looks, say so and I'll run the full interview.

Wait for the user to confirm, correct, or request the full interview. If they correct specific points, update and re-confirm. If they say it's more complex, switch to the full interview flow.

### If Medium or Large: Full Interview

Interview them about the new work, one category at a time:

1. **What** — What do you want to add or change? Describe it in your own words.
2. **Why** — What problem does this solve? Why now?
3. **Scope** — What's in and what's explicitly out? How does it interact with what already exists?
4. **Success** — How will we know this is done and working?
5. **Risks** — What could go wrong? What's uncertain? Any parts of the existing system this might break?

Rules:
- Ask questions one-at-a-time per category, then WAIT for answers before moving on.
- Keep questions short and conversational — the user may be speaking, not typing.
- If an answer is vague, push back and ask for specifics.
- Summarize what you heard after each category and confirm before moving on.
- Don't penalize typos, incomplete sentences, or speech-to-text artifacts — interpret intent.

## Step 3: Produce the Summary

After the interview (abbreviated or full):
- Produce a structured summary and flag any contradictions or gaps.
- Save the summary to `docs/interview-notes-[short-slug].md` (e.g. `docs/interview-notes-dark-mode.md`). Use a short, descriptive slug based on what the user describes.
- Tell the user to run `/update-plan` next to integrate this feature into the project brief and roadmap.

DO NOT:
- Ask multiple questions at a time.
- Use any tools like "Ask User Questions" for multiple choice.
- Skip directly to `/decompose` — the brief and roadmap must be updated first via `/update-plan`.
