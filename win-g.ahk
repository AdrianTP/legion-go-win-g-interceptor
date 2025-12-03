#Requires AutoHotkey >=2.0
#SingleInstance Force
Persistent

#Include "%A_ScriptDir%\includes"
#Include 'vars.ahk'
#Include 'jNizM-dark-mode.ahk'
#Include 'FanaticGuru-gui-button-icon.ahk'
#Include 'helper-functions.ahk'
#Include 'xinput.ahk'
#Include 'startup-shortcut.ahk'
#Include 'config-file.ahk'
#Include 'gui.ahk'
#Include 'gui-steamcheck.ahk'
#Include 'gui-config.ahk'
#Include 'gui-debug.ahk'

; Written by:
; Adrian Thomas-Prestemon
; http://adriantp.com
;
; Tested on:
; Edition       Windows 11 Home
; Version       24H2
; Installed on ‎ 8/‎26/‎2025
; OS build      26100.6899
; Experience    Windows Feature Experience Pack 1000.26100.253.0
;
; Running on:
; Lenovo Legion Go 8APU1
;
; Prior Steps:
; 1. Disable everything inside Game Bar app
; 2. Disable everything related to Game Bar in Settings,
;    including in System > System Components, as well as
;    not letting it run in background
; 3. Cross your fingers?
;
; Optional Steps (uninstall Game Bar):
; 1. Right-click on PowerShell and click Run as Administrator
; 2. Get-AppxPackage -AllUsers Microsoft.XboxGamingOverlay | Remove-AppxPackage
; 3. Get-AppxPackage -AllUsers Microsoft.XboxGameOverlay | Remove-AppxPackage
;
; TODO:
; - FIX NEW BUG WHICH PRESSES #g WHEN SAVING CONFIG
; - fix the issue where this does not consistently bring up the Steam Overlay while a game is running
; - add/update config screen options:
;   - link to gamebar settings ConfigWindow._openSettingsGameBar
;   - link to gamebar system component settings/uninstall ConfigWindow._openSettingsSystemComponents
;   - button to uninstall gamebar ConfigWindow._uninstallGameBar
;   - button to reinstall gamebar ConfigWindow._reinstallGameBar
;   - change auto-kill ms-gamebar messages to be dependent upon GameBar being uninstalled
;   - tighten up the ms-gamebar window killer (if possible)
; - change tray icon to reflect current status (intercept, debug)

; CONFIG
DEV := false

SetWorkingDir(A_ScriptDir)
TraySetIcon('img\tray-icon.png')

SetMenuDarkMode()

GUI_CFG   := ConfigWindow()
GUI_SC    := SteamCheckWindow(3000)
GUI_DEBUG := DebugWindow()

SetWindowAttribute(GUI_CFG)
SetWindowTheme(GUI_CFG)

SetWindowAttribute(GUI_SC)
SetWindowTheme(GUI_SC)

SetWindowAttribute(GUI_DEBUG)
SetWindowTheme(GUI_DEBUG)

BuildTrayMenu() {
  global

  A_TrayMenu.Delete()

  if (DEV) {
    Menu_Standard := Menu()
    Menu_Standard.AddStandard()

    A_TrayMenu.Add('Reload', _reload)
    A_TrayMenu.Add('AHK', Menu_Standard)
    A_TrayMenu.Add()
    A_TrayMenu.Add()
    A_TrayMenu.Add()
  }

  A_TrayMenu.Add('Config', (*) => GUI_CFG.show())
  A_TrayMenu.Add()
  A_TrayMenu.Add('Exit', _exit)

  _exit(*) {
    ExitApp
  }

  _reload(*) {
    Reload
  }
}

BuildTrayMenu()

Sleep 1000

; The Xbox Guide button virtual keycode is "07", but this does not seem to work.
; For some reason this actually sends #^# instead of the virtual keycode for the
; Xbox Guide Button, but I'm keeping it here for posterity
;#g::Send("{vk07}")

#HotIf ConfigFile.INTERCEPT = true
; So instead let's emulate all the expected functionality manually
;$#g::SteamButton()
#g::SteamButton()
#HotIf
#g::return 1

