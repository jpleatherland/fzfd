# fzfd
Fuzzy file finder written to test the D language.

✨ Features
* Fuzzy search for files using either:
    * Regex patterns
    * String patterns (matches characters in order)
* Configurable depth for directory traversal
* Customizable start path

## 🧭 Options

| Option           | Description                                                                 | Default |
|------------------|-----------------------------------------------------------------------------|---------|
| `-d`, `--depth`  | How many directories deep to search                                        | `0`     |
| `-p`, `--path`   | Path to start the fuzzy search                                             | `.`     |
| `--pattern`      | Explicitly set the search pattern (otherwise first non-flag argument used) |         |

---

## 🔍 Pattern Matching
Patterns can be either:

Regex pattern:
Example:

`fzf t.*st -d 1`  

Fuzzy string pattern (matches files containing those characters in order):
Example:

`fzf tst -d 1`

Matches: test, toast, tempest, tst, etc.

## 📦 Install
Download the binary from the Releases page and place it somewhere in your system PATH.

Usage examples are shown above.

## 🛠️ Build Instructions
Requires the DMD or LDC compiler.

### Using DUB (Recommended)

`dub build`

For a release build:
`dub build --build=release`

### Manual Build with DMD
If you prefer not to use dub, you can compile manually using the DMD compiler:

`dmd -of=fzf -O -release -inline -boundscheck=off source/app.d source/cliargs.d source/fuzzyfind.d source/types.d`

This command compiles the source files and produces an optimized executable named fzf.

>⚠️ This will also generate an intermediate object file fzf.o, which can be safely deleted after the binary is built.

To compile and clean up in one step:

`dmd -of=fzf -O -release -inline -boundscheck=off source/app.d source/cliargs.d source/fuzzyfind.d source/types.d && rm fzf.o`
