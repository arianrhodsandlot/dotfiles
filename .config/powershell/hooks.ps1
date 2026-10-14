. (Join-Path $HOME '.config' 'dotfiles' '.config' 'powershell' 'functions.ps1')

if (Get-Command mise -ErrorAction SilentlyContinue) {
  $env:MISE_PWSH_CHPWD_WARNING = 0
  # Disable command not found hook to avoid PSReadLine bug
  $Global:__mise_pwsh_command_not_found = $true
  Invoke-EvalCache 'mise activate pwsh'
}

if (Get-Command starship -ErrorAction SilentlyContinue) {
  Invoke-EvalCache 'starship init powershell --print-full-init'
}

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
  Invoke-EvalCache 'zoxide init powershell'
}

if (Get-Command Set-PSReadLineKeyHandler -ErrorAction SilentlyContinue) {
  Set-PSReadLineKeyHandler -Key Enter -ScriptBlock {
    param($key, $arg)
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    # If the buffer has any non-whitespace text, submit normally
    if ($line -notmatch '^\s*$') {
      [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
      return
    }

    # Empty buffer: if inside a git work tree run `git status`, otherwise `ls`.
    $insideGit = $false
    try {
      $result = (& git rev-parse --is-inside-work-tree 2>$null)
      if ($result -and $result.ToString().Trim() -eq 'true') {
        $insideGit = $true
      }
    }
    catch {
      $insideGit = $false
    }

    if ($insideGit) {
      [Microsoft.PowerShell.PSConsoleReadLine]::Insert('git status')
    }
    else {
      [Microsoft.PowerShell.PSConsoleReadLine]::Insert('ls')
    }
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
  } -BriefDescription 'magic-enter'
}
