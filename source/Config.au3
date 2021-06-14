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

Переменные графики
gLeft
gHeight
#comments-end

#include <GUIConstants.au3>
#include "./src/Telegram.au3"


Global $tINI = @WorkingDir &'\ini\telegram.ini'
Global $mINI = @WorkingDir &'\ini\mic.ini'
 if ((FileOpen ( $mINI ) = -1) or (FileOpen ( $tINI ) = -1))  Then _defaultConfig ()
$gLeft = 10
$gHeight = 10

$tKey = IniRead ($tINI, "TELEGRAM", "KEY", "")
$tChat = IniRead ($tINI, "TELEGRAM", "CHAT", "")
$text = IniRead ($tINI, "TELEGRAM", "TEXT", "")
$textCurent = IniRead ($tINI, "TELEGRAM", "TEXT_VER_CUR", "")
$textNew = IniRead ($tINI, "TELEGRAM", "TEXT_VER_NEW", "")

$urlD = IniRead ($mINI, "MIC", "URL", "")
$fName = IniRead ($mINI, "MIC", "NAME", "")
$fURL_XML = IniRead ($mINI, "MIC", "URL_XML", "")
$fXML = IniRead ($mINI, "MIC", "NAME_XML", "")
$iFolder = IniRead ($mINI, "MIC", "VERSION_INI", "")





   GUICreate( "Settings", 400, 384 )
   ;Token
   GUICtrlCreateLabel ("Телеграм токен:", $gLeft, $gHeight)
   $tKey = GUICtrlCreateInput ($tKey, $gLeft + 165, $gHeight, 200)
   ;ChatID
   GUICtrlCreateLabel ("Чат ID:", $gLeft, $gLeft + 30)
   $tChat = GUICtrlCreateInput ($tChat, $gLeft + 165, $gHeight + 25, 200)
  ;Text
   GUICtrlCreateLabel ("Текст приветствия:", $gLeft, $gLeft + 60)
   $text = GUICtrlCreateInput ($text, $gLeft + 165, $gHeight + 55, 200)
  ;Text Ver Cur
   GUICtrlCreateLabel ("Текст текущей версии:", $gLeft, $gLeft + 90)
   $textCurent = GUICtrlCreateInput ($textCurent, $gLeft + 165, $gHeight + 85, 200)
  ;Text Ver New
   GUICtrlCreateLabel ("Текст текущей версии:", $gLeft, $gLeft + 120)
   $textNew = GUICtrlCreateInput ($textNew, $gLeft + 165, $gHeight + 115, 200)

   ;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ;URL
   GUICtrlCreateLabel ("URL на страницу скачивания:", $gLeft, $gLeft + 150)
   $urlD = GUICtrlCreateInput ($urlD, $gLeft + 165, $gHeight + 145, 200)
   ;Name find
   GUICtrlCreateLabel ("Что искать:", $gLeft, $gLeft + 180)
   $fName = GUICtrlCreateInput ($fName, $gLeft + 165, $gHeight + 175, 200)
   ;XML_URL
   GUICtrlCreateLabel ("Ссылка к XML файлу:", $gLeft, $gLeft + 210)
   $fURL_XML = GUICtrlCreateInput ($fURL_XML, $gLeft + 165, $gHeight + 205, 200)
   ; XML_find
   GUICtrlCreateLabel ("Что искать в XML:", $gLeft, $gLeft + 240)
   $fXML = GUICtrlCreateInput ($fXML, $gLeft + 165, $gHeight + 235, 200)
   ;Ini_folder
   GUICtrlCreateLabel ("Ini файл с версией программы:", $gLeft, $gLeft + 270)
   Global $iFolders = GUICtrlCreateInput ($iFolder, $gLeft + 165, $gHeight + 265, 150)
   $folderChoose = GUICtrlCreateButton("Выбрать", $gLeft + 317, $gHeight + 264, 50, 23)
   ;end GUI
   $save = GUICtrlCreateButton("Сохранить", $gLeft, $gHeight + 324, 85, 23)
   $tMessage = GUICtrlCreateButton("Telegram Test", $gLeft + 100, $gHeight + 324, 85, 23)
  ; $doc = GUICtrlCreateButton("Документация", $gLeft + 200, $gHeight + 324, 85, 23)

GUISetState(@SW_SHOW)


