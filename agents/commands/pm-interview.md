The user is starting a new project and needs help pulling ideas out of their head.

If the user provided a description: $ARGUMENTS

Interview them about this project, one category at a time, in this order:

1. **Problem** — What problem does this solve? Who has it? How are they dealing with it now?
2. **Audience** — Who specifically is this for? What do they care about? What don't they care about?
3. **Success** — What does "done" look like? How will we measure success?
4. **Scope** — What's in and what's explicitly out?
5. **Constraints** — Budget, timeline, tech stack, team skills, org politics?
6. **Prior art** — What's been tried? What similar things exist?
7. **Risks** — What could go wrong? What's most uncertain?
8. **Environment & Delivery** — How does this software reach its users today? What does the build/test/deploy cycle look like? Are there physical devices, hardware, or infrastructure involved? What happens when something goes wrong in production?
9. **Operations & Compliance** — Are there regulatory, safety, or compliance requirements? Who maintains this after it ships? What does monitoring or observability look like today?
10. **You** — What's your background? (developer, designer, PM, domain expert, non-technical?) How experienced are you with AI coding tools? Have you built something like this before?

Rules:
- Review `.workflow` for previous interview notes and content to develop session context.
- First, ask the user if they'd like an abbreviated or extended interview.
- Ask questions one-at-a-time per category, then WAIT for answers before moving on.
- Keep questions short and conversational — the user may be speaking, not typing.
- If an answer is vague, push back and ask for specifics.
- Summarize what you heard after each category and confirm before moving on.
- Don't penalize typos, incomplete sentences, or speech-to-text artifacts — interpret intent.
- Categories 8 and 9 are intentionally open-ended. They work whether the answer is "it's a Rails app on Heroku" or "we flash firmware via JTAG to PLCs on a factory floor." Don't assume any particular technology or delivery mechanism.
- After category 10, calibrate the synthesis based on the user's background:
  - **If the user is experienced** (built similar things before, comfortable with AI tools, deep domain knowledge): produce the summary as-is and flag any gaps or contradictions for the user to resolve.
  - **If the user is light on experience** (first project, new to AI tools, or expressed uncertainty throughout earlier categories): fill in plausible assumptions for any gaps rather than leaving them blank. Label each one explicitly — e.g. "**Assumption:** tech stack is TypeScript + React because you mentioned familiarity with web dev — adjust if wrong." Present the enriched summary and invite the user to correct any assumption before saving.
- Save the summary to `.sdlc/rview-notes.md`.
- Tell the user to ask for the `pm-vision` skill next to generate the project brief.

DO NOT:
- Ask multiple questions at a time.
- Use any tools like "Ask User Questions" for multiple choice.
