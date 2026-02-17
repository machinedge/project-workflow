The user wants to scope new work for an existing project.

If the user provided a description: $ARGUMENTS

First, read `docs/project-brief.md` and `docs/roadmap.md` (if it exists) so you understand the project context, constraints, audience, and what's already been built or planned. If `docs/project-brief.md` doesn't exist, tell the user to run `/interview` and `/vision` first — this command is for adding to an existing project.

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
- After all categories, produce a structured summary and flag any contradictions or gaps.
- Save the summary to `docs/interview-notes-[short-slug].md` (e.g. `docs/interview-notes-dark-mode.md`). Use a short, descriptive slug based on what the user describes.
- Tell the user to run `/decompose` next to break this into tasks.
