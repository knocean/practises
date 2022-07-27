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

[GitHub Actions](https://github.com/actions) are great. The implementation is (mostly?) open. They can be a bit of a pain to master, however. We mostly use them for Continuous Integration testing. In addition, you can use [`act`](https://github.com/nektos/act) to run Actions locally.

What follows is an overview based on our own experience with Github Actions, especially as we have used it in relation to Valve. In particular the examples below are all drawn from the following sources:

- [`ontodev/valve.rs/tree/main/.github/workflows`](https://github.com/ontodev/valve.rs/tree/main/.github/workflows)
- [`ontodev/valve.py/tree/main/.github/workflows`](https://github.com/ontodev/valve.py/tree/main/.github/workflows)

For more detailed and comprehensive information you should refer to GitHub Actions' [official documentation](https://docs.github.com/en/actions).

## Overview and examples

GitHub Action workflows are defined using [YAML](https://yaml.org/) files located in the `.github/workflows/` directory of a given repository. In the following simple example, taken from [ontodev/valve.py](https://github.com/ontodev/valve.py/), we specify a workflow that is automatically triggered whenever there is a push to any branch, or alternately whenever a pull request has been created that is ready for review.

```
name: Valve Tests

on:
  pull_request:
    types:
      - ready_for_review
  push:
    branches:
      - '*'
env:
  CARGO_TERM_COLOR: always
jobs:
  run-tests:
    runs-on: ubuntu-20.04
    steps:
      - name: Setup python
        uses: actions/setup-python@v4
        with:
          python-version: '3.8'

      - name: Check out repository code
        uses: actions/checkout@v3

      - name: Run tests
        run: |
          make test
```

Most of our workflows are triggered by either `push`, `pull_request`, or `release` events. You can find a [complete list of possible trigger events](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows) and the syntax used to specify them in the official documentation.

In the above example our "runner" (i.e., the machine that the specified workflow will be run on) is `ubuntu-20.04`. Instead of explicitly specifying a particular version of the Ubuntu OS, we could have specified `ubuntu-latest` as our runner, but it is generally a good idea to be more explicit, especially if the action is intended to be long-lived. That way a change in what GitHub considers to be the "latest" version of Ubuntu will not break our workflow. You can find the [complete list of GitHub-provided runners](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners) and their specifications in the official documentation. GitHub-provided runners normally suffice for our purposes but it is also possible to use a [custom or "self-hosted" runner](https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners).

The workflow in the above example consists of a single job called `run-tests` with three steps. The first two steps, **Setup python** and **Check out repository code**, each call an externally defined [reusable workflow](https://docs.github.com/en/actions/using-workflows/reusing-workflows#reusable-workflows-and-starter-workflows). These are [actions/setup-python](https://github.com/actions/setup-python) and [actions/checkout](https://github.com/actions/checkout), respectively. Reusable workflows may be provided by GitHub, by a third party, or you can also [create your own](https://docs.github.com/en/actions/using-workflows/reusing-workflows#creating-a-reusable-workflow). Many commonly used reusable workflows can be found on the [GitHub Marketplace](https://github.com/marketplace?category=&query=&type=actions&verification=).

Let us move on to a slightly more complicated workflow example. Here is a variation on the foregoing example that illustrates the use of a [matrix strategy](https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs):

```
name: Run tests

on:
  pull_request:
    types:
      - ready_for_review
  push:
    branches:
      - '*'

env:
  CARGO_TERM_COLOR: always

jobs:
  run-tests:
    strategy:
      matrix:
        python-version: ["3.8", "3.9", "3.10"]
    runs-on: ubuntu-20.04
    steps:
      - name: Set up Python version ${{ matrix.python-version }}
        uses: actions/setup-python@v4
        with:
          python-version: ${{ matrix.python-version }}

      - name: Check out repository code
        uses: actions/checkout@v3

      - name: Run tests via Makefile
        run: |
          make test
```

This workflow launches three `ubuntu-20.04` runners in parallel, with three python versions (3.8, 3.9, and 3.10, respectively), and runs `make test` on each.

Finally, consider the following more complicated example workflow taken from [ontodev/valve.rs](https://github.com/ontodev/valve.rs/):

```
name: Create and upload artifacts

on:
  release:
    types: [released]

env:
  CARGO_TERM_COLOR: always

jobs:
  build-binaries:
    strategy:
      matrix:
        target: [
          { runner: "macos-11", arch: "x86_64-apple-darwin" },
          { runner: "macos-11", arch: "aarch64-apple-darwin" },
          { runner: "windows-2022", arch: "x86_64-pc-windows-msvc" },
          { runner: "ubuntu-20.04", arch: "x86_64-unknown-linux-gnu" },
          { runner: "ubuntu-20.04", arch: "x86_64-unknown-linux-musl" },
        ]
    runs-on: ${{ matrix.target.runner }}
    steps:
      - name: Check out repository code
        uses: actions/checkout@v3

      - name: Install musl-tools (MUSL)
        if: ${{ matrix.target.runner == 'ubuntu-20.04' && matrix.target.arch == 'x86_64-unknown-linux-musl' }}
        run: |
          sudo apt-get update
          sudo apt-get install musl-tools

      - name: Install latest rust toolchain
        uses: actions-rs/toolchain@v1
        with:
          toolchain: stable
          target: ${{ matrix.target.arch }}
          default: true
          override: true

      - name: Build binary using cross (Linux)
        if: ${{ matrix.target.runner == 'ubuntu-20.04' }}
        run: |
          cargo install cross --git https://github.com/cross-rs/cross
          sudo systemctl start docker
          cross build --release --target ${{ matrix.target.arch }}
          cp target/${{ matrix.target.arch }}/release/ontodev_valve ontodev_valve-${{ matrix.target.arch }}

      - name: Build binary using cargo (MacOS)
        if: ${{ matrix.target.runner == 'macos-11' }}
        run: |
          cargo build --release --target ${{ matrix.target.arch }}
          cp target/${{ matrix.target.arch }}/release/ontodev_valve ontodev_valve-${{ matrix.target.arch }}

      - name: Build binary using cargo (Windows)
        if: ${{ matrix.target.runner == 'windows-2022' }}
        run: |
          cargo build --release --target ${{ matrix.target.arch }}
          cp target\${{ matrix.target.arch }}\release\ontodev_valve.exe ontodev_valve-${{ matrix.target.arch }}.exe

      - name: Upload binary to release
        uses: svenstaro/upload-release-action@v2
        with:
          file: ontodev_valve-${{ matrix.target.arch }}*
          file_glob: true
          tag: ${{ github.ref }}
          overwrite: true

  cargo-publish:
    needs: build-binaries
    runs-on: ubuntu-20.04
    steps:
      - name: Check out repository code
        uses: actions/checkout@v3

      - name: Install latest rust toolchain
        uses: actions-rs/toolchain@v1
        with:
          toolchain: stable
          target: ${{ matrix.target.arch }}
          default: true
          override: true

      - name: Publish to crates.io
        env:
          CARGO_REGISTRY_TOKEN: ${{ secrets.CARGO_REGISTRY_TOKEN }}
        run: |
          cargo publish
```

This workflow, which is triggered whenever a release is created in GitHub, consists of two jobs: `build-binaries` and `cargo-publish`. The goal of the `build-binaries` job is to compile the rust code in [ontodev/valve.rs](https://github.com/ontodev/valve.rs/) for the various different architectures that have been specified in `matrix.target`, and then upload these to the given release page (see, e.g., https://github.com/ontodev/valve.rs/releases/tag/v0.1.8). Since the process by which the code is compiled, and the files uploaded, will vary depending on the underlying architecture, we use a number of conditional steps which we specify using the [if](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idif) directive. For instance, the `musl-tools` package is only required to be installed if we are compiling for the Ubuntu MUSL architecture, so we use the following conditional directive:


    if: ${{ matrix.target.runner == 'ubuntu-20.04' && matrix.target.arch == 'x86_64-unknown-linux-musl' }}

The `cargo-publish` job, which publishes the code as a crate on [crates.io](https://crates.io/), is required to wait until the `build-binaries` job has completed successfully before launching. We specify this by using the keyword [needs](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idneeds).

Note that the environment variable `CARGO_REGISTRY_TOKEN`, which is required to be specified in order to publish a crate to crates.io, is drawn from a secret that must have been previously added to the current repository. The secret in this case is actually an API token generated on crates.io. The documentation for the `cargo` command contains [instructions for generating an API token on crates.io](https://doc.rust-lang.org/cargo/reference/publishing.html), and [instructions for adding the API token to your GitHub repository](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository) can be found in the official GitHub Actions documentation.

Similar considerations apply when publishing to other public packaging repositories. [Instructions for using GitHub Actions with the Python Package Index (PyPI)](https://packaging.python.org/en/latest/guides/publishing-package-distribution-releases-using-github-actions-ci-cd-workflows/#publishing-package-distribution-releases-using-github-actions-ci-cd-workflows), for instance, can be found on the PyPI website.
