# arch-aur-repo

Arch Linux packaging sources maintained by MoozIiSP.

## Repository layout

```text
packages/                 Locally maintained PKGBUILDs
patches/                  Package-specific patches and helper scripts
packages-x86_64.txt       Legacy AUR build list for x86_64
packages-aarch64.txt      Legacy AUR build list for aarch64
```

## Locally maintained packages

| Package | Architecture | Source |
|---|---|---|
| `hermes-webui` | `any` | [`packages/hermes-webui`](packages/hermes-webui) |
| `lzc-ai-browser` | `x86_64` | [`packages/lzc-ai-browser`](packages/lzc-ai-browser) |
| `selkies` | `x86_64` | [`packages/selkies`](packages/selkies) |

Each directory contains:

- `PKGBUILD`
- generated `.SRCINFO`
- small local service, launcher, or install files required by the package

Downloaded upstream archives, `src/`, `pkg/`, and built packages are excluded
from Git.

## Build locally

```bash
cd packages/<name>
makepkg --syncdeps --cleanbuild
```

To refresh metadata after editing a PKGBUILD:

```bash
makepkg --printsrcinfo > .SRCINFO
```

To verify source checksums without building:

```bash
makepkg --verifysource
```

## Continuous integration

[`.github/workflows/validate.yaml`](.github/workflows/validate.yaml) checks every
package on pushes and pull requests that touch `packages/`:

1. parses each PKGBUILD;
2. verifies that `.SRCINFO` is current;
3. downloads and validates all declared sources;
4. reports `namcap` findings.

The workflow validates packaging sources but does not publish packages or
modify GitHub Releases.

## Legacy AUR build lists

`packages-x86_64.txt` and `packages-aarch64.txt` are retained as input lists
for the repository's earlier AUR build automation. They are not consumed by
the current validation workflow. The related `patches/linux-cachyos/` files
are retained for the listed custom kernel package.
