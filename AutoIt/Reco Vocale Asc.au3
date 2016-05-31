#include-once

Global $sl = 0
Global $h_Context = ObjCreate("SAPI.SpInProcRecoContext")
Global $h_Recognizer = $h_Context.Recognizer
Global $h_Grammar = $h_Context.CreateGrammar(1)
;$h_Grammar.CmdLoadFromFile("Text.xml") ;Sa n'a pas l'air de marcher...
$h_Grammar.Dictationload
$h_Grammar.DictationSetState(1)
Global $voice = ObjCreate("SAPI.SpVoice")
Global $Ok = 0

;Create a token for the default audio input device and set it
Global $h_Category = ObjCreate("SAPI.SpObjectTokenCategory")
$h_Category.SetId("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech\AudioInput\TokenEnums\MMAudioIn\")
Global $h_Token = ObjCreate("SAPI.SpObjectToken")
$h_Token.SetId("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech\AudioInput\TokenEnums\MMAudioIn\")
$h_Recognizer.AudioInput = $h_Token

Global $i_ObjInitialized = 0

Global $h_ObjectEvents = ObjEvent($h_Context, "SpRecEvent_")
If @error Then
    ConsoleWrite("ObjEvent error: " & @error & @CRLF)
    $i_ObjInitialized = 0
Else
    ConsoleWrite("ObjEvent created Successfully!" & @CRLF)
    $i_ObjInitialized = 1
EndIf

Func SpRecEvent_Hypothesis($StreamNumber, $StreamPosition, $Result)
	FonctionsDiscute($Result.PhraseInfo.GetText)
EndFunc ;==>SpRecEvent_Hypothesis

Func SpRecEvent_Recognition($StreamNumber, $StreamPosition, $RecognitionType, $Result)
	FonctionsDiscute($Result.PhraseInfo.GetText)
EndFunc ;==>SpRecEvent_Recognition

Func FonctionsDiscute($Texte)
	$texte = StringLower($texte)
	If  StringRegExp($texte, "rez-de-chaussée?s?") Then
;~ 		_Add_File_Dattente(1)
	ElseIf StringRegExp($texte, "é?tages? uns?") Or StringRegExp($texte, "é?tages? 1") Or StringRegExp($texte, "premiere?s? é?tages?") Or StringRegExp($texte, "première?s? é?tages?") Then
;~ 		_Add_File_Dattente(2)
	ElseIf StringRegExp($texte, "é?tages? deu?x?") Or StringRegExp($texte, "é?tages? 2") Or StringRegExp($texte, "deuxièmes? é?tages?") Then
;~ 		_Add_File_Dattente(3)
	ElseIf StringRegExp($texte, "é?tages? trois?") Or StringRegExp($texte, "é?tages? 3") Or StringRegExp($texte, "troisièmes? é?tages?") Then
;~ 		_Add_File_Dattente(4)
;~ 	ElseIf StringRegExp($texte, "stop") Then
;~ 		_Commande("stop")
	EndIf

	If $Ok = 1 Or $Texte = "bonjour" Then
		If $Texte = "bonjour" Then
			$Ok = 1
			$voice.Speak("Bonjour.",11)
		EndIf
		Switch $Texte
			Case "sortie","sorties","sorti","au revoir"
			$voice.Speak("Au revoir",11)
			Sleep(2000)
			ConsoleWrite("Hypothesis(): Vous avez demandé la sortie du programme (" & $Texte &")"&@CRLF)
			Exit
		EndSwitch
	EndIf
	ConsoleWrite("Hypothesis(): Hypothized text is: " & $Texte & @CRLF)
EndFunc ;==>FonctionsDiscute

Func SpRecEvent_SoundStart($StreamNumber, $StreamPosition)
EndFunc ;==>SpRecEvent_SoundStart

Func SpRecEvent_SoundEnd($StreamNumber, $StreamPosition)
EndFunc ;==>SpRecEvent_SoundEnd