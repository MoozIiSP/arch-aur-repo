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
| `hermes-lazycat-environment` | `any` | [`packages/hermes-lazycat-environment`](packages/hermes-lazycat-environment) |
| `hermes-webui` | `any` | [`packages/hermes-webui`](packages/hermes-webui) |
| `lzc-ai-browser` | `x86_64` | [`packages/lzc-ai-browser`](packages/lzc-ai-browser) |
| `selkies` | `x86_64` | [`packages/selkies`](packages/selkies) |
| `python-pasimple` | `any` | [`packages/python-pasimple`](packages/python-pasimple) |
| `python-pcmflux` | `x86_64` | [`packages/python-pcmflux`](packages/python-pcmflux) |
| `python-pixelflux` | `x86_64` | [`packages/python-pixelflux`](packages/python-pixelflux) |

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

The validation workflow does not publish packages. The separate
[`build-repository.yaml`](.github/workflows/build-repository.yaml) workflow:

1. builds required AUR dependencies;
2. builds locally maintained packages in dependency order;
3. creates a pacman repository with `repo-add`;
4. uploads an Actions artifact;
5. updates the rolling `repository-x86_64` GitHub Release.

Use the released repository with:

```ini
[moozliisp-arch]
SigLevel = Optional TrustAll
Server = https://github.com/MoozIiSP/arch-aur-repo/releases/download/repository-x86_64
```

## Legacy AUR build lists

`packages-x86_64.txt` and `packages-aarch64.txt` are retained as input lists
for the repository's earlier AUR build automation. They are not consumed by
the current validation workflow. The related `patches/linux-cachyos/` files
are retained for the listed custom kernel package.

## Selkies standalone environment

`selkies` is packaged as a reusable standalone remote-desktop runtime for other Arch-based systems; it is not tied to Hermes, Lazycat, or `lzc-ai-browser`. The package supplies Xvfb, PulseAudio integration, GStreamer media support, Mesa/DRM/OpenGL/Vulkan runtime libraries, the Selkies systemd units, an Nginx WebSocket reverse-proxy config, and `/etc/selkies.env.example`.

Provisioning on a target system:

```bash
pacman -S selkies
install -Dm600 /etc/selkies.env.example /etc/selkies.env
# Edit /etc/selkies.env; put TURN credentials there when needed.
systemctl enable --now selkies-xvfb.service selkies-pulseaudio.service selkies.service
```

The target system must expose the GPU render node to the service account through the standard `render`/`video` groups. The package does not change `/dev/dri` permissions, require `kmem`, embed TURN credentials, or assume a LightOS-specific network address.

## Selkies and LightOS

The `selkies` package mirrors the LightOS remote-desktop runtime boundary: Mesa/DRM/OpenGL/Vulkan runtime libraries, Xvfb, PulseAudio, GStreamer, Nginx, GPU supplementary groups, and an `/etc/selkies.env.example` template. LightOS official remote-desktop installation remains the preferred production provisioning path; this package is the standalone Arch packaging path. TURN credentials are runtime-generated and are never stored in the repository.
