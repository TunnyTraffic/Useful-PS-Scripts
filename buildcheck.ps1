<#
This take a list of servers (IP or name) and returns the following information:
The name/IP address of the machine in the list
The name as reported by the machine
CPU processors and cores
Any IP addresses on active connections
Total RAM
Local disks and size
Confirmed dotnet 3.5 is installed.

To do:
Tidy output.
Format disk and RAM sizes.
List dotnet versions rather than look for 3.5.

Sample input:
APPSERVER1
APPSERVER2
10.11.12.13

Sample output:

FromList     : APPSERVER1
ComputerName : LAPPSERVER1
CPU_Cores    : {1 1, 1 1}
IP_Add       : {10.xx.yy.zz, dead::beef:::}
RAM          : 34359738368
Drives       : {C: D:, 68719476736, 68719476736}
Dotnet_Ver   : 3.5.30729.4926
#>



$computers = Get-Content C:\Scripts\build\serverlist.txt
$output = Foreach($machine in $computers){
    $system = Get-WmiObject Win32_ComputerSystem -ComputerName $machine | Select-Object -Property Name
    $ipadd = Get-WmiObject -query "Select * from Win32_NetworkAdapterConfiguration Where IPEnabled = True" -ComputerName $machine
    $drives = Get-WmiObject -query "Select * from Win32_logicaldisk where DriveType = '3'" -ComputerName $machine
    $ram = Get-WmiObject Win32_PhysicalMemory -ComputerName $machine | Measure-Object -Property Capacity -Sum
    $cpu = Get-WmiObject -class win32_processor -ComputerName $machine
    $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $machine)
    $regkey = $reg.OpenSubKey("Software\Microsoft\Net Framework Setup\NDP\v3.5")
    $dotnet = $regkey.GetValue("Version")


    [PSCustomObject]@{
        FromList = $machine
        ComputerName = $system.name
        CPU_Cores = $cpu.NumberOfLogicalProcessors, $cpu.NumberOfCores
        IP_Add = $ipadd.IPAddress
        RAM = $ram.Sum
        Drives = $drives.DeviceID, $drives.size
        Dotnet_Ver = $dotnet
    }
}
$output > c:\Scripts\build\buildresults.txt
