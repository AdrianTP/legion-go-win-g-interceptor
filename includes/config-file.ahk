class ConfigFile {
  static path := A_ScriptDir "\config.ini"

  static new() {
    throw
  }

  static __new() {
    this._read(true)

	this.firstRun := !FileExist(this.path)
  }

;  TODO: for some reason it's ignoring the INTERCEPT variable for HotIf, and ignoring HotKey On, HotKey Off, etc.
;  now i'm trying to cache the ini on app load and only update the vars (in this class) if they've been changed by the ConfigWindow
;  it's causing weird inconsistent behaviour and interference with GameBar
;
;  Hotkey('#g', callback, 'B0 P100 On')
;  Hotkey('#g', 'Off')
;
;  FIGURE THIS OUT! IT'S INFURIATING!

  static _read(force := false) {
    if (force) {
      this.LAUNCH    := IniRead(this.path, 'General', 'launch Steam', false)
	  this.INTERCEPT := IniRead(this.path, 'GameBar', 'suppress GameBar', false)
	  this.AUTOKILL  := IniRead(this.path, 'GameBar', 'kill MsGamebar popups', false)
      this.DEBUG     := IniRead(this.path, 'Debug', 'active', false)
	  this.STARTUP   := StartupShortcut.STARTUP
    }
  }

  static _write() {
	IniWrite(this.LAUNCH, this.path, 'General', 'launch Steam')
    IniWrite(this.INTERCEPT, this.path, 'GameBar', 'suppress GameBar')
    IniWrite(this.AUTOKILL, this.path, 'GameBar', 'kill MsGamebar popups')
    IniWrite(this.DEBUG, this.path, 'Debug', 'active')

	if (this.INTERCEPT) {
	  HotKey('#g', SteamButton(), 'B0 P100 On')
	} else {
	  HotKey('#g', 'Off')
	}

    if (this.DEBUG) {
      GUI_DEBUG.show()
    } else {
	  GUI_DEBUG.hide()
	}

    if (this.STARTUP) {
      StartupShortcut.create()
    } else {
      StartupShortcut.delete()
    }
  }

  static update(vars := false, write := false) {
    if (!vars) {
      return
    }

    this.LAUNCH    := vars.HasProp('enableLaunchSteam') ? !!vars.enableLaunchSteam  : this.LAUNCH
    this.INTERCEPT := vars.HasProp('enableIntercept')   ? !!vars.enableIntercept    : this.INTERCEPT
    this.AUTOKILL  := vars.HasProp('enableAutokill')    ? !!vars.enableAutokill     : this.AUTOKILL
    this.DEBUG     := vars.HasProp('enableDebug')       ? !!vars.enableDebug        : this.DEBUG
	this.STARTUP   := vars.HasProp('runAtStartup')      ? !!vars.enableRunAtStartup : this.STARTUP

	if (write) {
	  this._write()
	}
  }
}