################################################################################################
# Este script se usa para instalar Windows Sandbox en Windows 10 y 11                          #
# Creador : Christopher Mogis - Traductor : Luis Gerardo Mendoza                               #
# Fecha : 09/6/2022                                                                            #
# Version 1.0                                                                                  #
# - Initial version                                                                            #
################################################################################################

#Variables
#$Date = Get-Date
$ComputerInfo = Get-ComputerInfo

    Write-Output ""
    $WinSandbox = (Get-WindowsOptionalFeature -FeatureName Containers-DisposableClientVM -Online).State
    $HyperV = (Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online).State
    if($WinSandbox -eq "Enabled" -And $HyperV -eq "Enabled")
    {
        Write-Host "Windows Sandbox esta habilitado $($ComputerInfo.CsName)" -ForegroundColor Green <# Accion para validar si Sandbox esta habilitado #>
        Write-Output ""
        $configuration = $true
        while ($configuration)
        {
          write-host "---------------------- Configuracion Windows SandBox  -----------------------"
          write-host "1. Configurar Windows Sandbox" -ForegroundColor Cyan
          write-host "x. Salir" -ForegroundColor Yellow
          write-host "----------------------------------------------------------------------------"
          $choix = read-host "Elige una opcion :"
          switch ($choix)
            {
            "1" {
                write-host "1. Configurar Windows Sandbox" -ForegroundColor Cyan
                }
            "x" {$configuration = $false}
            default {Write-Host "Opcion Invalida" -ForegroundColor Red}
            }
        }
    }
    else 
    {
        $continue = $true
        while ($continue){
          write-host "---------------------- Instalacion de Windows SandBox -----------------------"
          write-host "1. Chequear Prerequisitos" -ForegroundColor Cyan
          write-host "2. Instalar Hyper-V" -ForegroundColor Cyan
          write-host "3. Instalar Windows Sandbox" -ForegroundColor Cyan
          write-host "x. Salir" -ForegroundColor Yellow
          write-host "---------------------------------------------------------------------------"
          $choix = read-host "Elige una opcion :"
          switch ($choix){
            "1" {
                #Prerequisitos para usar Windows SandBox
                #Version de Windows
                Write-Output ""
                Write-Output  "### Chequeando prerequisitos de Windows SandBox ###"
                Write-Output ""
                $WinVer = $ComputerInfo.WindowsProductName
                if($WinVer -eq "Windows 10 Enterprise" -OR "Windows 10 Professional" )
                {
                    Write-Host "$WinVer Instalado en $($ComputerInfo.CsName) es compatible con Windows Sandbox" -ForegroundColor Green <# Validar que esta condicion sea verdadera #>
                }
                else 
                {
                    Write-Host "$WinVer Instalado en $($ComputerInfo.CsName) NO es compatible con Windows Sandbox" -ForegroundColor Red <# La validacion es falsa por lo tanto no se puede permitir la instalacion de la Caracteristica #>
                }
                #Arquitectura de la CPU
                Write-Output ""
                Write-Output  "### Chequeando configuracion de la CPU ###"
                Write-Output ""
                $CoreCPU = $ComputerInfo.CsNumberOfLogicalProcessors
                if($CoreCPU -ge "3"  )
                {
                    Write-Host "El CPU en $($ComputerInfo.CsName) es compatible con Windows Sandbox" -ForegroundColor Green <# Validar que esta condicion sea verdadera #>
                }
                else 
                {
                    Write-Host "El CPU en $($ComputerInfo.CsName) NO es compatible con Windows Sandbox" -ForegroundColor Red <# La validacion es falsa por lo tanto no se puede permitir la instalacion de la Caracteristica #>
                }
                #Memoria RAM Disponible
                Write-Output ""
                Write-Output  "### Chequeando la Memoria RAM Instalada ###"
                Write-Output ""
                $RamMemory = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | ForEach-Object {"{0:N2}" -f ([math]::round($_.Sum / 1GB))}
                if($RamMemory -lt "4.00")
                {
                    Write-Host "La Cantidad de Memoria RAM instalada en $($ComputerInfo.CsName) Es disponible para la Caracteristica de Windows Sandbox" -ForegroundColor Green <# Validar que esta condicion sea verdadera #>
                }
                else 
                {
                    Write-Host "La Cantidad de Memoria RAM instalada ens $($ComputerInfo.CsName) No es suficiente para la Caracteristica de Windows Sandbox" -ForegroundColor Red <# La validacion es falsa por lo tanto no se puede permitir la instalacion de la Caracteristica #>
                }
                #Memoria RAM Disponible
                Write-Output ""
                Write-Output  "### Chequeando la Caracteristica de HyperV ###"
                Write-Output ""
                $HyperV = (Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online).State
                if($HyperV -eq "Enabled")
                {
                    Write-Host "Windows HyperV esta habilitado en su computador" -ForegroundColor Green <# Validar que esta condicion sea verdadera #>
                }
                else 
                {
                    Write-Host "WARNING - Windows HyperV no esta habilitado en su computador" -ForegroundColor Red <# La validacion es falsa por lo tanto no se puede permitir la instalacion de la Caracteristica #>
                }
                Write-Output ""
                }
                #Option 2 : Instalando Hyper-V 
            "2" {
                Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
                Write-Host "Despues de la instalacion, por favor selecciona la Opcion 3 para instalar Windows Sandbox" -ForegroundColor Green
                Write-Output ""
                }  
                #Option 3 : Instalacion de Windows Sandbox
            "3" {
                Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online
                Write-Host "Despues de la instalacion, por favor reinicia su computador y vuelva a ejecutar este script y selecciona la Opcion 1 " -ForegroundColor Green
                Write-Output ""
                }
                #Option x : Salir del Menu
            "x" {$continue = $false}
            default {Write-Host "Opcion Invalida" -ForegroundColor Red}
          }
        }
    }
