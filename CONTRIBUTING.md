# Contributing

## Add or update a package

1. Place the package in `packages/<pkgname>/`.
2. Keep upstream archives and binary packages out of Git.
3. Use fixed checksums; avoid `SKIP` unless the source is cryptographically
   verified by another mechanism.
4. Regenerate metadata:

   ```bash
   makepkg --printsrcinfo > .SRCINFO
   ```

5. Verify sources and build the package:

   ```bash
   makepkg --verifysource
   makepkg --syncdeps --cleanbuild
   ```

Commit the PKGBUILD, `.SRCINFO`, and only the small local files referenced by
`source=()`.
