$computers = Get-Content "C:\scripts\machines.txt" # list of IPs or machine names (one machine per line)
$fileToCopy = "installfile.exe" # don't put the path in here as it's used elsewhere.


$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path "C:\scripts\transcript.txt" -Append #

ForEach($computer in $Computers)
{
    Write-Output **** Starting $computer ****
    Get-Date -format o 

    $destination= "\\$computer\C$\install"

    New-Item -Path $detination -type directory -Force #create the destination folder if it doesn't exist
    
    try
    {
        Copy-Item -Path $fileToCopy -Destination $destination -verbose -recurse 
        invoke-command -ComputerName $computer -ScriptBlock {
            Start-Process ($destination + $fileToCopy) -ArgumentList '/s /qn /v' -Wait #wait until it's completed otherwise the session will close and the installer with it
        }

        Invoke-Command -ComputerName $computer -ScriptBlock {((Get-Item -path "updatedfile.file").VersionInfo.FileVersion)} # this one uses the file version of a dll as a post-install check
    
    }      
    catch {Write-Output $computer | out-file -append -filepath "C:\scripts\failed.log"} #throw any errors in here.
    Get-Date -format o
    Write-Output **** Finished $computer ****
 }

Stop-Transcript #if the script crashed out run this line to close the file.
