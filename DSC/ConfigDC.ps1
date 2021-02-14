configuration ConfigurationDC
{
   param
   (
        [Parameter(Mandatory)]
        [String]$DomainName,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]$Admincreds
    )

    Import-DscResource -ModuleName xActiveDirectory
    Import-DscResource -ModuleName xStorage
    Import-DscResource -ModuleName xNetworking
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xPendingReboot
    Import-DscResource -ModuleName MSPRO_GPO

    [System.Management.Automation.PSCredential]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${DomainName}\$($Admincreds.UserName)", $Admincreds.Password)
    $interface      = Get-NetAdapter | Where-Object {$_.Name -Like "Ethernet*"} | Select-Object -First 1
    $interfaceAlias = $($interface.Name)

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        WindowsFeature DNS
        {
            Ensure = "Present"
            Name   = "DNS"
        }

        <#Script EnableDNSDiags
        {
      	    SetScript = {
                Set-DnsServerDiagnostics -All $true
                Write-Verbose -Verbose "Enabling DNS client diagnostics"
            }
            GetScript  =  { @{} }
            TestScript = { $false }
            DependsOn  = "[WindowsFeature]DNS"
        }#>

        WindowsFeature DnsTools
        {
            Ensure    = "Present"
            Name      = "RSAT-DNS-Server"
            DependsOn = "[WindowsFeature]DNS"
        }

        xDnsServerAddress DnsServerAddress
        {
            Address        = '127.0.0.1'
            InterfaceAlias = $interfaceAlias
            AddressFamily  = 'IPv4'
            DependsOn      = "[WindowsFeature]DNS"
        }

        WindowsFeature ADDSInstall
        {
            Ensure    = "Present"
            Name      = "AD-Domain-Services"
            DependsOn ="[WindowsFeature]DNS"
        }

        WindowsFeature ADDSTools
        {
            Ensure    = "Present"
            Name      = "RSAT-ADDS-Tools"
            DependsOn = "[WindowsFeature]ADDSInstall"
        }

        <#
        WindowsFeature ADAdminCenter
        {
            Ensure    = "Present"
            Name      = "RSAT-AD-AdminCenter"
            DependsOn = "[WindowsFeature]ADDSTools"
        }
        #>
        
        xADDomain FirstDS
        {
            DomainName                    = $DomainName
            DomainAdministratorCredential = $DomainCreds
            SafemodeAdministratorPassword = $DomainCreds
            DependsOn                     = @("[WindowsFeature]ADDSInstall")
            #DatabasePath = "C:\NTDS"
            #LogPath      = "C:\NTDS"
            #SysvolPath   = "C:\SYSVOL"
        }

        xPendingReboot RebootAfterPromotion
        {
            Name      = "RebootAfterPromotion"
            DependsOn = "[xADDomain]FirstDS"
        }

        ImportGPO ConfigurePSExecutionPolicy
        {
            Ensure      = 'Present'
            DomainCreds = $DomainCreds
            Name        = 'PSExecPol'
            GUID        = '2FC4BFD9-09E6-441F-A64C-F9E76D4065FE'
            
            DependsOn   = '[xPendingReboot]RebootAfterPromotion'
        }
        

   }
}