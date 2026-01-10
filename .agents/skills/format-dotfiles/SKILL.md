---
name: format-dotfiles
description: Safely review and clean formatting in a dotfiles or configuration repository. Use when asked to fix typos, accidental whitespace, trailing whitespace, missing final newlines, inconsistent indentation, or formatter-induced churn while preserving code, logic, shell quoting, and the repository's established style.
---

# Format Dotfiles

Make mechanical formatting-only edits. Never refactor, reorder configuration, modernize syntax, add quotes, or change behavior unless the user explicitly asks.

## Workflow

1. Inspect `git status --short` first. Treat existing changes as user work and preserve them.
2. Enumerate regular text/configuration files, excluding `.git` and binary/generated assets (especially fonts, images, archives, and lockfiles unless specifically requested).
3. Check for trailing whitespace, missing final newlines, obvious accidental spaces inside paths or configuration values, and malformed indentation.
4. Apply only unambiguous fixes. Leave intentional blank lines, alignment, and stylistic choices alone.
5. Respect local conventions:
   - Makefiles: directives and assignments begin at column 1; recipes use literal tabs. Use `@` only when the user asks to hide a command.
   - Shell: preserve the repository's quoting and indentation; do not add shellcheck-driven refactors.
   - JSON, JSONC, XML, and CSS: retain the file's existing indentation style; do not reorder keys or reformat minified/generated files. For editor-managed files, match reproducible format-on-save behavior, including trailing-comma style, to prevent recurring diffs.
   - Lua: retain tabs when the project uses Stylua tabs.
6. Review the final diff and run proportionate checks: `git diff --check`, parsers for JSON/XML, shell syntax checks, and `make --dry-run` for edited Makefiles. Report pre-existing validation warnings separately.

## Safety Rules

- Do not touch binary files or fonts.
- Do not remove or overwrite unrelated user changes.
- Do not change package lists, command semantics, paths, or configuration values except to remove clearly accidental whitespace.
- If a possible correction is ambiguous, leave it unchanged and ask the user.
