; Courtesy of Lexikos from https://www.autohotkey.com/boards/viewtopic.php?t=106254
#DllLoad XInput1_4.dll
XInputState(UserIndex) {
  xiState := Buffer(16)
  if err := DllCall("XInput1_4\XInputGetState", "uint", UserIndex, "ptr", xiState) {
    if err = 1167 ; ERROR_DEVICE_NOT_CONNECTED
      return 0
    throw OSError(err, -1)
  }
  wButtons := NumGet(xiState,  4, "UShort")
  XInputButtonsMap.update(wButtons)
  return {
    dwPacketNumber:  NumGet(xiState,  0, "UInt"),
    wButtons:        wButtons,
    wButtonsMap:     XInputButtonsMap,
    bLeftTrigger:    NumGet(xiState,  6, "UChar"),
    bRightTrigger:   NumGet(xiState,  7, "UChar"),
    sThumbLX:        NumGet(xiState,  8, "Short"),
    sThumbLY:        NumGet(xiState, 10, "Short"),
    sThumbRX:        NumGet(xiState, 12, "Short"),
    sThumbRY:        NumGet(xiState, 14, "Short"),
  }
}

; My own personal extension for ease-of-use
class XInputButtonsMap {
  static propsArray := [ 'a', 'b', 'x', 'y', 'lb', 'rb', 'b6', 'b7', 'back', 'menu', 'ls', 'rs', 'up', 'down', 'left', 'right', 'guide' ]

  static new() {
    throw
  }

  static __new() {
    for _i, v in this.propsArray {
      this.defineprop(v, {
        value: false
      })
    }
  }

  ; id comes from how gamepad-tester and other web-based tools map the Guide button
  ; some sources say the Guide button is not exposed as part of XInput
  ; other sources say the Guide button is at offset 0x0400 (1024), but that doesn't seem to work with AHKv2
  static update(btnStateBinString) { ;  decimal:    id  (name):             ; 16-bit binary:
    this.a     := (btnStateBinString &  4096 > 0) ; B0  (A)                 ; 0b0001000000000000
    this.b     := (btnStateBinString &  8192 > 0) ; B1  (B)                 ; 0b0010000000000000
    this.x     := (btnStateBinString & 16384 > 0) ; B2  (X)                 ; 0b0100000000000000
    this.y     := (btnStateBinString & 32768 > 0) ; B3  (Y)                 ; 0b1000000000000000
    this.lb    := (btnStateBinString &   256 > 0) ; B4  (Left Bumper)       ; 0b0000000100000000
    this.rb    := (btnStateBinString &   512 > 0) ; B5  (Right Bumper)      ; 0b0000001000000000
    this.back  := (btnStateBinString &    32 > 0) ; B8  (Back)              ; 0b0000000000100000
    this.menu  := (btnStateBinString &    16 > 0) ; B9  (Menu)              ; 0b0000000000010000
    this.ls    := (btnStateBinString &    64 > 0) ; B10 (Left Stick Click)  ; 0b0000000001000000
    this.rs    := (btnStateBinString &   128 > 0) ; B11 (Right Stick Click) ; 0b0000000010000000
    this.up    := (btnStateBinString &     1 > 0) ; B12 (D-Pad Up)          ; 0b0000000000000001
    this.down  := (btnStateBinString &     2 > 0) ; B13 (D-Pad Down)        ; 0b0000000000000010
    this.left  := (btnStateBinString &     4 > 0) ; B14 (D-Pad Left)        ; 0b0000000000000100
    this.right := (btnStateBinString &     8 > 0) ; B15 (D-Pad Right)       ; 0b0000000000001000

    ; these two show up in gamepad-tester.com but do not "light up" when any button is pressed:
    this.b6    := false                           ; B6  (Unknown)           ; 0b????????????????
    this.b7    := false                           ; B7  (Unknown)           ; 0b????????????????

    ; this is apparently not included in XInput, but the web gamepad API seems to see it just fine
    this.guide := false                           ; B16 (Unknown)           ; 0b????????????????
  }

  static allPressed() {
    pressed := []

    for i, v in this.propsArray {
      if (this.GetOwnPropDesc(v).value > 0) {
        pressed.push(v)
      }
    }

    return pressed
  }

  static onlyPressed(name) {
    all := this.allPressed()

    return all.length = 1 and all[1] = name
  }

  static formatStringForIndex(arr, i) {
    if (i < arr.length) {
      return '"{1}": {2}, '
    } else {
      return '"{1}": {2}'
    }
  }

  static ToJSON() {
    jsonFormattedOutput := '{ '

    for i, v in this.propsArray {
      jsonFormattedOutput .= Format(this.formatStringForIndex(this.propsArray, i), v, this.GetOwnPropDesc(v).Value)
    }

    return jsonFormattedOutput . ' }'
  }
}