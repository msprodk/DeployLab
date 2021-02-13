configuration ConfigurationImportGPOs
{
   param
   (
   )

    Import-DscResource -ModuleName xActiveDirectory, PSDesiredStateConfiguration
    
    $guid = '2FC4BFD9-09E6-441F-A64C-F9E76D4065FE'
    $name = 'GPExecPol'

    New-Item -ItemType Directory -Path C:\GPOs -ErrorAction SilentlyContinue
    Invoke-WebRequest -Uri https://github.com/msprodk/DeployLab/raw/main/GPOs/%7B2FC4BFD9-09E6-441F-A64C-F9E76D4065FE%7D.zip -OutFile c:\GPOs\PSExecPol.zip
    Start-Sleep -Seconds 5
    Expand-Archive -Path c:\GPOs\PSExecPol.zip -DestinationPath c:\GPOs

    Import-GPO -BackupId $guid -Path C:\GPOs\ -TargetName $name -CreateIfNeeded

}