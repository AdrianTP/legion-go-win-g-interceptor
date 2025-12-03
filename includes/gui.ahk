class CustomGui extends Gui {
  __New(title := '', scope := this) {
    super.__New('+AlwaysOnTop -Caption -SysMenu +ToolWindow', title, scope)

    this.BackColor := '333333'
    this.SetFont('cdddddd q5')

    SetWindowAttribute(this)
    SetWindowTheme(this)
  }

  IsVisibleAndActive() {
    return WinExist(this) and WinActive(this)
  }

  _allButtons() {
    buttons := []

    for ctrl in this.controls {
      if (ctrl.type = 'Button') {
        buttons.push(ctrl)
      }
    }

    return buttons
  }

  AddXboxButton(img, dim := '', label := '') {
    btnDef := this.Add('Button', dim, label)

    GuiButtonIcon(btnDef, 'img\xbox-button-' . img . '.png', 1, 's32 a0 t5 r5 b5 l5')

    return btnDef
  }
}

class NonBlockingDialog extends CustomGui {
  __New(title := '', text := '', yesFn := false, noFn := false, timer := 0, scope := this) {
    super.__New(title, scope)
    this.yesFn := yesFn
    this.noFn := noFn

    this.SetFont('s24')

    this.Add('Text',, text)

    this.SetFont('s12')

    this._timeUntilAutoHide := timer

    if (timer > 0) {
      this._timerText := this.Add('Text',, this._timerMessage(timer))
    } else {
      this._timerText := this.Add('Text',,'')
    }

    this.SetFont('s24')

    this.yesBtn := this.AddXboxButton('a', 'w100 h50', 'Yes')
    this.noBtn := this.AddXboxButton('b', 'x+10 w90 h50', 'No')

    this.yesBtn.OnEvent('Click', this._yesHandler)
    this.noBtn.OnEvent('Click', this._noHandler)
  }

  _timerMessage(timer := 0) {
    return "(auto-closes in " . Round(timer/1000) . " seconds)"
  }

  _yesHandler(*) {
    if (type(this.gui.yesFn) = 'Func') {
      this.gui.yesFn(true)
    }

    this.gui.hide()
  }

  _noHandler(*) {
    if (type(this.gui.noFn) = 'Func') {
      this.gui.noFn(true)
    }

    this.gui.hide()
  }

  show() {
    super.show('center')

    if (this._timeUntilAutoHide > 0) {
      this._timeRemaining := this._timeUntilAutoHide

      this._autoHideTimer()
    }
  }

  _autoHideTimer(*) {
    if (this._timeRemaining > 0) {
      this._timeRemaining -= 100 ;this._elapsedTime()

      this._timerText.Text := this._timerMessage(this._timeRemaining + 500)

      SetTimer(this._autoHideTimer.bind(this), -100)
    } else {
      this.hide()
    }
  }
}