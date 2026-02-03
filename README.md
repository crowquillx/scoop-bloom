# Scoop Bucket for Bloom

This is a [Scoop](https://scoop.sh) bucket for installing Bloom development builds.

## Installation

### Using a Separate Bucket Repository

1. Clone this repository to a location of your choice (or create a new GitHub repo with these files)
2. Add the bucket to Scoop:
   ```powershell
   scoop bucket add bloom-dev https://github.com/crowquillx/scoop-bloom/raw/refs/heads/main/bloom-dev.json
   ```
3. Install Bloom:
   ```powershell
   scoop install bloom-dev
   ```

### Direct URL Installation

```powershell
scoop install https://github.com/crowquillx/scoop-bloom/raw/refs/heads/main/bloom-dev.json
```

## Features

- **Auto-updates**: The manifest includes `checkver` and `autoupdate` sections for automated updates
- **Development builds**: Points to the `dev-latest` release from the main Reef repository
- **SHA256 verification**: Manifest includes hash verification for security

## Repository Structure

This bucket provides:

- [`bloom-dev.json`](bloom-dev.json) - Scoop manifest for development builds
- [`update-manifest.ps1`](update-manifest.ps1) - PowerShell script to update the manifest
- [`.github/workflows/update-manifest.yml`](.github/workflows/update-manifest.yml) - Automated workflow to sync the manifest

## Updating the Manifest

### Automatic (via GitHub Actions)

When a new release is published in the main Reef repository, the manifest is automatically updated via GitHub Actions.

### Manual

```powershell
# Update to latest dev release
./update-manifest.ps1

# Update to specific version
./update-manifest.ps1 -Version "2025.02.03"
```

## Troubleshooting

### Hash Mismatch

If you see a hash mismatch error, the manifest may be out of date. Either:
- Wait for the auto-update to run (every hour or on new releases)
- Run `scoop update bloom-dev` to fetch the latest manifest
- Or use the `--skip-check` flag: `scoop install bloom-dev --skip-check`

### Issues Installing

1. Ensure Scoop is installed: `Get-Command scoop`
2. Try updating Scoop first: `scoop update`
3. Check the manifest is valid: `scoop checkver bloom-dev`

## License

MIT.
