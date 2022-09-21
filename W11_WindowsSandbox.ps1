################################################################################################
# This script can be used to install Windows Sandbox on Windows 10 & 11                        #
# Editor : Christopher Mogis                                                                   #
# Date : 09/6/2022                                                                             #
# Version 1.0                                                                                  #
# - Initial version                                                                            #
################################################################################################

#Variables
#$Date = Get-Date
$ComputerInfo = Get-ComputerInfo

        Write-Output ""
        $continue = $true
        while ($continue){
          write-host "---------------------- Windows SandBox Installation -----------------------"
          write-host "1. Prerequisites check" -ForegroundColor Cyan
          write-host "2. Install Windows Sandbox" -ForegroundColor Cyan
          write-host "x. exit" -ForegroundColor Yellow
          write-host "---------------------------------------------------------------------------"
          $choix = read-host "Choose an action :"
          switch ($choix){
            "1" {
                #Prerequisites for used Windows SandBox
                #Windows Version
                Write-Output ""
                Write-Output  "### Windows SandBox prerequisites check ###"
                Write-Output ""
                $WinVer = $ComputerInfo.WindowsProductName
                if($WinVer -eq "Windows 10 Enterprise" -OR "Windows 10 Professional" )
                {
                    Write-Host "$WinVer installed on $($ComputerInfo.CsName) is compatible with the Windows Sandbox feature" -ForegroundColor Green <# Action to perform if the condition is true #>
                }
                else 
                {
                    Write-Host "$WinVer installed on $($ComputerInfo.CsName) is not compatible with the Windows Sandbox feature" -ForegroundColor Red <# Action when all if and elseif conditions are false #>
                }
                #CPU Architecture
                Write-Output ""
                Write-Output  "### Check CPU Configuration ###"
                Write-Output ""
                $CoreCPU = $ComputerInfo.CsNumberOfLogicalProcessors
                if($CoreCPU -ge "3"  )
                {
                    Write-Host "The CPU on $($ComputerInfo.CsName) is compatible with the Windows Sandbox feature" -ForegroundColor Green <# Action to perform if the condition is true #>
                }
                else 
                {
                    Write-Host "The CPU on $($ComputerInfo.CsName) is not compatible with the Windows Sandbox feature" -ForegroundColor Red <# Action when all if and elseif conditions are false #>
                }
                #RAM Available
                Write-Output ""
                Write-Output  "### Check Memory Ram Installed ###"
                Write-Output ""
                $RamMemory = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | ForEach-Object {"{0:N2}" -f ([math]::round($_.Sum / 1GB))}
                if($RamMemory -lt "4.00")
                {
                    Write-Host "The Quantity of Memory Ram installed on $($ComputerInfo.CsName) is ready  with the Windows Sandbox feature" -ForegroundColor Green <# Action to perform if the condition is true #>
                }
                else 
                {
                    Write-Host "The Quantity of Memory Ram installed on $($ComputerInfo.CsName) is not ready with the Windows Sandbox feature" -ForegroundColor Red <# Action when all if and elseif conditions are false #>
                }
                #RAM Available
                Write-Output ""
                Write-Output  "### Check HyperV feature ###"
                Write-Output ""
                $HyperV = (Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online).State
                if($HyperV -eq "Enabled")
                {
                    Write-Host "Windows Hypervisor is enabled on your computer" -ForegroundColor Green <# Action to perform if the condition is true #>
                }
                else 
                {
                    Write-Host "WARNING - Windows Hypervisor is not enabled on your computer" -ForegroundColor Red <# Action when all if and elseif conditions are false #>
                }
                Write-Output ""
                }
                #Option 3 : Windows Sandbox installation
            "2" {
                    Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online
                    Write-Host "After installation, please restart your computer and relaunch this script and select option 1 " -ForegroundColor Green
                    Write-Output ""
                }
                #Option x : Exit menu
            "x" {$continue = $false}
            default {Write-Host "Choix invalide" -ForegroundColor Red}
          }
        }
