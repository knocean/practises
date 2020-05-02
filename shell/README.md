# Shell

The Unix command line provides a user interface to the system,
and allows incredibly flexible composition of programs.
Although `bash` is a great interactive shell,
plain POSIX `sh` is fine for scripting and more portable.
When control flow gets complex,
implement that functionality as a Python script or CLI tools in another language,
and call it from the shell.
Use a `Makefile` to coordinate shell invocations for each project.

# Links

- [bultins and utilities](http://shellhaters.org)
- [shell tutorial](https://www.grymoire.com/Unix/Sh.html)
- [productivity tips](https://blog.balthazar-rouberol.com/shell-productivity-tips-and-tricks.html)
- [shell tricks](https://www.etalabs.net/sh_tricks.html)
- [bash obsolete syntax](https://wiki.bash-hackers.org/scripting/obsolete) with replacements

# Utilities

Here are useful utilities to call from a shell.
They're roughly sorted by how often we use them
(Note the Nix package name if it differs from the command itself.)

[GNU Coreutils](https://www.gnu.org/software/coreutils/manual/coreutils.html)
cover the basic system operations.

- `tree` list files directories as a tree
- [`tldr`](https://tldr.sh/) quick command-line examples to supplement `--help` and `man`
  (also <https://tldr.ostera.io> and `!tldr` on [DuckDuckGo](https://duckduckgo.com))
- `xlsx2csv` e.g. `xlsx2csv --delimiter tab --sheetname Foo bar.xlsx > bar.tsv`
- `dos2unix` fix line endings
- [`pandoc`](https://pandoc.org) document format conversion, especially Markdown
- [`vcsh`](https://github.com/RichiH/vcsh) config (dotfiles) manager based on git
- [`semver`](https://github.com/fsaintjacques/semver-tool) (Nix `semver-tool`)
  handy operations on Semantic Versioning strings
- `envsubt` (inside Nix `readline`) substitute environment variables into a file
- [`j2cli`](https://github.com/kolypto/j2cli) Jinja2 templates CLI
- [`entr`](http://eradman.com/entrproject/) run command on file change
- [`pick`](https://github.com/mptre/pick) interactive selection
- [`fzf`](https://github.com/junegunn/fzf) fuzzy finder

# Layers

Unix terminals have evolved from teletype machines
to support incredible features.

## Terminal

Send and display messages from a computer system:

- [teletype](https://en.wikipedia.org/wiki/Teleprinter) (tty):
  send messages to a computer with a keyboard (STDIN),
  receive messages with a line-based printer (STDOUT)
- console: send via keyboard, receive on a screen
- terminal emulator: abstract the input and output,
  display in an application window
    - Linux: many options
    - macOS: Terminal.app (builtin), iTerm2
    - iOS: [Blink](https://blink.sh)

## Shell

An interactive program that uses a terminal
to provide user interface to a computer operating system

- `sh` (POSIX shell): the Unix standard shell
- `bash` (Bourne-Again Shell): most common shell, extends basic `sh`
- `ssh`: run a shell on a remote system via a secure connection
- [`mosh`](https://mosh.org): mobile shell, like `ssh` but uses UDP for better roaming
- `screen`: runs one or more shells, persists after user disconnects
- [`tmux`](https://github.com/tmux/tmux): terminal multiplexer,
  like `screen` but with multiple windows and splits
- shell script: a file containing shell commands to execute

## Example

This is what I do every day:

- open the Blink terminal emulator for iOS
- connect to a remote machine with `mosh`
- reconnect to a persistent `tmux` session
- open a new `tmux` window: a `bash` shell
- start `neovim`
- open `neovim` buffers for file editing
  and embedded terminals running `bash`
- run a 
- jump between different files, shells, projects, and systems

# Quoting

One of the trickiest aspects of shells is quoting.
Generally speaking, the shell will split arguments on whitespace.
(This is controlled by the special `IFS` (Internal Field Separator) variable.)
To avoid that splitting, wrap your string in single or double quotes.
The shell will expand variables inside double quotes.
It's safest to use double quotes unless you're sure you don't want them.

```shell
$ echo '$HOME'
$HOME
$ echo "$HOME"
/Users/james
$ echo "$HOMErun"

$ echo "${HOME}run"
/Users/jamesrun
```

# Flow Control (Pipes)

- `foo; bar` run `foo` then `bar`, sequentially
- `foo & bar` run `foo` and `bar` (in parallel)
- `foo && bar` run `foo`, and if it exits 0 then run `bar`
- `foo || bar` run `foo`, and if it exits non-0 then run `bar`
- `foo | bar` run `foo` and send its output (STDOUT and STDERR) as STDIN to `bar`
- `foo > bar` run `foo` and write its output to the file `bar`
- `foo >> bar` run `foo` and append its output to the file `bar`
- `foo < bar` send the contents of the file `bar` as input to `foo`

# Shell Variables

- `$?` exit code of previous command
- `$(foo)` run subshell
- `${variable}` is safer than `$variable`
- `${variable:?word}` complain if undefined or null
- `${variable:-word}` use new value if undefined or null
- `${variable:+word}` opposite of the above
- `${variable:=word}` use new value if undefined or null, and redefine

# Shell Expansions

- `!-n` rerun nth previous command
- `^string1^string2` substitute "string1" for "string2" in previous line
- `*` and `**` file globs
- `{foo,bar}` or `{1..10}` brace expansion (combinations)

# Keyboard Shortcuts

These mostly match Emacs shortcuts:

- `<c-c>` cancel
- `<c-d>` disconnect
- `<c-l>` clear
- `<c-z>` send process to background (then run `fg` to resume)
- `<c-a>` start of line
- `<c-e>` end of line
- `<c-p>` previous line in history (also up arrow)
- `<c-n>` previous line in history (also down arrow)
- `<c-r>` search history
- `<c-w>` cut previous word
- `<c-k>` cut to end of line
- `<c-u>` cut to start of line
- `<c-y>` paste cut buffer

# Linting

[shellcheck](https://www.shellcheck.net) is an amazing tool
for checking the syntax and style of shell scripts.
You can add this to your `Makefile`:

```make
.PHONY: lint
lint:
	shellcheck *.sh
```

It can be tricky to detect which files are shell scripts,
so tell `shellcheck` explicitly which files to look at.
