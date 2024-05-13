def "nu-complete just recipes" [] {
    ^just --unsorted --dump --dump-format json
        | from json
        | get recipes
        | transpose k v
        | each {|x|
            {
                value: $x.k,
                description: ( $x.v.parameters
                             | each {|y|
                                    if ($y.default|is-empty) {
                                        $y.name
                                    } else {
                                        $'($y.name)="($y.default)"'
                                    }
                                }
                             | str join ' '
                             )
            }
        }
}

def "nu-complete just args" [context: string, offset: int] {
    let r = ($context | split row ' ')
    ^just -u --dump --dump-format json
        | from json
        | get recipes
        | get ($r.1)
        | get body
        | each {|x| {description: ($x | get 0) }}
        | prepend ''
}

# 🤖 Just a command runner - https://github.com/casey/just
export extern just [
  recipes?:                string@"nu-complete just recipes",      # Overrides and recipe(s) to run, defaulting to first recipe in the justfile
  ...args:                 any@"nu-complete just args"
  --changelog                                                      # Print changelog
  --check                                                          # Run `--fmt` in 'check' mode. Exits with 0 if justfile is formatted correctly. Exits with 1 and prints a diff if formatting is required.
  --choose                                                         # Select one or more recipes to run using a binary chooser. If `--chooser` is not passed the chooser defaults to the value of $JUST_CHOOSER, falling back to `fzf`
  --clear-shell-args                                               # Clear shell arguments
  --dry-run(-n)                                                    # Print what just would do without doing it
  --dump                                                           # Print justfile
  --edit(-e)                                                       # Edit justfile with editor given by $VISUAL or $EDITOR, falling back to `vim`
  --evaluate:              string                                  # Evaluate and print all variables. If a variable name is given as an argument, only print that variable's value.
  --fmt                                                            # Format and overwrite justfile
  --highlight                                                      # Highlight echoed recipe lines in bold
  --init                                                           # Initialize new justfile in project root
  --list(-l)                                                       # List available recipes and their arguments
  --no-deps                                                        # Don't run recipe dependencies
  --no-dotenv                                                      # Don't load `.env` file
  --no-highlight                                                   # Don't highlight echoed recipe lines in bold
  --quiet(-q)                                                      # Suppress all output
  --shell-command:         string                                  # Invoke <COMMAND> with the shell used to run recipe lines and backticks
  --summary                                                        # List names of available recipes
  --unsorted(-u)                                                   # Return list and summary entries in source order
  --unstable                                                       # Enable unstable features
  --variables                                                      # List names of variables
  --verbose(-v)                                                    # Use verbose output
  --yes                                                            # Automatically confirm all recipes.
  --help(-h)                                                       # Print help information
  --version(-V)                                                    # Print version information
  --chooser:               string                                  # Override binary invoked by `--choose`
  --color:                 string@"nu-complete just color"         # Print colorful output [default: auto]
  --command(-c):           string                                  # Run an arbitrary command with the working directory, `.env`, overrides, and exports set
  --command-color:         string@"nu-complete just command-color" # Echo recipe lines in <COMMAND-COLOR>
  --completions:           string@"nu-complete just completions"   # Print shell completion script for <SHELL>
  --dotenv-filename:       string                                  # Search for environment file named <DOTENV-FILENAME> # instead of `.env`
  --dotenv-path:           string                                  # Load environment file at <DOTENV-PATH> instead of searching for one
  --dump-format:           string@"nu-complete just format"        # Dump justfile as <FORMAT> [default:       just]
  --justfile(-f):          string                                  # Use <JUSTFILE> as justfile
  --list-heading:          string                                  # Print <TEXT> before list
  --list-prefix:           string                                  # Print <TEXT> before each list item
  --set:                   any                                     # <VARIABLE> <VALUE> Overrides <VARIABLE> with <VALUE>
  --shell:                 string                                  # Invoke <SHELL> to run recipes
  --shell-arg:             string                                  # ... Invoke shell with <SHELL-ARG> as an argument
  --show(-s):              string@"nu-complete just recipes"       # Show information about <RECIPE>
  --working-directory(-d): string                                  # Use <WORKING-DIRECTORY> as working directory. --justfile must also be set
]

def "nu-complete just format" [] {
    [just json]
  }

def "nu-complete just completions" [] {
  [zsh, bash, fish, powershell, elvish]
}

def "nu-complete just color" [] {
  [auto always never]
}

def "nu-complete just command-color" [] {
  [black, blue, cyan, green, purple, red, yellow]
}
