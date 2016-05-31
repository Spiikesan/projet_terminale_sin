#cs ----------------------------------------------------------------------------

 AutoIt Version : 3.3.8.1
 Auteur:         MonNom

 Fonction du Script :
	Modèle de Script AutoIt.

#ce ----------------------------------------------------------------------------


Global $h_Context = ObjCreate("SAPI.SpInProcRecoContext")
Global $h_Recognizer = $h_Context.Recognizer
Global $h_Grammar = $h_Context.CreateGrammar(1)
$h_Grammar.Dictationload
$h_Grammar.DictationSetState(1)

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

While $i_ObjInitialized
    Sleep(5000)
    ;Allow the Audio In to finalize processing on the last 5 second capture
    $h_Context.Pause
    ;Resume audio in processing
    $h_Context.Resume
    ;Reset event function allocation (what is this? I think its garbage collection or something, needs clarification)
    $h_ObjectEvents = ObjEvent($h_Context, "SpRecEvent_")
WEnd

Func SpRecEvent_Hypothesis($StreamNumber, $StreamPosition, $Result)
    ConsoleWrite("Hypothesis(): Hypothized text is: " & $Result.PhraseInfo.GetText & @CRLF)
EndFunc ;==>SpRecEvent_Hypothesis

Func SpRecEvent_Recognition($StreamNumber, $StreamPosition, $RecognitionType, $Result)
    ConsoleWrite($RecognitionType & "||" & $Result.PhraseInfo.GetText & @CRLF)
EndFunc ;==>SpRecEvent_Recognition

Func SpRecEvent_SoundStart($StreamNumber, $StreamPosition)
    ConsoleWrite("Sound Started" & @CRLF)
EndFunc ;==>SpRecEvent_SoundStart

Func SpRecEvent_SoundEnd($StreamNumber, $StreamPosition)
    ConsoleWrite("Sound Ended" & @CRLF)
EndFunc ;==>SpRecEvent_SoundEnd