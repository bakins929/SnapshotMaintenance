<#
    .NOTES
	===========================================================================
	Created by:		
	Date:			July 28, 2020
	Version:		1.6
	===========================================================================
	.SYNOPSIS
		This script performs the following actions:
        1) Find all snapshots
        2) Get snapshot age
        3) Check to see if keyword is in name for protected retention
            a) if protected:
                i) if protectedDate is exceeded:
                    1) delete
                ii) if protectedDate is 1 day away:
                    1) gather contacts to send email
                        a) If no contact, set contact to vmware admins
                        b) send email
        4) Check age of non-protected snapshots
            a) if retentionDate is exceeded:
                i) delete
            b) if retentionDate is 1 day away
                i) gather contacts to send email
                    1) If no contact, set contact to vmware admins
                    2) send email
    
        NOTE:  Contacts are gathered through VMware tags of type Contact.  Name field contains contact name, Description field contains email address.
    ---------------------------------------------------------------------------
	.DESCRIPTION
        Automation of snapshot cleanup.

    --------------------------------------------------------------------------- 
	.NOTES
		
    ---------------------------------------------------------------------------
	.TROUBLESHOOTING
		
    ---------------------------------------------------------------------------
	.KNOWN ISSUES
        
#>


<#
<#
-------------------------------------------------------------------
|                       vCenter Authentication                    |
-------------------------------------------------------------------
#>
#vCenter1 authentication:
$creds = Get-VICredentialStoreItem -File “C:\PShell\Credentials\$env:USERNAME\vCenter1_creds.xml”
Connect-VIServer -Server $creds.Host -User $creds.User -Password $creds.Password *> $null
#vCenter2 authenication:
$creds = Get-VICredentialStoreItem -File “C:\PShell\Credentials\$env:USERNAME\vCenter2_creds.xml”
Connect-VIServer -Server $creds.Host -User $creds.User -Password $creds.Password *> $null
#vCenter3 authenication:
$creds = Get-VICredentialStoreItem -File “C:\PShell\Credentials\$env:USERNAME\vCenter3_creds.xml”
Connect-VIServer -Server $creds.Host -User $creds.User -Password $creds.Password *> $null


<#
-------------------------------------------------------------------
|                      Retention Variables                        |
-------------------------------------------------------------------
#>
#How many days to retain snaps? 7 + 1 day grace = 8
$retentionDate = 8
#Warn date should be $retentionDate - 1
$warnDate = ($retentionDate - 1)


<#
-------------------------------------------------------------------
|                     Function Definitions                        |
-------------------------------------------------------------------
#>
#Functions:
function sendEmail {

	$MailParam = @{
		To = "$address"
		From = "Snapshot Management <no-reply@myCompany.com>"
		SmtpServer = "smtp.myCompany.com"
		Subject = "VMware Snapshot Alert for $($vm.Name) - " + (Get-Date -Format M/d/yyyy)
		body = $mailMap.$mailType
	}
	Send-MailMessage @MailParam -BodyAsHtml
}

function notifyContacts {
	$contact = (Get-TagAssignment -Entity $vm -Category Contact | Select-Object -ExpandProperty Tag).Description

	foreach ($address in $Contact) {
		#If no contact, vmware admins until contact is updated.
		if ($address -notlike "*@myCompany.com") {
			$contact = "vmware.admins@myCompany.com"
		}

		sendEmail
	}
}

$mailMap = @{
	"warn" = ([string]"The protected snapshot $($snap.Name), found on $($vm.Name) is $snapAge days old and will be deleted tomorrow.<br><br>If you have a <b><i>business need</i></b> to extend the snapshot retention, please open a work order ASAP and assign it to Infrastructure Converged.<br>Do not reply to this email.<br><br><br><i>NOTE:</i> Protected snapshot retention requires management approval.")
	"delete" = ([string]"This is a courtesy reminder.<br><br>Snapshot $($snap.Name), found on $($vm.Name) will be deleted tomorrow.")
}


<#
-------------------------------------------------------------------
|                        Start Processing                         |
-------------------------------------------------------------------
#>
#Enumerate VMs and search for snapshots.
foreach ($vm in Get-VM) {

	$snaps = Get-Snapshot -VM $vm | Select-Object VM,Name,Created

	foreach ($snap in $snaps) {

		#Get age of snapshot in days
		$snapAge = (((Get-Date) - $snap.Created).Days)

		#If snap has PROTECTED in name, start examining age.
		if ($snap.Name -like "PROTECTED-*") {
			#Set dates based on name of snapshot
			$protectedDate = ($snap.Name.Split("-"))
			$protectedWarn = ($protectedDate[1] - 1)

			#If snapshot over protectedDate, delete
			if ($snapAge -gt $($protectedDate[1])) {
				Get-VM $snap.VM | Get-Snapshot -Name $snap.Name | Remove-Snapshot -Confirm:$false

			} elseif ($snapAge -gt $protectedWarn) {
				$mailType = "warn"
				notifyContacts
			}

		} elseif ($snapAge -gt $retentionDate) {
			Get-VM $snap.VM | Get-Snapshot -Name $snap.Name | Remove-Snapshot -Confirm:$false

		} elseif ($snapAge -gt $warnDate) {
			$mailType = "delete"
			notifyContacts
		}

	}

}


<#
-------------------------------------------------------------------
|                    Close vCenter connections                    |
-------------------------------------------------------------------
#>
Disconnect-VIServer -Server * -Confirm:$false -Force -ErrorAction SilentlyContinue