Do
  $gMsg = GUIGetMsg()
   Switch $gMsg
			Case $GUI_EVENT_CLOSE
			   ExitLoop
			Case $folderChoose
			    GUICtrlSetData($iFolders, FileOpenDialog("Укажите Ini файл с текущей версией программы", @WorkingDir & "\", "Текстовые файлы (*.ini;*.txt)", 1))
			 Case $save
				_save(GUICtrlRead($tKey),GUICtrlRead($tChat),GUICtrlRead($text),GUICtrlRead($textCurent),GUICtrlRead($textNew),GUICtrlRead($urlD),GUICtrlRead($fName),GUICtrlRead($fURL_XML),GUICtrlRead($fXML),GUICtrlRead($iFolders))
			 Case $tMessage
				_InitBot(GUICtrlRead($tKey))
			   _SendMsg(GUICtrlRead($tChat), "Test Message")
			   MsgBox (0,"Тестовое сообщение", "Тестовое сообщение отправлено." & @CRLF & "Если вы не получили сообщение, проверте Токен и ID Чата.")
			;Case $doc
   EndSwitch
Until $gMsg = $GUI_EVENT_CLOSE

Func _save ($tKeyI, $tChatI, $textI, $textCurentI, $textNewI, $urlDI, $fNameI, $fURL_XMLI, $fXMLI, $iFolderI)
;Deley
   IniDelete($tINI,'TELEGRAM',"KEY")
   IniDelete($tINI,'TELEGRAM',"CHAT")
   IniDelete($tINI,'TELEGRAM',"TEXT")
   IniDelete($tINI,'TELEGRAM',"TEXT_VER_CUR")
   IniDelete($tINI,'TELEGRAM',"TEXT_VER_NEW")

   IniDelete($mINI,'MIC',"URL")
   IniDelete($mINI,'MIC',"NAME")
   IniDelete($mINI,'MIC',"URL_XML")
   IniDelete($mINI,'MIC',"NAME_XML")
   IniDelete($mINI,'MIC',"VERSION_INI")
;Write
   IniWrite ($tINI,'TELEGRAM',"KEY",$tKeyI)
   IniWrite ($tINI,'TELEGRAM',"CHAT",$tChatI)
   IniWrite ($tINI,'TELEGRAM',"TEXT",$textI)
   IniWrite ($tINI,'TELEGRAM',"TEXT_VER_CUR",$textCurentI)
   IniWrite ($tINI,'TELEGRAM',"TEXT_VER_NEW",$textNewI)

   IniWrite ($mINI,'MIC',"URL",$urlDI)
   IniWrite ($mINI,'MIC',"NAME",$fNameI)
   IniWrite ($mINI,'MIC',"URL_XML",$fURL_XMLI)
   IniWrite ($mINI,'MIC',"NAME_XML",$fXMLI)
   IniWrite ($mINI,'MIC',"VERSION_INI",$iFolderI)
   MsgBox (0, "Save", "Сохранено")

EndFunc

Func _defaultConfig()
   if (FileExists ( @WorkingDir &'\ini' ) = 0) Then DirCreate( @WorkingDir &'\ini')
   if ((FileOpen ( $mINI ) = -1) )  Then FileWrite(@WorkingDir &'\ini\mic.ini',"")
   if ((FileOpen ( $tINI ) = -1) )  Then FileWrite(@WorkingDir &'\ini\telegram.ini',"")

   IniWrite ($tINI,'TELEGRAM',"KEY","")
   IniWrite ($tINI,'TELEGRAM',"CHAT","")
   IniWrite ($tINI,'TELEGRAM',"TEXT", "Привет, пора обновится.")
   IniWrite ($tINI,'TELEGRAM',"TEXT_VER_CUR", "Установленая версия:")
   IniWrite ($tINI,'TELEGRAM',"TEXT_VER_NEW","Новая версия:")

   IniWrite ($mINI,'MIC',"URL","https://www.infomed.ck.ua/download")
   IniWrite ($mINI,'MIC',"NAME","МІС МедІнфоСервіс")
   IniWrite ($mINI,'MIC',"URL_XML","https://www.infomed.ck.ua/public/clinic/")
   IniWrite ($mINI,'MIC',"NAME_XML","full_version")
   IniWrite ($mINI,'MIC',"VERSION_INI","")

EndFunc