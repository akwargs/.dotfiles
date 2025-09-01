[System.Environment]::SetEnvironmentVariable("HOME", "$Env:USERPROFILE", "User")
[System.Environment]::SetEnvironmentVariable("TMP", "$Env:USERPROFILE\tmp", "User")
[System.Environment]::SetEnvironmentVariable("TEMP", "$Env:USERPROFILE\tmp", "User")
[System.Environment]::SetEnvironmentVariable("NVIM_NODE_HOST", "$Env:APPDATA\npm\node_modules\neovim\bin\cli.js", "User")
[System.Environment]::SetEnvironmentVariable("NVIM_PYTHON3_HOST", "$Env:USERPROFILE\Projects\py3nvim\Scripts\python", "User")
[System.Environment]::SetEnvironmentVariable("MY_NTC_TEMPLATES_DIR", "$Env:USERPROFILE\textfsm_templates", "User")
[System.Environment]::SetEnvironmentVariable("OPENSSL_CONF", "$Env:USERPROFILE\openssl\openssl.cnf", "User")

Set-PathVariable -Scope User -AddPath "$Env:USERPROFILE\bin"
Set-PathVariable -Scope User -AddPath "$Env:ProgramFiles\7-Zip"
Set-PathVariable -Scope User -AddPath "$Env:ProgramFiles\Git\usr\bin"

ln "$Env:ONEDRIVE\Backups\npmrc.txt" $Env:USERPROFILE\.npmrc
ln "$Env:ONEDRIVE\Backups\hosts.txt" $Env:USERPROFILE\hosts
ln "$Env:ONEDRIVE\Backups\protocol-numbers.txt" $Env:USERPROFILE\protocols
ln "$Env:ONEDRIVE\Backups\service-names-port-numbers.txt" $Env:USERPROFILE\services

ln "$Env:ONEDRIVE\ssh\config" $Env:USERPROFILE\.ssh\config
ln "$Env:ONEDRIVE\ssh\id_ed25519" $Env:USERPROFILE\.ssh\id_ed25519
ln "$Env:ONEDRIVE\ssh\id_ed25519.ppk" $Env:USERPROFILE\.ssh\id_ed25519.ppk
ln "$Env:ONEDRIVE\ssh\id_ed25519.pub" $Env:USERPROFILE\.ssh\id_ed25519.pub

mkjunction "$Env:ONEDRIVE" $Env:USERPROFILE\one
mkjunction "$Env:ONEDRIVE\bin" $Env:USERPROFILE\bin
mkjunction "$Env:ONEDRIVE\logs" $Env:USERPROFILE\logs
mkjunction "$Env:ONEDRIVE\openssl" $Env:USERPROFILE\openssl
mkjunction "$Env:ONEDRIVE\Documents" $Env:USERPROFILE\docs
mkjunction "$Env:ONEDRIVE\nvim" $Env:USERPROFILE\AppData\Local\nvim
mkjunction "$Env:ONEDRIVE\vimwiki" $Env:USERPROFILE\vimwiki
mkjunction "$Env:ONEDRIVE\vimfiles" $Env:USERPROFILE\vimfiles
mkjunction "$Env:ONEDRIVE\textfsm_templates" $Env:USERPROFILE\textfsm_templates
