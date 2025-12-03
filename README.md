# Win+G Interceptor for Lenovo Legion Go

## Who is this For?
Owners of the Lenovo Legion Go running stock Windows 11 and Legion Space who primarily use Steam and have little to no use for the Xbox Game Bar.

## Why
Lenovo broke the Xbox Guide Button emulation in Legion Space, changing it to send Win+G instead of simulating the Xbox Guide Button. You can still use the one in the right-side Legion menu, but that's extra taps and lag.

This app, written in AHK v2 and compiled to exe with ahk2exe, hijacks Win+G and suppresses Xbox Game Bar, instead emulating the usual Xbox Guide Button interactions Steam normally provides.

## Problems
Currently I still cannot get Win+G to be intercepted by AHK when a game is running, so it doesn't trigger the Steam Overlay. You'll need to map Shift+Tab to another button/chord on your Legion controller for now in order to be able to access the overlay at a single button-press.

# Download
1.0 release: https://github.com/AdrianTP/legion-go-win-g-interceptor/releases/tag/v1.0
