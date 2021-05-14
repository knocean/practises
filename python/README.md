# Python

Python hits a sweet spot between short shell scripts and large applications.
We use Python 3.6+ for largish scripts and smallish libraries.

## Links

- [Python 3 documentation](https://docs.python.org/3/)
    - Search with `!py` in [DuckDuckGo](https://duckduckgo.com)

## Setup

Use [`venv`](https://docs.python.org/3/library/venv.html)
to isolate your Python version and libraries from other projects.
Each project using Python should have a `.venv` subdirectory.

```shell
$ python3 -m venv .venv
$ source .venv/bin/activate
```

Use `pip` and a `requirements.txt` to install libraries:

```shell
$ pip install -r requirements.txt
```

It's better to specify exact versions of your dependencies.
You can install from `git` and other
[version control systems](https://pip.pypa.io/en/stable/cli/pip_install/#vcs-support).
This example uses the HTTPS URL from GitHub's Code / Clone button:

```shell
$ pip install git+https://github.com/ontodev/gizmos.git
```

This `git+https://github.com/ontodev/gizmos.git` can also be a line in `requirements.txt`.

## Style

- write imperative code, avoid Object Oriented design
- avoid global state, for the most part
- use [`flake8`](https://pypi.org/project/flake8/) to enforce style
- use [`black`](https://black.readthedocs.io/en/stable/) for formatting
- use [`argparse`](https://docs.python.org/3/library/argparse.html) for CLIs
- use [`pytest`](https://docs.pytest.org/en/latest/) for tests

We use `flake8` and `black` to enforce a standard style.
Our main change to the defaults is 100 character lines.
We also ignore [E203](https://www.flake8rules.com/rules/E203.html)
and [W503](https://www.flake8rules.com/rules/W503.html).

If you're using a [`Makefile`](Makefile), then these are good defaults:

```make
PYTHON_FILES := src tests

.PHONY: test
test:
	pytest tests

.PHONY: lint
lint:
	flake8 --max-line-length 100 --ignore E203,W503 $(PYTHON_FILES)
	black --line-length 100 --quiet --check $(PYTHON_FILES)

.PHONY: format
format:
	black --line-length 100 $(PYTHON_FILES)
```

You can use a basic `.git/hooks/pre-commit` like this:

```
#!/bin/sh
make test lint
```

This [`pre-commit`](pre-commit) script is more careful with unstaged changes,
and doesn't require a `Makefile`.

## Tests

- for single-file scripts, include tests in the same file
- for multi-file projects, use a `tests/` directory

## Packaging

Except for one-off scripts, consider proper packaging for your Python projects,
either as a module for local installs or for [PyPI](https://pypi.org).
Python is old enough that there's been a few generations
of packaging standards and tools.
We've had luck with this guide:
<https://realpython.com/pypi-publish-python-package/>.

You can install a package locally (often useful for development) like this:

```
pip install -e .
```

## F-strings, PEP 498

I really like the [f-string](https://www.python.org/dev/peps/pep-0498/)
syntax introduced in Python 3.6.

```python
print(f"This is {foo} and {bar.upper()}.")
```

## TSV

We work with a lot of TSV files.
Use Unix line endings.
It's usually convenient to use `DictReader` and `DictWriter`,
rather than the default `reader` and `writer`.

```python
import csv

with open(path) as fh:
    rows = csv.DictReader(fh, delimiter="\t")
    for row in rows:
        pass

with open(path, "w") as fh:
    fieldnames = ["foo", "bar"]
    writer = csv.DictWriter(fh, fieldnames, delimiter="\t", lineterminator="\n")
    writer.writeheader()
    writer.writerows(rows)
```
