# Scoop Bucket for Bloom

This is a [Scoop](https://scoop.sh) bucket for installing [Bloom](https://github.com/crowquillx/Bloom), a Jellyfin HTPC client.

Two channels are available:

| Channel | Manifest | Tracks |
|---------|----------|--------|
| **Stable** | `bloom` | Tagged releases (e.g. `v0.3.0`) |
| **Dev** | `bloom-dev` | Rolling `dev-latest` builds |

## Installation

### 1. Add the bucket

```powershell
scoop bucket add bloom https://github.com/crowquillx/scoop-bloom
```

### 2. Install

**Stable** (recommended):
```powershell
scoop install bloom
```

**Development builds**:
```powershell
scoop install bloom-dev
```

### Direct URL Installation

You can also install without adding the bucket:

```powershell
# Stable
scoop install https://github.com/crowquillx/scoop-bloom/raw/refs/heads/main/bloom.json

# Dev
scoop install https://github.com/crowquillx/scoop-bloom/raw/refs/heads/main/bloom-dev.json
```

## Features

- **Dual channels**: Stable tagged releases and rolling development builds
- **Auto-updates**: Manifests are automatically updated via GitHub Actions when new releases are published
- **SHA256 verification**: All manifests include hash verification for security

## Repository Structure

- [`bloom.json`](bloom.json) — Scoop manifest for stable releases
- [`bloom-dev.json`](bloom-dev.json) — Scoop manifest for development builds
- [`update-manifest.ps1`](update-manifest.ps1) — PowerShell script to update manifests manually
- [`.github/workflows/update-manifest.yml`](.github/workflows/update-manifest.yml) — Automated workflow to sync manifests

## Updating Manifests

### Automatic (via GitHub Actions)

When a new release is published in the main Bloom repository, the corresponding manifest is automatically updated:
- Tagged releases → `bloom.json` (via `update-stable-manifest` dispatch)
- Dev builds → `bloom-dev.json` (via `update-manifest` dispatch)

### Manual

```powershell
# Update dev manifest to latest dev release
./update-manifest.ps1

# Update stable manifest
./update-manifest.ps1 -OutputPath "bloom.json" -Tag "v0.3.0"

# Update with specific version info
./update-manifest.ps1 -Version "0.3.0" -Url "https://..." -Hash "abc123..."
```

## Troubleshooting

### Hash Mismatch

If you see a hash mismatch error, the manifest may be out of date. Either:
- Wait for the auto-update to run
- Run `scoop update bloom` or `scoop update bloom-dev` to fetch the latest manifest
- Or use the `--skip-check` flag: `scoop install bloom --skip-check`

### Issues Installing

1. Ensure Scoop is installed: `Get-Command scoop`
2. Try updating Scoop first: `scoop update`
3. Check the manifest is valid: `scoop checkver bloom` or `scoop checkver bloom-dev`

## License

MIT.
