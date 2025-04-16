# Nix Flake Template Foundation

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A minimal yet powerful foundation for creating Nix flake templates. Perfect for bootstrapping new projects with consistent tooling and best practices.

## Features

- Integrated development environment via [devenv](https://devenv.sh)
- Pre-configured Git hooks via [git-hooks.nix](https://github.com/cachix/git-hooks.nix):
  - [flake-checker](https://github.com/DeterminateSystems/flake-checker) for Nix validation
  - [deadnix](https://github.com/astro/deadnix) detection
  - Formatting using [treefmt](https://github.com/numtide/treefmt)
- [direnv](https://direnv.net) integration with .envrc (auto-loads devenv)
- Example `Hello, World!` implementation

## Important notes

As stated by on the [devenv guide](https://devenv.sh/guides/using-with-flakes/#the-flakenix-file):

> Flakes use "pure evaluation" by default, which prevents devenv from
> figuring out the environment its running in: for example, querying the
> working directory. The --no-pure-eval flag relaxes this restriction.

> An alternative, and less flexible, workaround is to override the
> devenv.root option to the absolute path to your project
> directory. This makes the flake non-portable between machines, but
> does allow the shell to be evaluated in pure mode.

## Getting Started

1. Create your template repository

```bash
# In the current directory
nix flake init -t github:monologique/flake-template

# In a new directory
nix flake new my-new-template -t github:monologique/flake-template
```

2. Activate development environment

> Note: direnv will automatically load the environment when entering the directory

```bash
# Without direnv
nix develop --no-pure-eval

# With direnv
direnv allow
```

## Usage

| Command                          | Description                |
| -------------------------------- | -------------------------- |
| `devenv up`                      | Start development services |
| `devenv test`                    | Run validation checks      |
| `nix fmt`                        | Format Nix files           |
| `nix flake check --no-pure-eval` | Run tests suites           |

## Registry Setup (For Frequent Use)

1. Add to your Nix registry

```bash
nix registry add monologique-flake github:monologique/flake-template
```

2. Initialize the template

```bash
# In the current directory
nix flake init -t monologique-flake

# In a new directory
nix flake new /tmp/project-directory -t monologique-flake
```

## Contributing

PRs welcome! Please:

1. Test with `--no-pure-eval` flags
2. Maintain existing formatting standards (nix fmt)
3. Update documentation accordingly
