#############################################################
# powershell profile
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
#############################################################
#
# virtualenvwrapper install
# git clone https://github.com/regisf/virtualenvwrapper-powershell
## TODO: look into uv
# ./Install.ps1

$PowerShellProfile = $PROFILE.CurrentUserAllHosts
$PowerShellPath = Split-Path $PowerShellProfile
Import-Module $PowerShellPath\Modules\VirtualEnvWrapper.psm1

# post-git install
# Install-Module -Name posh-git -Scope CurrentUser -AllowClobber -Force
Import-Module posh-git
## TODO look into starship
# To retain the customary powershell prompt
$GitPromptSettings.DefaultPromptPrefix.Text = "`nPS "

# z (quick directory jump) install
# Install-Module -Name z -Scope CurrentUser -AllowClobber -Force
Import-Module z

# psreadline upgrade/install
# Install-Module -Name PSReadLine -Scope CurrentUser -AllowClobber -Force
Set-PSReadLineOption -BellStyle Visual
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -HistorySavePath $Env:HOME\_PSReadLineHistory
Set-PSReadLineOption -PredictionViewStyle ListView
##Set-PSReadLineOption -PredictionSource HistoryAndPlugin ##needs PS 7.2+

## light color theme
Set-PSReadLineOption -Colors @{
  Command                = "Gray"
  Number                 = "DarkGray"
  Member                 = "DarkGray"
  Emphasis               = "$([char]0x1b)[1;94m"
  Error                  = "$([char]0x1b)[1;91m"
  Operator               = "DarkGray"
  Keyword                = "DarkGreen"
  Type                   = "DarkGray"
  Variable               = "DarkGreen"
  Parameter              = "DarkGreen"
  ContinuationPrompt     = "DarkGray"
  String                 = "DarkBlue"
  ListPredictionSelected = "$([char]0x1b)[48;5;47m"
  InlinePrediction       = "Green"
  ListPredictionTooltip  = "Green"
  Default                = "DarkGray"
}

# swap these key chords
# Set-PSReadLineKeyHandler -Chord 'Ctrl+w' -Function BackwardKillWord
# Set-PSReadLineKeyHandler -Chord 'Alt-Backspace' -Function UnixWordRubout

#############################################################

function f              { fd.exe -c never $args }
function g              { rg.exe -N -i $args }
function Get-HardLinks  { fsutil.exe hardlink list $args }
Set-Alias vim           nvim.exe
function startopensuse  { & $Env:ProgramFiles\Oracle\VirtualBox\VBoxManage.exe startvm openSUSE --type headless }
Set-Alias startlinux    startopensuse

function gitpull        { git.exe pull $args }
function gitpush        { git.exe push $args }
Set-Alias gl            gitpull -Force -Option Constant,AllScope
Set-Alias gp            gitpush -Force -Option Constant,AllScope
function ga             { git.exe add $args }
function gaa            { git.exe add --all $args }
function gc!            { git.exe commit -v --amend $args }
function gcam           { git.exe commit -a -m $args }
function gcmsg          { git.exe commit -m $args }
function gcp            { git.exe commit --patch $args }
function gd             { git.exe diff $args }
function glog           { git.exe log --oneline --decorate --color --graph $args }
function gpr            { git.exe pull --rebase $args }
function gst            { git.exe status $args }
function d              { diff.exe -u $args }

