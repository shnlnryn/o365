# Get date when O365 license was assigned to a user.

#ServicePlanId and SKUs  https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/licensing-service-plan-reference




$Cred = Get-Credential

Connect-msolService -Credential $Cred
Connect-AzureAD -Credential $Cred


ProplusUsers = Get-MsolUser -MaxResults 100000 | Where-Object {($_.licenses).AccountSkuId -match "O365TENANT:OFFICESUBSCRIPTION"}


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



$object = [pscustomobject]@{
        User = $User.UserPrincipalName
        Country = $UsageLocation.Country
        City = $UsageLocation.City
        UsageLocation = $UsageLocation.UsageLocation
        Department = $UsageLocation.Department
        State = $UsageLocation.State
        OfficeLocation = $UsageLocation.PhysicalDeliveryOffice
        Service = $Details.Service
        AssignedDate = $Details.AssignedTimestamp
        }

$object | Export-CSV D:\temp\Pro_report.csv -NoTypeInformation -Append

}
