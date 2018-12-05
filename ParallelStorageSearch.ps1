<#
.SYNOPSIS
Take a list of servers and searches for all files with extension .xyz
Creates a report in CSV format for each server/unc path with the file name, size (in bytes), last write time, and full path.
Runs the search in parallel to minimise run time.

serer list layout:
server1
server2
server3
server4

#>

$computers = Get-Content "serverlist.txt"

workflow pbatch {
param ([string[]]$servers)

    foreach -parallel ($server in $servers) {
        InlineScript{
            $storagepath = "\\uncpath\STORE" + $Using:server  
            $storagepath
            $outpath = "c:\scripts\storage_report\staging\" + $Using:server + "_storage_" + (get-date).ToString("yyMMddhhmm") + ".csv"
            $outpath
            Get-ChildItem -Path $storagepath -Include *.xyz -Recurse | % {[pscustomobject]@{ Name =  $_.Name ; Size = $_.Length ; LastWrite = $_.LastWriteTimeUtc ; FullPath = $_.FullName}} | export-csv -path $outpath -append
        }
    }
}

pbatch -servers $computers
