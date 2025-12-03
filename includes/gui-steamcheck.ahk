; pop up confirmation box asking to run Steam
class SteamCheckWindow extends NonBlockingDialog {
  __New(timer := 0) {
    super.__New(
      'Run Steam?',
      'Steam is not running. Start it?',
      this._yesHandler,
      ,
      timer,
      this
    )
  }

  _yesHandler(*) {
    Run('C:\Program Files (x86)\Steam\steam.exe')
  }

  update(state) {
    btn := state.wButtonsMap

    if (!this.IsVisibleAndActive()) {
      if (DEV and btn.a and btn.b and btn.x and btn.y and btn.lb and btn.rb and btn.back and !btn.menu) {
        this.show()
      }

      return
    }

    if (btn.onlyPressed('a')) {
      ControlClick(this.yesBtn)
    }

    if (btn.onlyPressed('b')) {
      ControlClick(this.noBtn)
    }
  }
}