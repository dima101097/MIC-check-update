#comments-start
Переменные
mINI - Файл INI с конфигурацией для данных MIC
mURL - адрес сайта мед инфо сервис
mName - имя структуры для моиска
mHTML - Переменная с данными страницы mURL
mVersion - версия MIC
mRExp - локальное регулятное выражение HTML
$mVer - локальная версия HTML
mURLxml - адрес к XML файлу
mNameXML - параметру данные которого нужно получить
mXML Переменная с данными страницы mNameXML
mVersINI -
mCurentVer -

tINI - Файл INI с конфигурацией для данных Telegram
tKey - Telegram BOT key
tChat - Chat ID
tText - Текст приветствие
tTextCur - Текст перед установленной версией
tTextNew - Текст передновой версией

$cWeekday - параметр с номером дня недели, 1 - Воскресение .. 7 - Суботта
#comments-end

#NoTrayIcon
#pragma compile(Out, MIC UPDATE.exe)
#pragma compile(Icon, image/ico.ico)
#pragma compile(UPX, True)
#pragma compile(FileDescription, 'Software ZHOKL')
#pragma compile(FileVersion, 2.0)
FileChangeDir(@ScriptDir)

#include "./src/Telegram.au3"
#include <Date.au3>
;
If WinExists (@ScriptName) Then  Exit
AutoItWinSetTitle (@ScriptName)
;
$cWeekday = _DateToDayOfWeek (@YEAR, @MON, @MDAY)
if $cWeekday = 1 or $cWeekday = 7 Then Exit
main()
Global $mINI = @WorkingDir &'\ini\mic.ini'
Global $tINI = @WorkingDir &'\ini\telegram.ini'

 if ((FileOpen ( $mINI ) = -1) or (FileOpen ( $tINI ) = -1))  Then MsgBox (0,"Ошибка","Отсутствуют файлы конфигурации. " & @CRLF & 'Запустите "Config.exe" и проведите настройку.')

Func main()
$mINI = @WorkingDir &'\ini\mic.ini'
$mURL = IniRead ($mINI, "MIC", "URL", "Укажите ссылку на страницу загрузки.")
$mName = IniRead ($mINI, "MIC", "NAME", "Укажите данные для поиска.")
$mURLxml = IniRead ($mINI, "MIC", "URL_XML", "Укажите адрес XML файла.")
$mNameXML = IniRead ($mINI, "MIC", "NAME_XML", "Укажите параметр данные которого нужно получить.")
$mVersINI = IniRead ($mINI, "MIC", "VERSION_INI", "Укажите путь в ini файлу с версией MIC.")
$mCurentVer= IniRead ($mVersINI,"releases","current","")

$tINI = @WorkingDir &'\ini\telegram.ini'
$tKey = IniRead ($tINI, "TELEGRAM", "KEY", "Укажите API ключ бота.")
$tChat = IniRead ($tINI, "TELEGRAM", "CHAT", "Укажите CHAT ID.")
$tText = IniRead ($tINI, "TELEGRAM", "TEXT", "Текст бота (приветствие)")
$tTextCur = IniRead ($tINI, "TELEGRAM", "TEXT_VER_CUR", "Текст бота перед текущей версией")
$tTextNew= IniRead ($tINI, "TELEGRAM", "TEXT_VER_NEW", "Текст бота перед новой версией")
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
    $mRExp = '(?isU)<a href="[^"]+">\s+„' & $mName & '“.+Версія:\s*(?-U)(\d+(?:\.\d+)+)'
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