; transparent gui in upper right corner with controller button values, variables, etc.
class DebugWindow extends CustomGui {
  __New() {
    super.__New()

    this.SetFont('s8')

    this.int := this.Add('Text','w400','0')

    this.a := this.Add('Text', 'w100', 'A: ' 0)
    this.b := this.Add('Text', 'w100', 'B: ' 0)
    this.x := this.Add('Text', 'w100', 'X: ' 0)
    this.y := this.Add('Text', 'w100', 'Y: ' 0)
    this.lb := this.Add('Text', 'w100', 'LB: ' 0)
    this.rb := this.Add('Text', 'w100', 'RB: ' 0)
    this.back := this.Add('Text', 'w100', 'Back: ' 0)
    this.menu := this.Add('Text', 'w100', 'Menu: ' 0)
    this.ls := this.Add('Text', 'w100', 'LS: ' 0)
    this.rs := this.Add('Text', 'w100', 'RS: ' 0)
    this.up := this.Add('Text', 'w100', 'Up: ' 0)
    this.down := this.Add('Text', 'w100', 'Down: ' 0)
    this.left := this.Add('Text', 'w100', 'Left: ' 0)
    this.right := this.Add('Text', 'w100', 'Right: ' 0)
    this.b6 := this.Add('Text', 'w100', 'B6: ' 0)
    this.b7 := this.Add('Text', 'w100', 'B7: ' 0)
    this.guide := this.Add('Text', 'w100', 'Guide: ' 0)

    this.lt := this.Add('Text', 'w100', 'LT: ' 0)
    this.rt := this.Add('Text', 'w100', 'RT: ' 0)
    this.lsx := this.Add('Text', 'w100', 'LS X: ' 0)
    this.lsy := this.Add('Text', 'w100', 'LS Y: ' 0)
    this.rsx := this.Add('Text', 'w100', 'RS X: ' 0)
    this.rsy := this.Add('Text', 'w100', 'RS Y: ' 0)

    WinSetExStyle('+0x20', this) ; 0x20 = WS_EX_TRANSPARENT
;    WinSetTransColor('333333 0', this)
    WinSetTransparent(64, this)
  }

  update(state) {
    if (!ConfigFile.DEBUG) {
      return
    } else if (!this.IsVisibleAndActive()) {
      this.show()
    } else {
      this.int.Text := '' . state.wButtons

      this.a.Text := 'A: ' state.wButtonsMap.a
      this.b.Text := 'B: ' state.wButtonsMap.b
      this.x.Text := 'X: ' state.wButtonsMap.x
      this.y.Text := 'Y: ' state.wButtonsMap.y
      this.lb.Text := 'LB: ' state.wButtonsMap.lb
      this.rb.Text := 'RB: ' state.wButtonsMap.rb
      this.back.Text := 'Back: ' state.wButtonsMap.back
      this.menu.Text := 'Menu: ' state.wButtonsMap.menu
      this.ls.Text := 'LS: ' state.wButtonsMap.ls
      this.rs.Text := 'RS: ' state.wButtonsMap.rs
      this.up.Text := 'Up: ' state.wButtonsMap.up
      this.down.Text := 'Down: ' state.wButtonsMap.down
      this.left.Text := 'Left: ' state.wButtonsMap.left
      this.right.Text := 'Right: ' state.wButtonsMap.right
      this.b6.Text := 'B6: ' state.wButtonsMap.b6
      this.b7.Text := 'B7: ' state.wButtonsMap.b7
      this.guide.Text := 'Guide: ' state.wButtonsMap.guide

      this.lt.Text := 'LT: ' state.bLeftTrigger
      this.rt.Text := 'RT: ' state.bRightTrigger
      this.lsx.Text := 'LS X: ' state.sThumbLX
      this.lsy.Text := 'LS Y: ' state.sThumbLY
      this.rsx.Text := 'RS X: ' state.sThumbRX
      this.rsy.Text := 'RS Y: ' state.sThumbRY
    }
  }

  show() {
    w := 500
    h := 1080
    x := A_ScreenWidth - w - 10
    y := 10

    super.show("x" x " y" y " w" w " h" h " NoActivate")
  }
}