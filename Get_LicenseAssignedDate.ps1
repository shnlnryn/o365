$Cred = Get-Credential

Connect-msolService -Credential $Cred
Connect-AzureAD -Credential $Cred


ProplusUsers = Get-MsolUser -MaxResults 10000 | Where-Object {($_.licenses).AccountSkuId -match "O365TENANT:OFFICESUBSCRIPTION"}


Foreach ($User in $ProplusUsers) {

$UsageLocation = Get-AzureADUser -ObjectId $User.userprincipalname | Select-Object Country, Department, PhysicalDeliveryOffice, State, UsageLocation



$country = $UsageLocation.Country
$UsageLocation = $UsageLocation.UsageLocation
$Department = $UsageLocation.Department
$State = $UsageLocation.State
$Office= $UsageLocation.PhysicalDeliveryOffice


$Details=(Get-AzureADUser -ObjectId $user.userprincipalname).AssignedPlans|where {$_.ServicePlanId -eq "43de0ff5-c92c-492b-9116-175376d08c38"}|Select-Object Service, AssignedTimestamp

$Service = $Details.Service
$AssignedDate = $Details.AssignedTimestamp



$object = New-Object –TypeName PSObject

$object | Add-Member –MemberType NoteProperty –Name User –Value $User.UserPrincipalName
$object | Add-Member –MemberType NoteProperty –Name Country –Value $User.Country
$object | Add-Member –MemberType NoteProperty –Name UsageLocation –Value $User.UsageLocation
$object | Add-Member –MemberType NoteProperty –Name Department –Value $User.Department
$object | Add-Member –MemberType NoteProperty –Name State –Value $UsageLocation.State
$object | Add-Member –MemberType NoteProperty –Name OfficeLocation –Value $UsageLocation.PhysicalDeliveryOffice
$object | Add-Member –MemberType NoteProperty –Name Service –Value $Service
$object | Add-Member –MemberType NoteProperty –Name AssignedDate –Value $AssignedDate

$object

$object | Export-CSV D:\temp\Pro_report.csv -NoTypeInformation -Append

}
