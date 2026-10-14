$env:XDG_DESKTOP_DIR = Join-Path $HOME 'Desktop'
$env:XDG_DOCUMENTS_DIR = Join-Path $HOME 'Documents'
$env:XDG_DOWNLOAD_DIR = Join-Path $HOME 'Downloads'
$env:XDG_MUSIC_DIR = Join-Path $HOME 'Music'
$env:XDG_PICTURES_DIR = Join-Path $HOME 'Pictures'
$env:XDG_PROJECTS_DIR = Join-Path $HOME 'Projects'
$env:XDG_PUBLICSHARE_DIR = Join-Path $HOME 'Public'
$env:XDG_TEMPLATES_DIR = Join-Path $HOME 'Templates'
$env:XDG_VIDEOS_DIR = Join-Path $HOME 'Videos'
$env:XDG_DATA_HOME = Join-Path $HOME '.local' 'share'

$env:DOTFILES_DIR = Join-Path $env:XDG_CONFIG_HOME 'dotfiles'
$env:DOTFILES_CONFIG_DIR = Join-Path $env:DOTFILES_DIR '.config'

$env:BAT_CONFIG_PATH = Join-Path $env:DOTFILES_CONFIG_DIR 'bat' 'config'
$env:LG_CONFIG_FILE = Join-Path $env:DOTFILES_CONFIG_DIR 'lazygit' 'config.yml'
$env:MISE_AUTO_ENV = 'true'
$env:MISE_CONFIG_DIR = Join-Path $env:DOTFILES_CONFIG_DIR 'mise'
$env:MISE_DATA_DIR = Join-Path $env:XDG_DATA_HOME 'mise'
$env:PI_CODING_AGENT_DIR = Join-Path $env:DOTFILES_CONFIG_DIR 'pi' 'agent'
$env:PI_CODING_AGENT_SESSION_DIR = Join-Path $env:XDG_DATA_HOME 'pi' 'sessions'
$env:STARSHIP_CONFIG = Join-Path $env:DOTFILES_CONFIG_DIR 'starship' 'config.toml'

$envsPath = Join-Path $env:DOTFILES_CONFIG_DIR 'shell' 'envs.json'
$envs = Get-Content -Raw $envsPath | ConvertFrom-Json

foreach ($prop in $envs.PSObject.Properties) {
  if ($prop.Name -notmatch '^[A-Za-z_][A-Za-z0-9_]*$') { continue }
  $value = [regex]::Replace([string]$prop.Value, '\$\{?(\w+)\}?', {
    param($match)
    [Environment]::GetEnvironmentVariable($match.Groups[1].Value)
  })
  if ($value -match '^[A-Za-z]:') { $value = $value -replace '/', '\' }
  Set-Item "env:$($prop.Name)" -Value $value
}
