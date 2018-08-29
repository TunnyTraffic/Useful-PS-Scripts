<#
.SYNOPSIS
Change password on accounts listed in a csv file. No prompt, forced change.

CSV layout:
samname,oldpassword,newpassword
account1,password123,password456
account2,password789,password012
#>

Import-Csv C:\path\accounts.csv |`
    ForEach-Object {
        $samname = $_.samname
        $oldpassword = $_.oldpassword
        $newpassword = $_.newpassword
        write-host $samname","$oldpassword","$newpassword
        Set-ADAccountPassword -Identity $samname -OldPassword (ConvertTo-SecureString -AsPlainText $oldpassword -Force) -NewPassword (ConvertTo-SecureString $newpassword -AsPlainText  -Force)
    }
