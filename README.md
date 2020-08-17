# SnapshotMaintenance
PowerCLI script to clean up snapshots based on age/name.

Snapshots with regular naming are deleted based on variable $retentionDate
Snapshots with special naming are deleted based on the name.
e.g.: A snaphot named PROTECTED-15 would be retained for 15 days before deletion.

Contacts are notified 1 day prior to deletion based on Contact tags assigned to the vm.
Contact tags are of this type:

Name                           Category                       Description                                               
----                           --------                       -----------                                               
BAkins929                      Contact                        My.Email@myCompany.com

Tested with the following:
PS C:\> Get-Module

ModuleType Version    Name                                ExportedCommands                                                          
---------- -------    ----                                ----------------                                                          
Script     0.0        chocolateyProfile                   {TabExpansion, Update-SessionEnvironment, refreshenv}                     
Script     1.0.0.0    ISE                                 {Get-IseSnippet, Import-IseSnippet, New-IseSnippet}                       
Manifest   3.1.0.0    Microsoft.PowerShell.Management     {Add-Computer, Add-Content, Checkpoint-Computer, Clear-Content...}        
Manifest   3.1.0.0    Microsoft.PowerShell.Utility        {Add-Member, Add-Type, Clear-Variable, Compare-Object...}                 
Script     7.0.0.1... VMware.DeployAutomation             {Add-DeployRule, Add-ProxyServer, Add-ScriptBundle, Copy-DeployRule...}   
Script     7.0.0.1... VMware.ImageBuilder                 {Add-EsxSoftwareDepot, Add-EsxSoftwarePackage, Compare-EsxImageProfile,...
Script     7.0.0.1... VMware.Vim                                                                                                    
Script     12.0.0.... VMware.VimAutomation.Cis.Core       {Connect-CisServer, Disconnect-CisServer, Get-CisService}                 
Script     12.0.0.... VMware.VimAutomation.Cloud          {Add-CIDatastore, Connect-CIServer, Disconnect-CIServer, Get-Catalog...}  
Script     12.0.0.... VMware.VimAutomation.Common         {Get-Task, New-OAuthSecurityContext, Stop-Task, Wait-Task}                
Script     12.0.0.... VMware.VimAutomation.Core           {Add-PassthroughDevice, Add-VirtualSwitchPhysicalNetworkAdapter, Add-VM...
Script     6.5.4.7... VMware.VimAutomation.HA             Get-DrmInfo                                                               
Script     7.12.0.... VMware.VimAutomation.HorizonView    {Connect-HVServer, Disconnect-HVServer}                                   
Script     12.0.0.... VMware.VimAutomation.License        Get-LicenseDataManager                                                    
Script     10.0.0.... VMware.VimAutomation.PCloud         {Connect-PIServer, Disconnect-PIServer, Get-PIComputeInstance, Get-PIDa...
Script     12.0.0.... VMware.VimAutomation.Sdk            {Get-ErrorReport, Get-InstallPath, Get-PSVersion}                         
Script     12.0.0.... VMware.VimAutomation.Storage        {Add-EntityDefaultKeyProvider, Add-KeyManagementServer, Add-VsanFileSer...
Script     12.0.0.... VMware.VimAutomation.Vds            {Add-VDSwitchPhysicalNetworkAdapter, Add-VDSwitchVMHost, Export-VDPortG...
Script     12.0.0.... VMware.VimAutomation.vROps          {Connect-OMServer, Disconnect-OMServer, Get-OMAlert, Get-OMAlertDefinit...
Script     6.5.1.7... VMware.VumAutomation                {Add-EntityBaseline, Copy-Patch, Get-Baseline, Get-Compliance...}         

Things you need to set:
vCenter credentials
$retentionDate
From address
SmtpServer
Verbiage in the email sent.
Default email if none found
