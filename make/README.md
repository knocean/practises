# Make

Make is a build automation tool.
It was created in 1976,
and it's far from perfect,
but it's good enough for a lot of automation tasks.

There are several versions of Make now.
I recommend [GNU Make](https://www.gnu.org/software/make/).

## Links

- Manual https://www.gnu.org/software/make/manual/make.html
- a style guide https://clarkgrubb.com/makefile-style-guide

## A Tree of Shell Scripts

I like to think of Make on a spectrum.
First you have ad hoc shell commands that you type into your terminal.
Then you want to repeat those commands,
so you copy them to a text file
so that you can copy-paste them later.
When that becomes tedious,
you turn those commands into a shell script.
Pretty soon you have a directory full of shell scripts
for slightly different tasks,
and your automation takes forever
because it has to rebuild everything from scratch each time.
Now you see the need for Make.

I think of a `Makefile` as defining a tree of shell scripts.
First you list the file that you want (the "goal"),
then the files that you need to build your goal (the dependencies),
and finally a shell recipe to transform those inputs into your output.
If you ask Make to build that goal,
it will first check to see if the goal file exists.
If it does exist,
Make will check whether any of the dependency files are newer than the goal file.
If the goal file is newer than all of them,
Make just will tell you that the goal file is up to date and quit.
If any of the dependencies are newer than the goal file,
Make will run the recipe to rebuild the goal file from the dependencies.

By itself, that's not very impressive,
but you can do this in as many layers as you want.
For a given goal Make will figure out all the recursive dependencies
required to build that goal.
Make will check all the timestamps,
and only build the subset of dependencies that are required.
This can save a lot of time and energy.

Make is more complicated than this,
but if you can internalize this basic model
you'll be able to figure out the rest.

## Better Make Defaults

Make has some surprising behaviours out-of-the-box.
I recommend setting
[these defaults](https://clarkgrubb.com/makefile-style-guide)
at the top of your `Makefile`:

```
MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:
```

This will:

- warn if you use a variable without defining it
- always use `bash`, not some other unexpected shell
- tell `bash` to fail early and more predictably on errors
- run `make all` if you just type `make`
- turn off default [Old-fashioned suffix rules](https://www.gnu.org/software/make/manual/make.html#Suffix-Rules)

## Common Goals

Most `Makefile`s should define most of these goals:

- `all`: build (pretty much) everything for this project;
  this is usually the default goal if you just run `make`
- `test`: test the results of `all`
- `clean`: remove temporary files, but maybe not expensive cached files
- `clobber`: run `clean` but also remove expensive cached files
- `install` if you're building some sort of software

## Variables

Make variables are pretty close to shell variables,
with some 

- `:=` eager assignment: assign when first read
- `=` lazy assignment: assign when first used
- `$()` variable interpolation
- `$$` dollar-sign escaping

`Makefile`s often contain some strange glyphs
that may be scary at first.
Most of these are
["Automatic variables"](https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html#Automatic-Variables).
Here are the most important ones: 

- `%` wildcard match in goals, similar to a fileglob `*` in shell
- `$*` whatever was matched by `%` for the current goal
- `$@` the current goal
- `$<` the first dependency
- `$^` a space-separated list of all the dependencies

## Functions

Make includes a number of
[functions](https://www.gnu.org/software/make/manual/make.html#Functions),
mainly for manipulating strings and lists of strings.
Here are some of the functions that I find most useful:

- `$(word n,text)`: select the `n`th word from a space-separated list
- `$(foreach var,list,text)`: for each `var` in `list` return `text` (with substitution)
- `$(shell cat foo)`: run a shell command
- filenames: `dir`, `notdir`, `basename`, `suffix`, `wildcard`

## Special Built-in Target Names

`.PHONY:` used when the goal is not actually a file.
This applies to `all` and `test`.
For a PHONY goal, Make will not check to see that it exists,
it will always just build the dependencies
and run the recipe.

`.PRECIOUS:` by default, Make if you ask Make to build B
and B depends on A,
then A is considered an "intermediate" file.
Make will build A and then B, then delete the intermediate file A.
This can be surprising.
If you mark A as PRECIOUS
then even if it is an intermediate file
it will not be deleted.

## A Better Make?

Make has obvious warts.
Since 1976 everybody has tried to build a better Make.
But I still use and recommend Make.
Why?

First, if you're just building software,
then your language-specific build tools are almost certainly better than Make.
Use them instead of Make.
But I use make for automating all sorts of other things,
not just building software.

Second, it's easy to shoot yourself in the foot with Make.
It has a lot of powerful features.
It works quite differently from other tools you're likely familiar with.
I recommend sticking to the basic features,
described here.
That will get you a long way
and avoid most of the "footguns".

In my opinion,
these are the main problems with using Make for build automation:

1. it's Unix-specific, so hard to use on Windows
2. tabs are surprising at first
3. the common special variables look weird
4. I don't like some of the defaults
5. it would be better to compare files with hashes than timestamps
6. there are no good parsers

Cross-platform compatibility is the biggest problem,
and people have tried to address it in various ways.
Various programming language-specific build tools have succeeded
for the specific use case of building software,
but at the cost of abandoning the power and flexibility of the Unix shell.

Problems 2-4 are "warts" that I can live with.

Problem 5 is at the heart of how Make works.
It really would be better to hash files and compare hashes
instead of relying on timestamps to see if a dependency needs updating.
[`redo`](https://redo.readthedocs.io/en/latest/)
works this way,
and looks very elegant.
But `redo` gives up one of my favourite things about Make,
which is keeping everything in one `Makefile`.
Instead `redo` favours multiple `*.do` script files.
They like that approach better,
and I just have to agree to disagree.

Problem 6 really bothers me.
Why can't I get an AST of a Makefile to use for something else,
like a linter?
There's a declarative language in the `Makefile` trying to get out.
Unfortunately the implementation of Make
seems to couple the reading with the execution quite tightly.
You can run `make --just-print` to see something of the internals,
but that isn't as well-structured as I would like either.
There's various code out there to try and visualize a `Makefile` as a graph,
which is a good idea,
but all the ones I've seen are a bit hacky
because of this limitation of Make.

