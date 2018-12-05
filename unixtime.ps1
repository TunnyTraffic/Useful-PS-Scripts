<#
.SYNOPSIS
Converts unix time to readable format (unless you're a robot, you freak)

Example output for 1513083850.106864000

12 December 2017 13:04:10
#>

$unixtime = "1513083850.106864000"
$date = get-date "1/1/1970"
$date.addseconds($unixtime).tolocaltime()
