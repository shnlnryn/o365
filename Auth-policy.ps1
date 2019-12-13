#Set authentication policy for all users in a domain.

$cred = Get-Credential

Connect-EXOPSSession -Credential $cred


$Users= get-user -ResultSize unlimited | where {$_.userprincipalname -like "*@mydomain.com" -and $_.authenticationpolicy -eq $null}|Select-Object userprincipalname, authenticationpolicy

foreach ($User in $Users){

$user.userprincipalname

set-user -identity $User.userprincipalname -authenticationpolicy "Disable-All-Basic-Auth"


}
