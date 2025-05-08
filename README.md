# Nix Flake Template Foundation

[![built with nix][nix-badge]][nix-url]
[![License: MIT][license-badge]][license-url]
[![ci workflow][ci-badge]][ci-url]

[nix-badge]: https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a
[nix-url]: https://builtwithnix.org
[license-badge]: https://img.shields.io/badge/License-MIT-yellow.svg
[license-url]: https://opensource.org/licenses/MIT
[ci-badge]: https://github.com/monologique/nix-flake-template/actions/workflows/ci.yml/badge.svg
[ci-url]: https://github.com/monologique/nix-flake-template/actions/workflows/ci.yml

A minimal yet powerful foundation for creating Nix flake templates. Perfect for bootstrapping new projects with consistent tooling and best practices.

## Features

- Pre-configured Git hooks via [git-hooks.nix](https://github.com/cachix/git-hooks.nix):
  - [flake-checker](https://github.com/DeterminateSystems/flake-checker) for Nix validation
  - [deadnix](https://github.com/astro/deadnix) detection
  - Formatting using [treefmt](https://github.com/numtide/treefmt)
- Example `Hello, World!` implementation

## Getting Started

1. Create your template repository

```bash
# In the current directory
nix flake init -t github:monologique/nix-flake-template

# In a new directory
nix flake new my-new-template -t github:monologique/nix-flake-template
```

2. Activate development environment

> Note: direnv will automatically load the environment when entering the directory

```bash
# Without direnv
nix develop -c "$SHELL"

# With direnv
direnv allow
```

## Usage

| Command           | Description                |
| ----------------- | -------------------------- |
| `nix develop`     | Start development services |
| `nix fmt`         | Format using treefmt       |
| `nix flake check` | Run tests suites           |

## Registry Setup (For Frequent Use)

1. Add to your Nix registry

```bash
nix registry add monologique-dune github:monologique/nix-flake-template
```

2. Initialize the template

```bash
# In the current directory
nix flake init -t monologique-dune

# In a new directory
nix flake new /tmp/project-directory -t monologique-dune
```

## Contributing

PRs welcome! Please:

1. Test with `--no-pure-eval` flags
2. Maintain existing formatting standards (nix fmt)
3. Update documentation accordingly
