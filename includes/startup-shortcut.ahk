class StartupShortcut {
  static path := A_Startup "\" A_Scriptname ".lnk"

  static new() {
    throw
  }

  static __new() {
    this.STARTUP := this.exists()

    this._createFailureWindow := NonBlockingDialog('Oops!', 'Could not create startup shortcut at' . this.path,,,3000)
	this._deleteFailureWindow := NonBlockingDialog('Oops!', 'Could not delete startup shortcut at' . this.path,,,3000)
  }

  static exists() {
    return !!FileExist(this.path)
  }

  static create() {
    if (this.exists()) {
      return true
    }

    FileCreateShortcut(A_ScriptFullPath, this.path, A_ScriptDir)

    this.STARTUP := this.exists()

	if (!this.STARTUP) {
	  this._createFailureWindow.show()
	}

	return this.STARTUP
  }

  static delete() {
    if (!this.exists()) {
      return true
    }

	FileDelete(this.path)

    this.STARTUP := this.exists()

	if (this.STARTUP) {
	  this._createFailureWindow.show()
	}

	return !this.STARTUP
  }
}