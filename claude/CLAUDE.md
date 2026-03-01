# User-level Memory

This file contains global instructions and context for Claude Code across all projects.

## Language

- Always respond in Japanese

## Git Worktree

- Use `git worktree` when working on multiple tasks in parallel
- This avoids conflicts from switching branches in the same directory

## Commit Message

- **Always** run `git status` and `git diff` to check the latest changes before committing
  - Do not rely on outdated information about the working directory
- Follow [Conventional Commits](https://www.conventionalcommits.org/) format by default
- However, adapt to the repository's existing commit style if it differs
  - Check the last few commits (`git log`) to determine the project's convention before committing
- **NEVER** add Claude as a Co-Author in commit messages

## Pull Request

- If the repository has a PR template, follow it when creating pull requests
  - Common locations: `.github/PULL_REQUEST_TEMPLATE.md`, `.github/pull_request_template.md`, `docs/pull_request_template.md`, or root directory

## Planning

- Use plan mode for:
  - Complex tasks involving changes across multiple files
  - Tasks where multiple approaches are possible
  - Changes that affect architecture
  - When the user explicitly requests a plan

## Implementation

- Read and understand existing code before making changes
- Make small, incremental changes rather than large modifications at once
- Follow the project's existing code style (respect linter/formatter settings)
- Run related tests after making changes
- Keep changes minimal and focused on what was requested
  - Do not perform refactoring or improvements outside the requested scope
  - Instead, leave code comments for future improvements: `TODO`, `FIXME`, `NOTE`, `HACK`
- Ask for clarification when uncertain; do not proceed based on assumptions

## Dependencies

- Always ask the user before adding new packages or dependencies
- Explain why the dependency is needed

## Error Handling

- When errors occur, read logs and investigate the root cause before attempting fixes
- Do not guess at solutions; understand the problem first

## Security

- **NEVER** include sensitive information in code (API keys, passwords, tokens, credentials)
- Use environment variables or secret management tools for sensitive data
- Do not commit files that may contain secrets (`.env`, `credentials.json`, etc.)

## Session Continuity

- Use `CLAUDE.local.md` (gitignored) to maintain context across sessions
- Record progress in the following situations:
  - When significant progress is made on a task
  - When the user explicitly requests it
- At session start, check `CLAUDE.local.md` for previous context if it exists
- What to record:
  - Investigation findings and decisions made
  - Incomplete task status and next steps
  - Approaches tried and why they failed/succeeded
