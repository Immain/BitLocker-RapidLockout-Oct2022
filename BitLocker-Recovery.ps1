# Transcript of PowerShell Execution
$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path C:\GalacticBitLocker-Transcript.txt -append

# Log File For Bit Locker Keys
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
Get-BitLockerVolume # List all BitLocker volumes

Disable-BitLocker -MountPoint "C:"

Write-Host "Wait 5 Min for Drive to Decrypt" -ForegroundColor Green
Start-Sleep -Seconds 300

Write-Host "Check Drive Decryption" -ForegroundColor Green
Get-BitLockerVolume 

Write-Host "Wait 5 Min Longer to Verify Decryption" -ForegroundColor Green
Start-Sleep -Seconds 300

Write-Host "Verify Decryption Successful" -ForegroundColor Green
Get-BitLockerVolume 

Write-Host "Restarting" -ForegroundColor Green
Stop-Transcript

shutdown -r -t 0 -f
