# Encodes release.keystore into a base64 string.
# Run this script, then paste the output into the GitHub secret ANDROID_SIGNING_KEY:
#   https://github.com/<you>/<repo>/settings/secrets/actions
$keystorePath = Join-Path $PSScriptRoot "release.keystore"
if (-not (Test-Path $keystorePath)) {
    Write-Error "release.keystore not found next to this script."
    exit 1
}
$base64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($keystorePath))
$base64 | Out-File -FilePath (Join-Path $PSScriptRoot "keystore-base64.txt") -Encoding ascii
Write-Output "Done. Base64 written to keystore-base64.txt ($($base64.Length) chars)."