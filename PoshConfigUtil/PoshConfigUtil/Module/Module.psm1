$command = Get-Command Unblock-File -EA SilentlyContinue
if($command){
    Get-ChildItem -Path $PSScriptRoot | Unblock-File
}else{
    Get-ChildItem -Path $PSScriptRoot
}

Get-ChildItem -Path $PSScriptRoot\*.ps1 | Foreach-Object{ . $_.FullName }

Export-ModuleMember -Function * -Alias *