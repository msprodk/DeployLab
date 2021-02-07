configuration ConfigureADBDC
{
   param
    (
        [Parameter(Mandatory)]
        [String]$DomainName,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Admincreds,

        [Int]$RetryCount=20,
        [Int]$RetryIntervalSec=30
    )

    Import-DscResource -ModuleName xActiveDirectory, xPendingReboot, xDSCDomainJoin

    [System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${DomainName}\$($Admincreds.UserName)", $Admincreds.Password)

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }
        
        xDSCDomainjoin JoinDomain
        {
            Domain     = $DomainName 
            Credential = $DomainCreds
            #JoinOU     = "CN=Computers,DC=someplace,DC=qld,DC=gov,DC=au"
        }
    }
}
