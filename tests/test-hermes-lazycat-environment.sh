#!/usr/bin/env bash
set -euo pipefail
pkg=packages/hermes-lazycat-environment/PKGBUILD
[[ -f "$pkg" ]] || { echo "FAIL: missing $pkg" >&2; exit 1; }
bash -n "$pkg"
source "$pkg"
for dep in bash curl jq tar coreutils gawk ca-certificates lzc-ai-browser selkies; do
  [[ " ${depends[*]} " == *" $dep "* ]] || { echo "FAIL: missing dependency $dep" >&2; exit 1; }
done
if grep -Eq '\.hermes/skills|/usr/share/hermes/.*/skills|SKILL\.md|mcp-providers|lpk-manager' "$pkg"; then
  echo 'FAIL: environment package must not manage skills, MCP, or LPKs' >&2
  exit 1
fi
grep -q '^            hermes-lazycat-environment$' .github/workflows/build-repository.yaml || { echo 'FAIL: environment package absent from repository build' >&2; exit 1; }
grep -Fq '| `hermes-lazycat-environment` |' README.md || { echo 'FAIL: environment package absent from README' >&2; exit 1; }
printf 'PASS: hermes-lazycat-environment boundary\n'

for file in \
  packages/lzc-ai-browser/lzc-ai-browser-chrome \
  packages/selkies/lzc-ai-browser-selkies.service; do
  [[ -f "$file" ]] || { echo "FAIL: missing local browser integration $file" >&2; exit 1; }
done
grep -q '/usr/lib/systemd/user' packages/selkies/PKGBUILD || { echo 'FAIL: Selkies does not install user units' >&2; exit 1; }
grep -q 'lzc-ai-browser-chrome' packages/lzc-ai-browser/PKGBUILD || { echo 'FAIL: browser launcher is not packaged' >&2; exit 1; }
grep -q 'renderD128' packages/lzc-ai-browser/lzc-ai-browser-chrome || { echo 'FAIL: launcher does not inspect DRM render node' >&2; exit 1; }
grep -q 'SupplementaryGroups=kmem render video' packages/selkies/lzc-ai-browser-selkies.service || { echo 'FAIL: browser service lacks DRM supplementary groups' >&2; exit 1; }
grep -q 'LZC_AI_BROWSER_DISABLE_GPU' packages/lzc-ai-browser/lzc-ai-browser-chrome || { echo 'FAIL: GPU override is missing' >&2; exit 1; }
