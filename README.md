# BitLocker-WFHTermination-Oct2022
Do you have an employee that needs to be terminated but works remotely? This script allows you to get the current BitLocker key, rotate its password and output the new BitLocker Key, wipes the credentials of that current user, disables both the local user and administrator logins of that machine, then forces the machine to go into BitLocker recovery. This effectively disables the user from gaining back access to that machine. 

There is an optional feature that disables both the Wi-Fi and Ethernet adapters on the machine, further disabling the terminated user from being able to access that machine by changing the DNS addresses on the machine to localhost. 

```
Disable-NetAdapter -Name "Ethernet" -Confirm:$false
Disable-NetAdapter -Name "Wi-Fi" -Confirm:$false
```

# Reference Links:
- https://rcmtech.wordpress.com/2017/01/11/change-bitlocker-recovery-password-with-powershell/
- https://www.reddit.com/r/sysadmin/comments/p15ugb/remotely_triggering_bitlocker_recovery_screen_to
- https://rcmtech.wordpress.com/2017/01/11/change-bitlocker-recovery-password-with-powershell/
- https://helpdesk.eoas.ubc.ca/kb/articles/use-powershell-to-get-the-bitlocker-recovery-key
- https://learn.microsoft.com/en-us/windows/security/information-protection/bitlocker/bitlocker-recovery-guide-plan
- https://techexpert.tips/powershell/powershell-remove-bitlocker-encryption/

