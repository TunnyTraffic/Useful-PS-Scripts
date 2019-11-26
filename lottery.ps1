<#
From a range pick n winners. Remove the winners from the array each loop so they don't get picked again
Will work with a string array too - just initialise as $entries = @("element1","element2")

#>

$entries = @(1..150)

For ($i=0; $i -le 9; $i++) {
    $winner = Get-Random -InputObject $entries
    $entries = $entries | Where-Object { ($_ -ne $winner) }
    Write-Output "Pack $i winner: $winner" 
    }