## misc aliases and functions - native powershell
Set-Alias m             more
## TODO: look at moar+bat
Set-Alias ll            Get-ChildItem
function Get-Pass       { -join(48..57+65..90+97..122|ForEach-Object{[char]$_}|Get-Random -C 20) }
function Get-PubIP      { (Invoke-WebRequest http://ifconfig.me/ip ).Content }
function Get-UTC        { Get-Date -Format U }
function dns            { Resolve-DnsName -DnsOnly "$args" }
function l              { Get-ChildItem -Name }
function rmrf           { Remove-Item -Recurse -Force $args }

# https://github.com/ThePoShWolf/Utilities/blob/master/Misc/Set-PathVariable.ps1
function Set-PathVariable {
    param (
        [string]$AddPath,
        [string]$RemovePath,
        [string]$Scope = 'User'
    )
    $regexPaths = @()
    if ($PSBoundParameters.Keys -contains 'AddPath') {
        $regexPaths += [regex]::Escape($AddPath)
    }

    if ($PSBoundParameters.Keys -contains 'RemovePath') {
        $regexPaths += [regex]::Escape($RemovePath)
    }

    $arrPath = [System.Environment]::GetEnvironmentVariable('PATH', $Scope) -split ';'
    foreach ($path in $regexPaths) {
        $arrPath = $arrPath | Where-Object { $_ -notMatch "^$path\\?" }
    }
    $value = ($arrPath + $addPath) -join ';'
    [System.Environment]::SetEnvironmentVariable('PATH', $value, $Scope)
}

function which($name) {
  Get-Command $name | Select-Object -ExpandProperty Definition
}

function mklink($original, $new) {
  New-Item -ItemType HardLink -Path $new -Target $original
}
Set-Alias ln mklink

function mkjunction($original, $new) {
  New-Item -ItemType Junction -Path $new -Target $original
}

function md5sum($fileName) {
  $hashResult = Get-FileHash -Path $fileName -Algorithm MD5
  Write-Host "$($hashResult.Hash.ToLower())  $fileName"
}

function sha1sum($filename) {
  $hashResult = Get-FileHash -Path $fileName -Algorithm SHA1
  Write-Host "$($hashResult.Hash.ToLower())  $fileName"
}

function sha256sum($filename) {
  $hashResult = Get-FileHash -Path $fileName -Algorithm SHA256
  Write-Host "$($hashResult.Hash.ToLower())  $fileName"
}

function sha384sum($filename) {
  $hashResult = Get-FileHash -Path $fileName -Algorithm SHA384
  Write-Host "$($hashResult.Hash.ToLower())  $fileName"
}

function sha512sum($filename) {
  $hashResult = Get-FileHash -Path $fileName -Algorithm SHA512
  Write-Host "$($hashResult.Hash.ToLower())  $fileName"
}

function myhistory([int]$Count=100) {
  Get-Content -LiteralPath (Get-PSReadLineOption).HistorySavePath | Select-Object -Last $Count -Unique
}
Set-Alias history myhistory -Force -Option Constant,AllScope

function tail {
  param (
      [Parameter(ValueFromPipeline=$true)]
      [string]$FilePath,
      [int]$Lines = 10
      )
  process {
    $content = Get-Content $FilePath
    $totalLines = $content.Count
    if ($totalLines -lt $Lines) {
      $content
    } else {
      $content | Select-Object -Last $Lines
    }
  }
}

function head {
  param (
      [Parameter(ValueFromPipeline=$true)]
      [string]$FilePath,
      [int]$Lines = 10
      )
  process {
    $content = Get-Content $FilePath
    $totalLines = $content.Count
    if ($totalLines -lt $Lines) {
      $content
    } else {
      $content | Select-Object -First $Lines
    }
  }
}

function time {
  $Command = $MyInvocation.Line -Replace ("^$($MyInvocation.MyCommand) ", "")
  Measure-Command { Invoke-Expression $Command | Out-Default }
}

##{ not needed with pwsh 7.x
# https://superuser.com/questions/593987/change-directory-to-previous-directory-in-powershell
function custom_cd {
  if ($args.Count -eq 0) {
    $tmp_path = ${HOME}
  }
  elseif ($args[0] -eq '-') {
    $tmp_path = $OLDPWD;
  }
  else {
    $tmp_path = $args[0];
  }
  if ($tmp_path) {
    Set-Variable -Name OLDPWD -Value $PWD -Scope global;
    Set-Location $tmp_path;
  }
}
Set-Alias cd  custom_cd -Option AllScope

function cdh  { cd $Env:HOME }
Set-Alias c   cdh
##} not needed with pwsh 7.x

function w {
  [CmdletBinding()]
  param (
      [Parameter(Mandatory=$true, Position=0)]
      [int]$inputValue
      )
  $SECOND = [math]::floor($inputValue / 256)
  $THIRD = $inputValue % 256
  return "10.$SECOND.$THIRD.0"
}

function 2w {
  param (
      [string]$IPAddress
      )
  $Parts = $IPAddress.Split(".")
  if ($Parts.Count -eq 4) {
    $INT = [int]$Parts[1] * 256 + [int]$Parts[2]
    return $INT
  } else {
    Write-Host "Invalid IP address format."
    return $null
  }
}

function d2b {
  param (
      [int]$Value
      )
  $BinaryString = [Convert]::ToString($Value, 2)
  Write-Host $BinaryString
}

function d2h {
  param (
      [int]$Value
      )
  $HexString = "{0:x}" -f $Value
  Write-Host $HexString
}

function d2o {
  param (
      [int]$Value
      )
  $OctalString = [Convert]::ToString($Value, 8)
  Write-Host $OctalString
}

function h2b {
  param (
      [string]$HexValue
      )
  $DecimalValue = [Convert]::ToInt32($HexValue, 16)
  $BinaryString = [Convert]::ToString($DecimalValue, 2)
  Write-Host $BinaryString
}

function h2d {
  param (
      [string]$HexValue
      )
  $DecimalValue = [Convert]::ToInt32($HexValue, 16)
  Write-Host $DecimalValue
}

function h2o {
  param (
      [string]$HexValue
      )
  $DecimalValue = [Convert]::ToInt32($HexValue, 16)
  $OctalString = [Convert]::ToString($DecimalValue, 8)
  Write-Host $OctalString
}

function o2b {
  param (
      [string]$OctalValue
      )
  $DecimalValue = [Convert]::ToInt32($OctalValue, 8)
  $BinaryString = [Convert]::ToString($DecimalValue, 2)
  Write-Host $BinaryString
}

function o2d {
  param (
      [string]$OctalValue
      )
  $DecimalValue = [Convert]::ToInt32($OctalValue, 8)
  Write-Host $DecimalValue
}

function o2h {
  param (
      [string]$OctalValue
      )
  $DecimalValue = [Convert]::ToInt32($OctalValue, 8)
  $HexadecimalString = "{0:x}" -f $DecimalValue
  Write-Host $HexadecimalString
}

# ascii to ...
function a2b {
  param (
      [string]$asciiChar
      )
  if ([string]::IsNullOrEmpty($asciiChar) -or $asciiChar.Length -ne 1) {
    Write-Host "Input is empty, null, or not a single character."
    return
  }
  $asciiValue = [int][char]$asciiChar
  $binaryString = [Convert]::ToString($asciiValue, 2).PadLeft(8, '0')
  return $binaryString
}

function a2d {
  param (
      [string]$asciiChar
      )
  if ([string]::IsNullOrEmpty($asciiChar) -or $asciiChar.Length -ne 1) {
    Write-Host "Input is empty, null, or not a single character."
    return
  }
  $asciiValue = [int][char]$asciiChar
  return $asciiValue
}
function a2h {
  param (
      [string]$asciiChar
      )
  if ([string]::IsNullOrEmpty($asciiChar) -or $asciiChar.Length -ne 1) {
    Write-Host "Input is empty, null, or not a single character."
    return
  }
  $asciiValue = [int][char]$asciiChar
  $hexString = [Convert]::ToString($asciiValue, 16).ToUpper()
  return $hexString
}
function a2o {
  param (
      [string]$asciiChar
      )
  if ([string]::IsNullOrEmpty($asciiChar) -or $asciiChar.Length -ne 1) {
    Write-Host "Input is empty, null, or not a single character."
    return
  }
  $asciiValue = [int][char]$asciiChar
  $octalString = [Convert]::ToString($asciiValue, 8)
  return $octalString
}

# ... to ascii
function b2a {
  param (
      [string]$binaryValue
      )
  if ([string]::IsNullOrEmpty($binaryValue)) {
    Write-Host "Input is empty or null."
    return
  }
  $asciiChar = [char][Convert]::ToInt32($binaryValue, 2)
  return $asciiChar
}

function d2a {
  param (
      [int]$decimalValue
      )
  $asciiChar = [char]$decimalValue
  return $asciiChar
}

function h2a {
  param (
      [string]$hexValue
      )
  if ([string]::IsNullOrEmpty($hexValue)) {
    Write-Host "Input is empty or null."
    return
  }
  $decimalValue = [Convert]::ToInt32($hexValue, 16)
  $asciiChar = [char]$decimalValue
  return $asciiChar
}

function o2a {
  param (
      [string]$octalValue
      )
  if ([string]::IsNullOrEmpty($octalValue)) {
    Write-Host "Input is empty or null."
    return
  }
  $decimalValue = [Convert]::ToInt32($octalValue, 8)
  $asciiChar = [char]$decimalValue
  return $asciiChar
}

# one's complement TODO: test this more
function b21 {
  param(
      [string]$binaryNumber
      )
  if ($binaryNumber -match '^[01]+$') {
    $onesComplement = $binaryNumber -replace '0', '2' -replace '1', '0' -replace '2', '1'
    return $onesComplement
  } else {
    Write-Host "Invalid binary number. Please enter a valid binary number (0s and 1s only)."
  }
}

# two's complement TODO: fix this
function b22 {
  param($binary)
  if ($binary -match '^[01]+$') {
    $decimal = [Convert]::ToInt32($binary, 2)
    $twosComplement = -bnot $decimal - 1
    return "{0:0000000000000000}" -f [Convert]::ToUInt32($twosComplement, 10)
  }
  else {
    return "Invalid binary input"
  }
}

# dotted quad to ... TODO: fix this
function q2n {
  param($dottedDecimal)
  if ($dottedDecimal -match '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$') {
    $octets = $dottedDecimal.Split('.')
    foreach ($octet in $octets) {
      if ($octet -lt 0 -or $octet -gt 255) {
        return "Invalid dotted decimal input"
      }
    }
    $decimals = @()
    foreach ($octet in $octets) {
      $decimals += [Convert]::ToInt32($octet, 10)
    }
    $networkByteOrder = ($decimals[0] -shl 24) -bor ($decimals[1] -shl 16) -bor ($decimals[2] -shl 8) -bor $decimals[3]
    return $networkByteOrder
  }
  else {
    return "Invalid dotted decimal input"
  }
}

## TODO
function q2h {
}

## TODO
function q2b {
}

# dotted quad to multicast mac TODO: fix this
function q2m {
  param($dottedDecimal)
  if ($dottedDecimal -match '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$') {
    $octets = $dottedDecimal.Split('.')
    foreach ($octet in $octets) {
      if ($octet -lt 0 -or $octet -gt 255) {
        return "Invalid dotted decimal input"
      }
    }
    if ($octets[0] -ge 224 -and $octets[0] -le 239) {
      $binary = [Convert]::ToString($octets[1], 2).PadLeft(8, '0') + [Convert]::ToString($octets[2], 2).PadLeft(8, '0') + [Convert]::ToString($octets[3], 2).PadLeft(8, '0')
      $prefix = "01-00-5E"
      $binaryWithPrefix = $prefix + "-" + $binary
      $hex = @()
      for ($i = 0; $i -lt $binaryWithPrefix.Length; $i += 4) {
        $hex += [Convert]::ToString([Convert]::ToInt32($binaryWithPrefix.Substring($i, 4), 2), 16).ToUpper()
      }
      $multicastMAC = $hex -join ':'
      return $multicastMAC
    }
    else {
      return "Invalid multicast IP address"
    }
  }
  else {
    return "Invalid dotted decimal input"
  }
}

# TODO... to dotted quad
function n2q {
}

# TODO
function h2q {
}

# TODO... to ascii string
function h2s {
}

# TODO ascii string to ...
function s2h {
}
# vim:sw=2:ts=2:sts=2:tw=0:et
