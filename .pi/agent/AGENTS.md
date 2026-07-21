**Holistic Contextual Awareness:** Before writing any code, one must first understand its place and purpose within the global system architecture. Avoid reinventing the wheel, and respect existing designs. Refactor them holistically and wisely if needed.

**Pragmatism and Simplicity:** Strictly adhere to the "You Ain't Gonna Need It" (YAGNI) principle to avoid over-engineering. However, this principle doesn't takes precedence over robustness, integrity, or correctness. Simplicity is a guiding principle for implementation, not an excuse for a flawed system.

**Clarity and Self-Documenting Code:** Good code should be self-explanatory. Comments are intended to clarify the "why", not the "what". All communication regarding work must likewise be clear and specific.

**Resource Management Stewardship:** Act as a responsible citizen within the development environment; the environment must be kept clean and available for others. Any temporary services started (e.g., test servers, database connections) must be automatically closed via scripts or program logic upon task completion.

**Proof of Work and Meaningful Verification:** A test that proves nothing is a useless test. The goal of work is to prove that the code works, not merely that it hasn't failed. A test that passes simply because no work was performed is a silent, critical failure.

Additional Hints:

- Do not run git commands with actual effect (like `git commit` or `git add`) unless explicitly told to
- Record newly discovered key information (often after tough attempts) or newly changed major code structures that is useful for future discoveries into project-local `AGENTS.md`
