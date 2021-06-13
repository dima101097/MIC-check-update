#comments-start
����������
mINI - ���� INI � ������������� ��� ������ MIC
mURL - ����� ����� ��� ���� ������
mName - ��� ��������� ��� ������
mHTML - ���������� � ������� �������� mURL
mVersion - ������ MIC
mRExp - ��������� ���������� ��������� HTML
$mVer - ��������� ������ HTML
mURLxml - ����� � XML �����
mNameXML - ��������� ������ �������� ����� ��������
mXML ���������� � ������� �������� mNameXML
mVersINI -
mCurentVer -

tINI - ���� INI � ������������� ��� ������ Telegram
tKey - Telegram BOT key
tChat - Chat ID
tText - ����� �����������
tTextCur - ����� ����� ������������� �������
tTextNew - ����� ���������� �������

$cWeekday - �������� � ������� ��� ������, 1 - ����������� .. 7 - �������
#comments-end

#include "./src/Telegram.au3"
#include <Date.au3>
;
If WinExists (@ScriptName) Then  Exit
AutoItWinSetTitle (@ScriptName)
;
$cWeekday = _DateToDayOfWeek (@YEAR, @MON, @MDAY)
if $cWeekday = 1 or $cWeekday = 7 Then Exit
main()


Func main()
$mINI = @WorkingDir &'\ini\mic.ini'
$mURL = IniRead ($mINI, "MIC", "URL", "������� ������ �� �������� ��������.")
$mName = IniRead ($mINI, "MIC", "NAME", "������� ������ ��� ������.")
$mURLxml = IniRead ($mINI, "MIC", "URL_XML", "������� ����� XML �����.")
$mNameXML = IniRead ($mINI, "MIC", "NAME_XML", "������� �������� ������ �������� ����� ��������.")
$mVersINI = IniRead ($mINI, "MIC", "VERSION_INI", "������� ���� � ini ����� � ������� MIC.")
$mCurentVer= IniRead ($mVersINI,"releases","current","")

$tINI = @WorkingDir &'\ini\telegram.ini'
$tKey = IniRead ($tINI, "TELEGRAM", "KEY", "������� API ���� ����.")
$tChat = IniRead ($tINI, "TELEGRAM", "CHAT", "������� CHAT ID.")
$tText = IniRead ($tINI, "TELEGRAM", "TEXT", "����� ���� (�����������)")
$tTextCur = IniRead ($tINI, "TELEGRAM", "TEXT_VER_CUR", "����� ���� ����� ������� �������")
$tTextNew= IniRead ($tINI, "TELEGRAM", "TEXT_VER_NEW", "����� ���� ����� ����� �������")
;
$mHTML = InetRead($mURL)
$mHTML = BinaryToString($mHTML, $SB_UTF8)
$mVersion = _ParserHTML($mHTML, $mName)

$mURLxml =  $mURLxml & $mVersion & '/clinic-' & $mVersion & '.xml'
$mXML = InetRead($mURLxml)
$mXML = BinaryToString($mXML, $SB_ANSI)
$mVersion = _ParserXML($mXML, $mNameXML)
;
if $mCurentVer < $mVersion Then _telegramBot($mCurentVer, $mVersion, $tKey, $tChat, $tText, $tTextCur, $tTextNew)
;
EndFunc

Func _ParserHTML (ByRef Const $mHTML, ByRef Const $mName)
    $mRExp = '(?isU)<a href="[^"]+">\s+�' & $mName & '�.+�����:\s*(?-U)(\d+(?:\.\d+)+)'
  Local $mVer
  $mVer = StringRegExp($mHTML, $mRExp, $STR_REGEXPARRAYMATCH)
  If Not @error Then Return $mVer[0]
  Return SetError(1, 0, Null)
EndFunc

Func _ParserXML(ByRef Const $mXML, ByRef Const $mNameXML)
    $mRExp = '(?isU)<product .+' & $mNameXML & '\s*=\s*"(?-U)(\d+(?:\.\d+)+)"'
  Local $mVer
  $mVer = StringRegExp($mXML, $mRExp, $STR_REGEXPARRAYMATCH)
  If Not @error Then Return $mVer[0]
  Return SetError(1, 0, Null)
EndFunc

Func _telegramBot(ByRef Const $mCurentVer, ByRef Const $mVersion, Const $tKey, Const $tChat, Const $tText, Const $tTextCur, const $tTextNew)
_InitBot($tKey)
_SendMsg($tChat, $tText & " " & $tTextCur & " " & $mCurentVer & " | " & $tTextNew & " " & $mVersion)
EndFunc