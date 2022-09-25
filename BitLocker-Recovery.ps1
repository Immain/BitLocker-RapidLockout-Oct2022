#  Needs to wipe creds, set the bitlocker to recovery mode, and reboots
#  rotate the bitlocker recovery password/update AAD prior to forcing recovery mode
#  Print New Recovery Paasword to Console

# Links
# https://rcmtech.wordpress.com/2017/01/11/change-bitlocker-recovery-password-with-powershell/
# https://www.reddit.com/r/sysadmin/comments/p15ugb/remotely_triggering_bitlocker_recovery_screen_to
# https://rcmtech.wordpress.com/2017/01/11/change-bitlocker-recovery-password-with-powershell/
# https://helpdesk.eoas.ubc.ca/kb/articles/use-powershell-to-get-the-bitlocker-recovery-key















# Identify all the Bitlocker volumes.
$BitlockerVolumers = Get-BitLockerVolume

# For each volume, get the RecoveryPassowrd and display it.
$BitlockerVolumers |
    ForEach-Object {
        $MountPoint = $_.MountPoint 
        $RecoveryKey = [string]($_.KeyProtector).RecoveryPassword       
        if ($RecoveryKey.Length -gt 5) {
            Write-Output ("The drive $MountPoint has a recovery key $RecoveryKey.")
        }        
    }
