
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
; ------------------------------


Local Const _
  $csURL  = 'https://www.infomed.ck.ua/download', _   ;
  $csName = '̲� �����������'
  $sBotKey = 'botXXXXXXXXXXXXXXXXXXXXXXX' 
  $nChatId = 'XXXXXXXXXX'
  ;$nChatId2 = ''
  ;$nChatId3 = ''

;
Local _
  $sHTML, $sVersion, $sMsg,           _ ; ����� ��������, ������, �����. � ����������
  $i, $iRC = 0                          ; ��� ��������
;
$sHTML = InetRead($csURL)                   ; ������ ��������
$sHTML = BinaryToString($sHTML, $SB_UTF8)   ; ������. � �����
$sVersion = i_ParseVer($sHTML, $csName)     ; �������� ������
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
 $csNameXML = 'full_version' ; ��� ���������, �������� �-���� ���� ���������� �� ������
 Local _
  $sXML, $sVersion, $sMsg,            _ ; ����� ��������, ������, �����. � ����������
  $i, $iRC = 0                          ; ��� ��������
;
$sXML = InetRead($csURLxml)                   ; ������ ��������
$sXML = BinaryToString($sXML, $SB_ANSI)    ; ������. � �����, � � ������ ������ ��������� = ANSI
$sVersion = i_ParseVerXML($sXML, $csNameXML)     ; �������� ������
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
   $sText = _URIEncode('������. ���� �������� ���������. ����� ������: ' & $sVersion )
   ConsoleWrite(InetRead('https://api.telegram.org/' & $sBotKey & '/sendMessage?chat_id=' & $nChatId & '&text=' & $sText,  0))
  ;ConsoleWrite(InetRead('https://api.telegram.org/' & $sBotKey & '/sendMessage?chat_id=' & $nChatId2 & '&text=' & $sText,  0))
  ;ConsoleWrite(InetRead('https://api.telegram.org/' & $sBotKey & '/sendMessage?chat_id=' & $nChatId3 & '&text=' & $sText,  0))
EndIf
 ;}

;=============================================================
; ������� ������� �����
Func i_ParseVer(ByRef Const $psSource, ByRef Const $psName)
  Local Const _
    $csRExp = '(?isU)<a href="[^"]+">\s+�' & $psName & _
              '�.+�����:\s*(?-U)(\d+(?:\.\d+)+)'
  Local $vRes
  $vRes = StringRegExp($psSource, $csRExp, $STR_REGEXPARRAYMATCH)
  If Not @error Then Return $vRes[0]
  Return SetError(1, 0, Null)
EndFunc

; ������� XML �������
Func i_ParseVerXML(ByRef Const $psSource, _  ; ����������� �����, ������� ������ �� ������
                ByRef Const $psName)      ; ��� �������� ���������
  Local Const _
    $csRExp = '(?isU)<product .+' & $psName & _
              '\s*=\s*"(?-U)(\d+(?:\.\d+)+)"'
  Local $vRes
  $vRes = StringRegExp($psSource, $csRExp, $STR_REGEXPARRAYMATCH)
  If Not @error Then Return $vRes[0]
  Return SetError(1, 0, Null)
EndFunc

; ��� �������
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