<#
.SYNOPSIS
Run scripts as a job and report when each is complete.

Alternative is to use wait-job JobName until a job is complete then to continue the script.
#>


$testjob1 = Start-Job -Name "TestJob1" -ScriptBlock {invoke-expression -Command "C:\ReportingTest\TestJob1.ps1"}
$testjob2 = Start-Job -Name "TestJob2" -ScriptBlock {invoke-expression -Command "C:\ReportingTest\TestJob2.ps1"}

$jobevent = Register-ObjectEvent $testjob1 StateChanged -Action {
    write-host "TestJob1 complete"
    $jobevent | unregister-event
}

$jobevent = Register-ObjectEvent $testjob2 StateChanged -Action {
    write-host "TestJob2 complete"
    $jobevent | unregister-event
}