; Some notes about ways to programmatically control Steam
; C:\Program Files (x86)\Steam\steam.exe Opens Steam if not running, focuses Steam if running
; C:\Program Files (x86)\Steam\steam.exe -bigpicture Opens Steam in Big Picture mode, whether currently running or not
; steam://open/ Focuses Steam (if Steam is running)
; steam://open/bigpicture Opens Steam in Big Picture Mode (if Steam is already running)
; alt+enter Exits Big Picture Mode, back to regular Steam
; shift+tab Opens Steam overlay (during a game) or main menu (with Big Picture Mode in focus)
; ctrl+alt+1 Opens Steam main menu (with Big Picture Mode in focus)
; ctrl+alt+2 Opens Steam "Quick Access" menu (with Big Picture Mode in focus)
; also, when Steam is in Big Picture Mode, a background process called gameoverlayui.exe or gameoverlayui64.exe should be running

Loop {
  global state := XInputState(0)

  KillMsGamebarPopups()
  KillMsGameBarProcess()

  GUI_CFG.update(state)
  GUI_SC.update(state)
  GUI_DEBUG.update(state)

  sleep 100
}

KillMsGamebarPopups() {
  if (!ConfigFile.AUTOKILL) {
    return
  }
;  ; FIXME: figure this out -- this should work, but it doesn't
;  if (WinExist('ahk_exe OpenWith.exe', 'ms-gamebar')) {
;    WinClose('ahk_exe OpenWith.exe', 'ms-gamebar')
;  }

  if (WinExist('Pick an app')) {
    WinClose('Pick an app')
  }

  if (WinExist('Give us a minute')) { ;, "We're updating Game Bar")) {
    WinClose('Give us a minute') ;, "We're updating Game Bar")
  }
}

KillMsGamebarProcess() {
  if (!ConfigFile.INTERCEPT) {
    return
  }

  if (ProcessExist('GameBar.exe')) {
    ProcessClose('GameBar.exe')
  }

  if (ProcessExist('GameBarFTServer.exe')) {
    ProcessClose('GameBarFTServer.exe')
  }
}

SteamButton() {
  if (!ConfigFile.INTERCEPT) {
    return
  }

;  Send '{up}'

  if (ConfigFile.LAUNCH and !ProcessExist("steam.exe")) {
    GUI_SC.show()
  } else if WinActive("Steam Big Picture Mode") {
    ; Steam is in Big Picture Mode, and is in the foreground
    ; Let's send ctrl+alt+1, which should open the SBPM main menu
    sleep 100

    Send "^!1"
  } else if ((ProcessExist("gameoverlayui.exe") or ProcessExist("gameoverlayui64.exe")) and !WinActive("Steam Big Picture Mode")) {
    ; Steam has launched a game with the Overlay enabled
    ; FIXME: unfortuantely I still haven't figured out how to get this to consistently trigger the Overlay
    ; FIXME: this presses shift+tab in, say, Notepad, but it's ignored by Steam while a game is in the foreground, unless you spam the button
    ; temporary workaround: map another controller button (or chord) to press shift+tab in order to raise the Overlay
    Send "+{Tab}"
;    Send "{Blind}+{Tab}"
;    SendInput "+{Tab}"
;    SendInput "{Blind}+{Tab}"
;    SendEvent "+{Tab}"
;    SendEvent "{Blind}+{Tab}"
  } else if WinExist("Steam Big Picture Mode") {
    ; Steam is in Big Picture Mode, but is in the background or minimised to the Taskbar
    ; Let's focus SBPM and open the main menu
    WinActivate("Steam Big Picture Mode")

    sleep 100

    if WinActive("Steam Big Picture Mode") {
      Send "^!1"
    }
  } else if WinActive('Steam',,'Run Steam ?') {
    ; Steam is in normal mode, and is in the foreground
    ; Let's open Steam in Big Picture Mode
    Run "steam://open/bigpicture"
  } else if WinExist("Steam") {
    ; Steam is in normal mode, but is in the background or minimised to the Taskbar
    ; Let's focus the Steam window
    WinActivate("Steam")
  } else if ProcessExist("steamwebhelper.exe") {
    ; Steam doesn't have a window, but is running in the background while minimized to the System Tray
    ; Let's run Steam as a way of telling the existing process to spawn a new window
    Run "C:\Program Files (x86)\Steam\steam.exe"
  } else {
    ; unknown state, do nothing
  }

  return 1
}