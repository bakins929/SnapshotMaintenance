# SnapshotMaintenance
PowerCLI script to clean up snapshots based on age/name.


Snapshots with regular naming are deleted based on variable $retentionDate  
Snapshots with special naming are deleted based on the name.  
e.g.: A snaphot named PROTECTED-15 would be retained for 15 days before deletion.  

Contacts are notified 1 day prior to deletion based on Contact tags assigned to the VM.  

Contact tags are of Category Contact where Description contains email address:
Name | Category | Description | 
-----|----------|-------------|
First Last | Contact | My.Email@myCompany.com

# Things you need to set in the script:

    * vCenter credentials
    * $retentionDate
    * From address
    * SmtpServer
    * Verbiage in the email sent.
    * Default email address if none is found

# Tested with the following modules:
ModuleType | Version | Name | ExportedCommands | 
-----------|--------|------|------------------|
Script | 1.0.0.0 | ISE | {Get-IseSnippet, Import-IseSnippet, New-IseSnippet} | 
Manifest | 3.1.0.0 | Microsoft.PowerShell.Management | {Add-Computer, Add-Content, Checkpoint-Computer, Clear-Content...} | 
Manifest | 3.1.0.0 | Microsoft.PowerShell.Utility | {Add-Member, Add-Type, Clear-Variable, Compare-Object...} | 
Script | 7.0.0.15902843 | VMware.DeployAutomation | {Add-DeployRule, Add-ProxyServer, Add-ScriptBundle, Copy-DeployRule...} | 
Script | 7.0.0.15902843 | VMware.ImageBuilder | {Add-EsxSoftwareDepot, Add-EsxSoftwarePackage, Compare-EsxImageProfile, Export-EsxImageProfile...} | 
Script | 7.0.0.15939650 | VMware.Vim | 
Script | 12.0.0.15939657 | VMware.VimAutomation.Cis.Core | {Connect-CisServer, Disconnect-CisServer, Get-CisService} | 
Script | 12.0.0.15940183 | VMware.VimAutomation.Cloud | {Add-CIDatastore, Connect-CIServer, Disconnect-CIServer, Get-Catalog...} | 
Script | 12.0.0.15939652 | VMware.VimAutomation.Common | {Get-Task, New-OAuthSecurityContext, Stop-Task, Wait-Task} | 
Script | 12.0.0.15939655 | VMware.VimAutomation.Core | {Add-PassthroughDevice, Add-VirtualSwitchPhysicalNetworkAdapter, Add-VMHost, Add-VMHostNtpServer...} | 
Script | 7.12.0.15718406 | VMware.VimAutomation.HorizonView | {Connect-HVServer, Disconnect-HVServer} | 
Script | 12.0.0.15939670 | VMware.VimAutomation.License | Get-LicenseDataManager | 
Script | 12.0.0.15939651 | VMware.VimAutomation.Sdk | {Get-ErrorReport, Get-InstallPath, Get-PSVersion} | 
Script | 12.0.0.15939648 | VMware.VimAutomation.Storage | {Add-EntityDefaultKeyProvider, Add-KeyManagementServer, Add-VsanFileServiceOvf, Add-VsanObjectToRepairQueue...}
Script | 12.0.0.15940185 | VMware.VimAutomation.Vds | {Add-VDSwitchPhysicalNetworkAdapter, Add-VDSwitchVMHost, Export-VDPortGroup, Export-VDSwitch...} | 
Script | 12.0.0.15940184 | VMware.VimAutomation.vROps | {Connect-OMServer, Disconnect-OMServer, Get-OMAlert, Get-OMAlertDefinition...} | 
Script | 6.5.1.7862888 | VMware.VumAutomation | {Add-EntityBaseline, Copy-Patch, Get-Baseline, Get-Compliance...} | 

     
That should do it.  
Enjoy!  
* _**Always test in a lab setting before running ANYTHING in production!!**_

