# Git and GitHub

Git is a distributed version control system with a very clever design.
GitHub is a hosting platform for git repositories.
We use git for all our code, and GitHub for most of our projects.

# Conventions

- branch names
  - lowercase
  - hyphens for separators
  - prefer to include the GitHub issue number
- commit messages
  - 50 character limit for first line
  - prefer to start with a verb, first letter uppercase: fix, add, update, 
- pull requests
  - refer to issue in description using a GitHub keyword: Fixes #123

# Hooks

Git pre-commit hooks can be very helpful for avoiding dumb mistakes.
Just create a shell script in `.git/hooks/pre-commit`.
If it exits with a non-zero exit code, the commit will fail.

Note that hooks are local to your working copy.
They are not versioned, and are not shared when the repo is pushed around.

# GitHub Actions

GitHub Actions are great, but can be a bit of a pain.
The implementation is (mostly?) open and can be run locally.
We mostly use them for Continuous Integration testing.

- [`actions`](https://github.com/actions)
- [`act`](https://github.com/nektos/act) run Actions locally

