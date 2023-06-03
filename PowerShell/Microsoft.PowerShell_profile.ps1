$PowerShellProfile = $PROFILE.CurrentUserAllHosts
$PowerShellPath = Split-Path $PowerShellProfile
Import-Module $PowerShellPath\Modules\VirtualEnvWrapper.psm1
Import-Module Terminal-Icons
Import-Module PowerColorLS
Import-Module z

Set-Alias l PowerColorLS
Set-Alias ll Get-ChildItem
Set-Alias vboxmanage 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe'

$currentVersion = $PSVersionTable.PSVersion
$requiredVersion = [Version]'7.2'
if ($currentVersion -ge $requiredVersion) {
    $PSStyle.Progress.UseOSCIndicator = 1
    Set-PSReadLineOption -PredictionSource HistoryandPlugin
}

Set-PSReadLineOption -BellStyle Visual
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -HistorySavePath $Env:HOME\PSReadLinePSReadLine.txt

function pll    { PowerColorLS -l -sd }
function plla   { PowerColorLS -l -a -sd }
function lla    { PowerColorLS -l -a -sd }
function m      { bat.exe --pager="less -XRF" $args }
function g      { rg.exe -NPi $args }
#function g($pattern)      { Select-String -Pattern $pattern $args }
function d      { diff.exe -u $args }
function gst    { git.exe status }
function gcam   { git.exe commit -a -m $args }
function gc!    { git.exe commit -v --amend $args }
function gd     { git.exe diff $args }
function mygp   { git.exe push }
function mygl   { git.exe pull }
function gpr    { git.exe pull --rebase $args }
function mywiki { vim.exe +VimwikiIndex }
function start_linux { vboxmanage startvm linux --type headless }

function Get-PubIP {
    (Invoke-WebRequest http://ifconfig.me/ip ).Content
}

function Get-UTC {
     Get-Date -Format u
}

function Get-Pass {
    -join(48..57+65..90+97..122|ForEach-Object{[char]$_}|Get-Random -C 20)
}

function mywhich($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}

function myhistory([int]$Count=100) {
    Get-Content -LiteralPath (Get-PSReadLineOption).HistorySavePath | Select-Object -Last $Count
}

if ($PSVersionTable.PSVersion.Major -ge 7) {
    try { $null = gcm pshazz -ea stop; pshazz init } catch { }
}
