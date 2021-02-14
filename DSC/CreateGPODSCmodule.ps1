$UserName = New-xDscResourceProperty -Name UserName -Type String -Attribute Key
$Password = New-xDscResourceProperty -Name Password -Type PSCredential -Attribute Write
$DomainCredential = New-xDscResourceProperty -Name DomainAdministratorCredential -Type PSCredential -Attribute Write
$Ensure = New-xDscResourceProperty -Name Ensure -Type String -Attribute Write -ValidateSet "Present", "Absent"
#Now create the resource
New-xDscResource -Name Contoso_cADUser -Property $UserName, $Password, $DomainCredential, $Ensure  -Path 'C:\Program Files\WindowsPowerShell\Modules\xActiveDirectory'


$UserName = New-xDscResourceProperty -Name Name -Type String -Attribute Key
$Password = New-xDscResourceProperty -Name GUID -Type String -Attribute Write
$DomainCredential = New-xDscResourceProperty -Name DomainCreds -Type PSCredential -Attribute Write
$Ensure = New-xDscResourceProperty -Name Ensure -Type String -Attribute Write -ValidateSet "Present", "Absent"
#Now create the resource
New-xDscResource -Name ImportGPO -Property $UserName, $Password, $DomainCredential, $Ensure -Path 'D:\OneDrive - MSpro\Documents\WindowsPowerShell\Modules\MSPRO_GPO'
