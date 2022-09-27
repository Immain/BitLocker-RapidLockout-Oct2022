# BitLocker-RapidLockout-Oct2022
Do you have an employee that needs to be terminated but works remotely? This script allows you to get the current BitLocker key, rotate the key to a new one and outputs the new BitLocker Key in console and adds it to Active Directory, wipes the credentials of that current user, disables both the local user and administrator logins of that machine, then forces the machine to go into BitLocker recovery. This effectively disables the user from gaining back access to that machine. 

## Features:
- Uses Write-Output: to write the "normal" output of the code to the default (success) output stream ("STDOUT").
- Removes All Credentials from Windows Credential Manager
- Identifies Current BitLocker Volumes
- Pulls Original BitLocker Recovery Key
- Rotates the BitLocker Recovery Key
- Outputs New BitLocker Recovery Key
- Grabs the Manufacturer, Model, and BIOS Serial Numbers
- Disables the Local User and Admin Accounts of the Remote User
- Forces BitLocker Recovery of the Remote Users Machine
- Changes the DNS Addresses of the Remote Users Machine to Localhost disabling the Internet
- Restarts into BitLocker Recovery Mode

## Note:
For this script to work properly, BitLocker **MUST** be enabled on the end-user's machine. 

## Optional
There are some optional features that disables both the Wi-Fi and Ethernet adapters on the machine, further disabling the terminated user from being able to access that machine by changing the DNS addresses on the machine to localhost. You can also use the Get-WmiObject to pull the IP and MAC Address of the End-User Machine

*Disable Network Adapter*
```
Disable-NetAdapter -Name "Ethernet" -Confirm:$false
Disable-NetAdapter -Name "Wi-Fi" -Confirm:$false
```

*Get IP and MAC Address*
```
$MAC = (Get-WmiObject -Class:Win32_NetworkAdapterConfiguration).MACAddress
Write-Host ("MAC Address: $MAC")

$IP = (Get-WmiObject -Class:Win32_NetworkAdapterConfiguration).IPAddress
Write-Host ("IP Address: $IP")
```

## Using Different Write Commands:
The Write-* cmdlets allow you to channel the output of your PowerShell code in a structured way, so you can easily distinguish messages of different severity from each other.

- ```Write-Host:``` display messages to an interactive user on the console. Unlike the other Write-* cmdlets this one is neither suitable nor intended for automation/redirection purposes. Not evil, just different.
- ```Write-Output:``` write the "normal" output of the code to the default (success) output stream ("STDOUT").
- ```Write-Error:``` write error information to a separate stream ("STDERR").
- ```Write-Warning:``` write messages that you consider warnings (i.e. things that aren't failures, but something that the user should have an eye on) to a separate stream.
- ```Write-Verbose:``` write information that you consider more verbose than "normal" output to a separate stream.
- ```Write-Debug:``` write information that you consider relevant for debugging your code to a separate stream.
- ```Write-Information:``` is just a continuation of this approach. It allows you to implement log levels in your output (Debug, Verbose, Information, Warning, Error) and still have the success output stream available for regular output.

## Reference Links:
- https://rcmtech.wordpress.com/2017/01/11/change-bitlocker-recovery-password-with-powershell/
- https://www.reddit.com/r/sysadmin/comments/p15ugb/remotely_triggering_bitlocker_recovery_screen_to
- https://rcmtech.wordpress.com/2017/01/11/change-bitlocker-recovery-password-with-powershell/
- https://helpdesk.eoas.ubc.ca/kb/articles/use-powershell-to-get-the-bitlocker-recovery-key
- https://learn.microsoft.com/en-us/windows/security/information-protection/bitlocker/bitlocker-recovery-guide-plan
- https://techexpert.tips/powershell/powershell-remove-bitlocker-encryption/

