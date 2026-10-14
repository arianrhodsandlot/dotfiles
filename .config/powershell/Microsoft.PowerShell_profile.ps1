Get-Alias | ForEach-Object {
  Remove-Item -Path "Alias:\$($_.Name)" -Force -ErrorAction SilentlyContinue
}

. (Join-Path $HOME '.config' 'dotfiles' '.config' 'powershell' 'envs.ps1')
. (Join-Path $HOME '.config' 'dotfiles' '.config' 'powershell' 'hooks.ps1')

if (-not [Console]::IsOutputRedirected) {
  if (Get-Command Set-PSReadLineOption -ErrorAction SilentlyContinue) {
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineOption -EditMode Emacs -PredictionSource None
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle InlineView
  }
}

Set-Alias cd -Value Set-Location -Scope Global
Remove-Alias gl -Force -ErrorAction SilentlyContinue
Remove-Alias gcm -Force -ErrorAction SilentlyContinue
Remove-Alias gp -Force -ErrorAction SilentlyContinue
Remove-Alias gm -Force -ErrorAction SilentlyContinue

$aliasesPath = Join-Path $env:DOTFILES_CONFIG_DIR 'shell' 'aliases.json'
$aliases = Get-Content -Raw $aliasesPath | ConvertFrom-Json
foreach ($prop in $aliases.PSObject.Properties) {
  $command = $prop.Value -replace '\$', '`$'
  $sb = [scriptblock]::Create("& $command" + ($command -match '[;&|]' ? '' : ' @args'))
  Set-Item -Path "function:global:$($prop.Name)" -Value $sb
}

git config --get-regexp '^alias\.' 2>$null | ForEach-Object {
  if ($_ -match '^alias\.(\S+)') {
    $gitAlias = $Matches[1]
    $shellAlias = "g$gitAlias"
    Set-Item -Path "function:global:$shellAlias" -Value ([ScriptBlock]::Create("git $gitAlias @args"))
  }
}

$configBinPath = Join-Path $env:DOTFILES_CONFIG_DIR 'bin'
Get-ChildItem $configBinPath -File | Where-Object {
  $_.Extension -eq '' -and (Get-Content $_.FullName -First 1) -match '^#!'
} | ForEach-Object {
  $funcName = $_.BaseName
  $scriptPath = $_.FullName
  Set-Item -Path "function:global:$funcName" -Value {
    bash ($scriptPath -replace '\\', '/') @args
  }.GetNewClosure()
}

Set-Alias -Name which -Value Get-Command

Set-PSReadLineKeyHandler -Key Enter -ScriptBlock {
  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
  $trimmedLine = $line.Trim()
  $cleanPath = $trimmedLine -replace "^['`"]", "" -replace "['`"]$", ""
  if ($cleanPath -and (Test-Path -Path $cleanPath -PathType Container)) {
    [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, "cd `"$cleanPath`"")
  }
  [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
