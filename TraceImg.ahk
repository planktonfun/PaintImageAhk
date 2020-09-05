#SingleInstance, Force
SetBatchLines, -1
SetWorkingDir %A_ScriptDir%

#Include gdip.1.45.ahk

pToken := Gdip_Startup() ;Start GDIP
pBitmap := Gdip_CreateBitmapFromFile("24.png") ;Create a bitmap from a file (jpg, png, gif ...)
Width := Gdip_GetImageWidth(pBitmap) ;Get image width
Height := Gdip_GetImageHeight(pBitmap) ;Get image height
; msgbox, %Width% %Height%


; Starting Position
x := 0
y := 0

; Offset Position
xOff := 30
yOff := 165

FileDelete, paint.ahk
FileAppend,
(
	CoordMode, Mouse, Screen`n
	Sleep, 5000 ; Wait 5 seconds put your mouse in paint window
), paint.ahk

Loop, %Width% {
	; msgbox, %x%
	Loop, %Height% {
		; msgbox, %y%
		dec := Gdip_GetPixel(pBitMap, x, y) ;Get the pixel color
		hex := SubStr(ConvertBase(10, 16, dec), 1, 6)        ; Dec to Hex
		; msgbox, %hex% %x% %y%

		if(hex = "ff0000") { ; Get all this color in hex excluding transparent
			; msgbox, found it at %x% %y%
			ex := xOff + x
			ey := yOff + y
			FileAppend,
			(
				MouseMove, %ex%, %ey%`n
				MouseClick`n
			), paint.ahk
		}
		y := y + 1
	}
	x := x + 1
	y := 0
}


ConvertBase(InputBase, OutputBase, nptr)    ; Base 2 - 36
{
    static u := A_IsUnicode ? "_wcstoui64" : "_strtoui64"
    static v := A_IsUnicode ? "_i64tow"    : "_i64toa"
    VarSetCapacity(s, 66, 0)
    value := DllCall("msvcrt.dll\" u, "Str", nptr, "UInt", 0, "UInt", InputBase, "CDECL Int64")
    DllCall("msvcrt.dll\" v, "Int64", value, "Str", s, "UInt", OutputBase, "CDECL")
    return s
}

Gdip_DisposeImage(pBitmap) ;Dispose of the image
Gdip_Shutdown(pToken) ;Shutdown GDIP

Msgbox, done