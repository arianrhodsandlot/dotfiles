$EvalCacheDir = Join-Path $env:XDG_CONFIG_HOME 'powershell' 'evalcache'

if (-not (Test-Path $EvalCacheDir)) {
  New-Item -ItemType Directory -Path $EvalCacheDir -Force | Out-Null
}

function Invoke-EvalCache {
  param(
    [string]$Command,
    [string]$Key = $null,
    [switch]$Force
  )

  if (-not $Key) {
    $Key = $Command -replace '[\\/:*?"<>| ]+', '_' -replace '_+', '_' -replace '^_|_$', ''
  }

  $CacheFile = Join-Path $EvalCacheDir "$Key.ps1"

  if ($Force -or -not (Test-Path $CacheFile)) {
    Write-Host "Generating cache for: $Command" -ForegroundColor Cyan
    try {
      $Output = Invoke-Expression $Command | Out-String
      $Output | Set-Content -Path $CacheFile -Encoding UTF8
    } catch {
      Write-Warning "Failed to generate cache for $Command"
      return
    }
  }

  . $CacheFile
}

function Clear-EvalCache {
  Remove-Item "$EvalCacheDir\*" -Force -ErrorAction SilentlyContinue
  Write-Host "EvalCache cleared." -ForegroundColor Green
}
