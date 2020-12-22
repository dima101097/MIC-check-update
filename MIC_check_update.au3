
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
; ------------------------------


Local Const _
  $csURL  = 'https://www.infomed.ck.ua/download', _   ;
  $csName = 'МІС МедІнфоСервіс'
  $sBotKey = 'botXXXXXXXXXXXXXXXXXXXXXXX'
  $nChatId = 'XXXXXXXXXX'
  ;$nChatId2 = ''
  ;$nChatId3 = ''

;
Local _
  $sHTML, $sVersion, $sMsg,           _ ; текст страницы, версия, сообщ. о результате
  $i, $iRC = 0                          ; код возврата
;
$sHTML = InetRead($csURL)                   ; читаем страницу
$sHTML = BinaryToString($sHTML, $SB_UTF8)   ; преобр. в текст
$sVersion = i_ParseVer($sHTML, $csName)     ; вытянуть версию
If Not @error Then
    $sMsg =  $sVersion
    $i    = $MB_ICONINFORMATION
    $iRC  = 0
  Else
    $sMsg = 'Info not found'
    $i    = $MB_ICONSTOP
    $iRC  = 1
EndIf
;MsgBox($i, @ScriptName, $sVersion)

Local Const _
 $csURLxml  = 'https://www.infomed.ck.ua/public/clinic/'& $sVersion &'/clinic-'& $sVersion &'.xml', _   ;
 $csNameXML = 'full_version' ; имя параметра, значение к-рого надо выковырять из текста
 Local _
  $sXML, $sVersion, $sMsg,            _ ; текст страницы, версия, сообщ. о результате
  $i, $iRC = 0                          ; код возврата
;
$sXML = InetRead($csURLxml)                   ; читаем страницу
$sXML = BinaryToString($sXML, $SB_ANSI)    ; преобр. в текст, и в данном случае кодировка = ANSI
$sVersion = i_ParseVerXML($sXML, $csNameXML)     ; вытянуть версию
If Not @error Then
    $sMsg = StringFormat('Full ver=\t"%s"', $sVersion)
    $i    = $MB_ICONINFORMATION
    $iRC  = 0
  Else
    $sMsg = 'Info not found'
    $i    = $MB_ICONSTOP
    $iRC  = 1
 EndIf
; MsgBox($i, @ScriptName,  $sVersion)

 ;{
$sCurentVer = IniRead ( "E:\Clinic\Ini\release.ini","releases","current","")
;MsgBox(48, "",$sCurentVer)
if ($sCurentVer = $sVersion) Then
   Else
   $sText = _URIEncode('Привет. Пора обновить программу. Новая версия: ' & $sVersion )
   ConsoleWrite(InetRead('https://api.telegram.org/' & $sBotKey & '/sendMessage?chat_id=' & $nChatId & '&text=' & $sText,  0))
  ;ConsoleWrite(InetRead('https://api.telegram.org/' & $sBotKey & '/sendMessage?chat_id=' & $nChatId2 & '&text=' & $sText,  0))
  ;ConsoleWrite(InetRead('https://api.telegram.org/' & $sBotKey & '/sendMessage?chat_id=' & $nChatId3 & '&text=' & $sText,  0))
EndIf
 ;}

;=============================================================
; Функция парсера сайта
Func i_ParseVer(ByRef Const $psSource, ByRef Const $psName)
  Local Const _
    $csRExp = '(?isU)<a href="[^"]+">\s+„' & $psName & _
              '“.+Версія:\s*(?-U)(\d+(?:\.\d+)+)'
  Local $vRes
  $vRes = StringRegExp($psSource, $csRExp, $STR_REGEXPARRAYMATCH)
  If Not @error Then Return $vRes[0]
  Return SetError(1, 0, Null)
EndFunc

; Функция XML парсера
Func i_ParseVerXML(ByRef Const $psSource, _  ; проверяемый текст, неважно откуда он взялся
                ByRef Const $psName)      ; имя искомого параметра
  Local Const _
    $csRExp = '(?isU)<product .+' & $psName & _
              '\s*=\s*"(?-U)(\d+(?:\.\d+)+)"'
  Local $vRes
  $vRes = StringRegExp($psSource, $csRExp, $STR_REGEXPARRAYMATCH)
  If Not @error Then Return $vRes[0]
  Return SetError(1, 0, Null)
EndFunc

; Бот функция
Func _URIEncode($sData)
    Local $aData = StringSplit(BinaryToString(StringToBinary($sData,4),1),"")
    Local $nChar
    $sData=""
    For $i = 1 To $aData[0]
        $nChar = Asc($aData[$i])
        Switch $nChar
            Case 45, 46, 48 To 57, 65 To 90, 95, 97 To 122, 126
                $sData &= $aData[$i]
            Case 32
                $sData &= "+"
            Case Else
                $sData &= "%" & Hex($nChar,2)
        EndSwitch
    Next
    Return $sData
EndFunc