#Usage: LockScreenImage - LockScreenImageSource ""
#This script requires Administrator privileges
#Personalization CSP is a registry key added as part of windows 10 1703 edition. For more information visit https://docs.microsoft.com/en-us/windows/client-management/mdm/personalization-csp 

Param(
		[Parameter(Mandatory=$true)] 
		[ValidateNotNullOrEmpty()]
		[string]$LockScreenImageSource
	)


$PersonalizationRegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"

$RootFolder = "C:\Windows\System32"
$LocalImageFolder = "C:\Windows\System32\Personalization"
$LocalImage = "C:\Windows\System32\Personalization\LockScreenImage.jpg"

if(!(Test-Path $PersonalizationRegistryKeyPath)) {
        Write-Host "Registry path $($PersonalizationRegistryKeyPath) does not exist. Creating..."
        New-Item -Path $PersonalizationRegistryKeyPath -Force | Out-Null
}
if ($LockScreenImageSource) {
        Write-Host "Copying Lock Screen image from $($LockScreenImageSource) to local system $($LocalImage)."

        if(!(Test-Path $LocalImageFolder)){
            New-Item -Path $RootFolder -Name "Personalization" -ItemType "directory"
        }

        Copy-Item $LockScreenImageSource $LocalImage -Force
        Write-Host "Creating PersonalizationCSP registry entries for Lock Screen"
        New-ItemProperty -Path $PersonalizationRegistryKeyPath -Name "LockScreenImageStatus" -Value "1" -PropertyType DWORD -Force | Out-Null
        New-ItemProperty -Path $PersonalizationRegistryKeyPath -Name "LockScreenImagePath" -Value $LocalImage -PropertyType STRING -Force | Out-Null
        New-ItemProperty -Path $PersonalizationRegistryKeyPath -Name "LockScreenImageUrl" -Value $LocalImage -PropertyType STRING -Force | Out-Null
        Write-Host "Entries created."
}
 
