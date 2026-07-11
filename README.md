# arch-aur-repo

Arch Linux PKGBUILD collection and binary repository automation.

## Local packages

| Package | Architecture | Source |
|---|---|---|
| `hermes-webui` | `any` | [`packages/hermes-webui`](packages/hermes-webui) |
| `lzc-ai-browser` | `x86_64` | [`packages/lzc-ai-browser`](packages/lzc-ai-browser) |
| `selkies` | `x86_64` | [`packages/selkies`](packages/selkies) |

Each package directory contains its `PKGBUILD`, generated `.SRCINFO`, and any
small local source/service/install files required by the build. Binary packages
and downloaded upstream archives are intentionally not committed.

Build a package with:

```bash
cd packages/<name>
makepkg --syncdeps --cleanbuild
```

AUR package names listed in `packages-x86_64.txt` and `packages-aarch64.txt`
are handled separately by the repository workflow.
