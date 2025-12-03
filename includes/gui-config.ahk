class ConfigWindow extends CustomGui {
  __New() {
    super.__New()

    this.SetFont('s12')

    this.Add('Text',,'To show this screen again:')
    this.Add('Text',,'- Select "Config" form the System Tray icon right-click menu')
    this.Add('Text',,'- Press A+B+X+Y+LB+RB+Back+Menu to show this screen again')

    this.SetFont('s24')

    this.startupCB := this.Add('CheckBox', 'venableRunAtStartup w800', 'Run when Windows starts')
    this.startupCB.Value := ConfigFile.STARTUP

    this.interceptCB := this.Add('CheckBox', 'venableIntercept w800', 'Suppress GameBar and redirect Win+G to Steam')
    this.interceptCB.Value := ConfigFile.INTERCEPT

    this.launchSteamCB := this.Add('CheckBox', 'venableLaunchSteam w800', "Offer to launch Steam if it isn't already running")
    this.launchSteamCB.Value := ConfigFile.LAUNCH

    this.autoKillMessagesCB := this.Add('CheckBox', 'venableAutoKill w800', 'Suppress ms-gamebar popups')
    this.autoKillMessagesCB.Value := ConfigFile.AUTOKILL

    this.debugCB := this.Add('CheckBox', 'venableDebug w800', 'Enable Debug Mode')
    this.debugCB.Value := ConfigFile.DEBUG

	; TODO: add controls here for:
	; - _openSettingsGameBar
	; - _openSettingsSystemComponents
	; - _uninstallGameBar
	; - _reinstallGameBar

    this.checkboxes := [
      this.startupCB,
	  this.interceptCB,
	  this.launchSteamCB,
	  this.autoKillMessagesCB,
	  this.debugCB,
    ]

	for (i, cb in this.checkboxes) {
	  cb.OnEvent('Focus', this._cbFocusChange.bind(this))
	  cb.OnEvent('LoseFocus', this._cbFocusChange.bind(this))
	}

    this.SetFont('s12')

    this.Add('Text',, 'd-pad Up/Down to select, A to toggle checkbox')

    this.SetFont('s24')

    this.saveBtn := this.AddXboxButton('y', 'w120 h50', 'Save')
    this.saveBtn.OnEvent('Click', this._btnHandler.bind(this))

    this.cancelBtn := this.AddXboxButton('b', 'x+10 w150 h50', 'Cancel')
    this.cancelBtn.OnEvent('Click', this._btnHandler.bind(this))

    if (ConfigFile.firstRun) {
      this.show()
    }
  }

  _cbFocusChange(cb, info) {
    if (cb.focused) {
      cb.SetFont('bold')
    } else {
      cb.SetFont('norm')
    }
  }

  _btnHandler(btn, info) {
    if (btn.Text = 'Save') {
      this._submitHandler()
    }

    this.hide()
  }

  _submitHandler() {
    ConfigFile.update(this.submit(true), true)
  }

  ; TODO: use _openSettingsGameBar
  _openSettingsGameBar() {
    Run('ms-settings:gaming-gamebar') ; can disable controller trigger
  }

  ; TODO: use _openSettingsSystemComponents
  _openSettingsSystemComponents() {
    Run('ms-settings:systemcomponents') ; can disable background and uninstall here
  }

  ; TODO: use _uninstallGameBar
  _uninstallGameBar() {
    Run('*RunAs powershell.exe -NoExit -Command' . "`"" . PowerShell.RemoveGamingOverlay . "`"")
  }

  ; TODO: use _reinstallGameBar
  _reinstallGameBar() {
    Run('*RunAs powershell.exe -NoExit -Command' . "`"" . PowerShell.InstallGamingOverlay . "`"")
  }

  show() {
	ControlFocus(this.startupCB)

    super.show('center')
  }

  update(state) {
    btn := state.wButtonsMap

    if (!this.IsVisibleAndActive()) {
      if (btn.a and btn.b and btn.x and btn.y and btn.lb and btn.rb and btn.back and btn.menu) {
        this.show()
      }

      return
    }

    if (btn.onlyPressed('y')) {
      ControlClick(this.saveBtn)
    }

    if (btn.onlyPressed('b')) {
      ControlClick(this.cancelBtn)
    }

    if (btn.onlyPressed('up')) {
	  focusPrev := false

      Loop this.checkboxes.length {
	    i := this.checkboxes.length - A_Index + 1

		if (focusPrev) {
		  ControlFocus(this.checkboxes[i])

		  break
		}

		if (i > 1) {
		  focusPrev := this.checkboxes[i].focused
		}
	  }
    }

    if (btn.onlyPressed('down')) {
      focusNext := false

      for i, cb in this.checkboxes {
		if (focusNext) {
		  ControlFocus(this.checkboxes[i])

		  break
		}

        if (i < this.checkboxes.length) {
          focusNext := cb.focused
		}
      }
    }

    if (btn.onlyPressed('a')) {
	  if (this._aReleased) {
		this._aReleased := false

        ControlClick(this.FocusedCtrl)
	  }
    }

	if (!btn.a) {
	  this._aReleased := true
	}
  }
}