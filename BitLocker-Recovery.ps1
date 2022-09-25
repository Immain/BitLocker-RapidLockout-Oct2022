<# ERASE BEFORE SHIPPING:
 Needs to wipe creds, set the bitlocker to recovery mode, and reboots
 rotate the bitlocker recovery password/update AAD prior to forcing recovery mode
 Print New Recovery Paasword to Console

 Links
 https://rcmtech.wordpress.com/2017/01/11/change-bitlocker-recovery-password-with-powershell/
 https://www.reddit.com/r/sysadmin/comments/p15ugb/remotely_triggering_bitlocker_recovery_screen_to
 https://rcmtech.wordpress.com/2017/01/11/change-bitlocker-recovery-password-with-powershell/
 https://helpdesk.eoas.ubc.ca/kb/articles/use-powershell-to-get-the-bitlocker-recovery-key
 https://learn.microsoft.com/en-us/windows/security/information-protection/bitlocker/bitlocker-recovery-guide-plan
 https://techexpert.tips/powershell/powershell-remove-bitlocker-encryption/
#>
$Logfile = "C:\Temp\proc_$env:computername.log"
function WriteLog
{
Param ([string]$LogString)
$Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
$LogMessage = "$Stamp $LogString"
Add-content $LogFile -value $LogMessage
}

# Identify Current Bitlocker volumes.
$BitlockerVolumers = Get-BitLockerVolume

# For each volume, get the RecoveryPassowrd and display it.
$BitlockerVolumers |
    ForEach-Object {
        $MountPoint = $_.MountPoint 
        $RecoveryKey = [string]($_.KeyProtector).RecoveryPassword       
        if ($RecoveryKey.Length -gt 5) {
            Write-Output ("The drive $MountPoint current recovery key is: $RecoveryKey.")
            WriteLog ("The drive $MountPoint current recovery key is: $RecoveryKey.")
        }        
    }

# Rotate the Bitlocker Recovery Password Prior To Forcing Recovery Mode
$MountPoint = "C:"
# Register the event log source
$LogSource = "RCMTech"
New-EventLog -LogName Application -Source $LogSource -ErrorAction SilentlyContinue
# Get the key protectors
$KeyProtectors = (Get-BitLockerVolume -MountPoint $MountPoint).KeyProtector
foreach($KeyProtector in $KeyProtectors){
    if($KeyProtector.KeyProtectorType -eq "RecoveryPassword"){
        try{
            # Remove then re-add the RecoveryPassword protector
            Remove-BitLockerKeyProtector -MountPoint $MountPoint -KeyProtectorId $KeyProtector.KeyProtectorId | Out-Null
            # Assuming BitLocker is configured properly, the recovery password will be stored in Active Directory, don't display it on screen
            Add-BitLockerKeyProtector -MountPoint $MountPoint -RecoveryPasswordProtector -WarningAction SilentlyContinue | Out-Null
            # If we get this far, eveything has worked, write a success to the event log
            Write-EventLog -LogName Application -Source $LogSource -EntryType Information -EventId 1000 -Message "BitLocker Recovery Password for $MountPoint has been changed"
            Write-Host "Successfully Rotated BitLocker Recovery Password" -ForegroundColor Green
        }
        catch{
            # Something went wrong, display the error details and write an error to the event log
            $Error[0]
            Write-EventLog -LogName Application -Source $LogSource -EntryType Warning -EventId 1001 -Message "Failed to Rotate Bitlocker Recovery Password For $MountPoint"
        }
    }
}

# Identify all the Bitlocker volumes.
$BitlockerVolumers = Get-BitLockerVolume

# For each volume, get the RecoveryPassowrd and display it.
$BitlockerVolumers |
    ForEach-Object {
        $MountPoint = $_.MountPoint 
        $RecoveryKey = [string]($_.KeyProtector).RecoveryPassword       
        if ($RecoveryKey.Length -gt 5) {
            Write-Output ("The drive $MountPoint has a new recovery key of: $RecoveryKey.")
            WriteLog ("The drive $MountPoint has a new recovery key of: $RecoveryKey.")
        }        
    }

# Remove BitLocker Encryption
Get-BitLockerVolume
Disable-BitLocker -MountPoint "C:"
Get-BitLockerVolume
shutdown -r -t 0 -f
