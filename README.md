# How We Work

[Knocean](http://knocean.com) is a small consulting company. This is a brief description of how we work, with some attempt at justification.

As people, we strive to live good lives. Good work is one part of a good life, so we:

- treat people well: each other, our clients, our collaborators, the people who use the tools we build, etc.
- choose good projects: open science, open source, specializing in [Open Biological and Biomedical Ontologies](http://obofoundry.org)
- work publicly, so our work is shared
- work asynchronously, so we can work when it suits us
- work remotely, so we can live where it suits us
- limit our work time: take proper time off, encourage part-time work, etc.
- do work that we're proud of

# Guiding Principles

- programming is mostly about people
- use text
- use small, sharp tools
- use the tools we build
- don't repeat yourself
- automate
- use version control
- use open source

## Programming is Mostly About People

- prefer public GitHub and mailing lists
- use private Slack for quick questions
- use private GitHub projects for detailed scheduling
- weekly one-on-one meetings, with audio
- code review is important, and hard!
- documentation is important, and hard!
- use automated style tools to avoid pointless arguments

## Use Text

- text is ubiquitous: documents, email, messaging, issues, web forms, terminals, etc.
- use UTF-8 for pretty much everything
- use your preferred text editor for pretty much everything
- there's a spectrum from unstructured to highly structured text

## Use Small, Sharp Tools

- use the right tool for the job
- break complex jobs down into a series of simple jobs
- collect a toolbox of good tools and master them
- small, sharp tools are easier to learn and remember
- they stand the test of time

## Use the Tools we Build

We're among the main users of the tools we build, and we have to live with them for years to come. This encourages use to build tools that are:

- simple and focused
- effective
- reliable
- pleasant to use
- efficient

## Don't Repeat Yourself

Life is easier if everything has one canonical source, with one canonical name.

## Automate

There's a rough spectrum of automation:

- ad hoc jobs: Unix coreutils, pipes, "one liners"
- small jobs: Bash script
- medium jobs: Python script
- large jobs: new command-line tool
- job management: GNU Make
- orchestration

## Version Control

- text is easy to diff and patch
- git works best with text
- don't store generated files in version control
- store all the information needed to rebuild:
  - versioned install details
    - NixOS `shell.nix`
    - Python `requirements.txt`
    - Maven `pom.xml`
  - versioned code
  - versioned build script (`Makefile`)
  - versioned inputs, maybe external

## Use Open Source

Life is easier if we can:

- see the source of the tools we use, especially when there's a bug
- reuse the tools we write for the next project

Arguably, good science requires open source tools.


# Common Tools

Based on those principles, these are the common tools and platforms that we build on:

- Text Formats
- Unix (Linux, macOS, NixOS): coreutils, command-line tools
- GNU Make
- git, GitHub
- World Wide Web
- Java: a poor language with an excellent runtime (JVM) and many good libraries
- Python: an acceptable language, lingua franca, good for scripting
- Clojure: an excellent language, but "obscure"
- SQLite, Postgres

## Text Formats

- document formats
  - Markdown
  - HTML, separating content from style
  - LaTeX, for advanced layout
- tabular data
  - TSV, CSV
  - SQL
  - Excel: for aggregation, visualization
- structured data
  - EDN: perfect balance, but mostly limited to Clojure
  - YAML: human readable, overly complex syntax
  - XML: well-structured, hard to read
  - Turtle: for RDF
  - Manchester: for OWL
  - JSON: poor balance of features but ubiquitous

## Unix

- use Linux for servers, prefer NixOS
- macOS is acceptable for desktops/laptops
- provisioning
  - prefer NixOS
  - otherwise use Ansible 2
  - prefer official packages
- use AWS EC2 but be careful about platform lock-in
- everything is a file, most files are streams of delimited text
- Unix coreutils: ls, grep, find, sed, awk
- standard Unix tools: ssh, curl
- good command-line tools: tree, mosh, xlsx2csv, Pandoc, RDF rapper

## GNU Make

- tell Make all the prerequisites, so it can build the full dependency graph
- tell Make all the outputs, preferably just one
- keep recipes to a handful of lines
- convert larger recipes to scripts: Bash or Python
- try to match script arguments with prerequisites exactly, then just `python3 $^ $@`
- use Make functions and special variables, but strive for clarity
- empty files are OK

## World Wide Web

- stick to basics!
- use HTTPS whenever possible, prefer Let's Encrypt for SSL certificates
- HTML is good for display, but prefer source data in simpler formats, e.g. Markdown
- use Bootstrap 4, avoid custom CSS
- prefer Nginx, but Apache 2 is fine
- use static HTML as long as possible
- use Python Flask for dynamic sites
- use Jinja2 for templates
- use a small set of mature libraries
  - jQuery
  - InspireTree
  - MomentJS
  - CodeMirror
  - Twitter Typeahead
- write minimal vanilla JavaScript "glue"
- use JavaScript for progressive enhancement
  - site must work without JavaScript, for cURL etc.
  - corollary: avoid Single Page Web Applications

## Java

- ubiquitous, cross-platform
- strong ecosystem of heavy libraries, especially for the Semantic Web
    - we mainly use Java for ROBOT, which relies on OWLAPI and Apache Jena
- use Java 8 features
- use Maven
- use Google Java Style and fmt-maven-plugin
- write imperative code, rely on collections, avoid excessive Object Oriented design

## Python

- ubiquitous, cross-platform
- good for scripting, interactive development
- strong ecosystem of libraries for almost anything
- use for anything more than about 10 lines of Bash
- use Python 3
- write imperative code, avoid Object Oriented design
- use `virtualenv`
- use `requirements.txt`
- use `argparse`
- use `pytest`
- avoid excessive OO

## Clojure

Clojure is an excellent language, but its "obscurity" makes it hard to choose for collaborative projects.


