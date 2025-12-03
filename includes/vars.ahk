#Requires AutoHotkey v2.0

PowerShell := {
  InstallGamingOverlay : "Get-AppxPackage Microsoft.XboxGamingOverlay | Add-AppxPackage -Register -DisableDevelopmentMode  -Register `"$($_.InstallLocation)\AppXManifest.xml`"}",
  RemoveGamingOverlay  : 'Get-AppxPackage -AllUsers Microsoft.XboxGamingOverlay | Remove-AppxPackage',
}

ExePaths := {
  GameBar   : 'C:\Program Files\WindowsApps\Microsoft.XboxGamingOverlay_7.325.11061.0_x64__8wekyb3d8bbwe',
  GamingSvc : 'C:\Program Files\WindowsApps\Microsoft.GamingServices_32.107.3004.0_x64__8wekyb3d8bbwe',
}

RegistryPaths := {
  Main: {
    GameBar             : 'HKEY_CURRENT_USER\Software\Microsoft\GameBar',
    GameBarApi          : 'HKEY_CURRENT_USER\Software\Microsoft\GameBarApi',
    GameInput           : 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\GameInput',
    GameInputRedist     : 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\GameInputRedist',
    GameOverlay         : 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\GameOverlay',
    GamingServicesCU    : 'HKEY_CURRENT_USER\Software\Microsoft\GamingServices',
    GamingServicesLM    : 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\GamingServices',
  },
  WindowsCurrentVersion: {
    Main: {
      GameDVR               : 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\GameDVR',
      GameInput             : 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\GameInput',
      GamingConfigurationCU : 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\GamingConfiguration',
      GamingConfigurationLM : 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\GamingConfiguration',
    },
    Uninstall: {
      GameInput : 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{ECB4BDD1-984C-9F25-299C-A9EF75C14197}'
    },
  },
}