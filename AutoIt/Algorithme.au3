#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=3
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Language=1036
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include "Reco Vocale Asc.au3"
#include "ascenseur_virtuel_fenetre.au3"
#include 'CommMG.au3'
#include <GuiComboBox.au3>
#cs
FileInstall(".\res\Cabine_Lumiere_Off.bmp", "res\Cabine_Lumiere_Off.bmp")
FileInstall(".\res\Cabine_Lumiere_On.bmp", "res\Cabine_Lumiere_On.bmp")
FileInstall(".\res\Led_Green_Off.bmp", "res\Led_Green_Off.bmp")
FileInstall(".\res\Led_Green_On.bmp", "res\Led_Green_On.bmp")
FileInstall(".\res\Led_Red_Off.bmp", "res\Led_Red_Off.bmp")
FileInstall(".\res\Led_Red_On.bmp", "res\Led_Red_On.bmp")
#ce
$UseCom = 1

$setflow = 2
Dim $FlowType[3] = ["XOnXoff", "Hardware (RTS, CTS)", "NONE"]
$result = ''
if setport(0) = -1 Then $UseCom = 0



Func SetPort($mode = 1);if $mode = 1 then returns -1 if settings not made

    Opt("GUIOnEventMode", 0);keep events for $Form2, use GuiGetMsg for $Form3

    #Region ### START Koda GUI section ### Form=d:\my documents\miscdelphi\commg\examplecommsetport.kxf
    $Form3 = GUICreate("COMMG Example - set Port", 422, 279, 329, 268, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_GROUP, $WS_BORDER, $WS_CLIPSIBLINGS, $DS_MODALFRAME), BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
    $Group1 = GUICtrlCreateGroup("Set COM Port", 18, 8, 288, 252)
    $CmboPortsAvailable = GUICtrlCreateCombo("", 127, 28, 145, 25)
    $CmBoBaud = GUICtrlCreateCombo("9600", 127, 66, 145, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL, $CBS_SORT, $WS_VSCROLL))
    GUICtrlSetData(-1, "10400|110|115200|1200|128000|14400|150|15625|1800|19200|2000|2400|256000|28800|3600|38400|4800|50|56000|57600|600|7200|75")
    $CmBoStop = GUICtrlCreateCombo("1", 127, 141, 145, 25)
    GUICtrlSetData(-1, "1|2|1.5")
    $CmBoParity = GUICtrlCreateCombo("none", 127, 178, 145, 25)
    GUICtrlSetData(-1, "odd|even|none")
    $Label2 = GUICtrlCreateLabel("Port", 94, 32, 23, 17)
    $Label3 = GUICtrlCreateLabel("baud", 89, 70, 28, 17)
    $Label4 = GUICtrlCreateLabel("No. Stop bits", 52, 145, 65, 17)
    $Label5 = GUICtrlCreateLabel("parity", 88, 182, 29, 17)
    $CmboDataBits = GUICtrlCreateCombo("8", 127, 103, 145, 25)
    GUICtrlSetData(-1, "7|8")
    $Label7 = GUICtrlCreateLabel("No. of Data Bits", 38, 107, 79, 17)
    $ComboFlow = GUICtrlCreateCombo("NONE", 127, 216, 145, 25)
    GUICtrlSetData(-1, "NONE|XOnXOff|Hardware (RTS, CTS)")
    $Label1 = GUICtrlCreateLabel("flow control", 59, 220, 58, 17)
    GUICtrlCreateGroup("", -99, -99, 1, 1)
    $BtnApply = GUICtrlCreateButton("Apply", 315, 95, 75, 35, $BS_FLAT)
    GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
    $BtnCancel = GUICtrlCreateButton("Cancel", 316, 147, 76, 35, $BS_FLAT)
    GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
    GUISetState(@SW_SHOW)
    #EndRegion ### END Koda GUI section ###

    $portlist = _CommListPorts(0);find the available COM ports and write them into the ports combo
    If @error = 1 Then
        MsgBox(0, 'trouble getting portlist', 'Program will terminate!')
        Exit
    EndIf


    For $pl = 1 To $portlist[0]
        GUICtrlSetData($CmboPortsAvailable, $portlist[$pl]);_CommListPorts())
    Next
    GUICtrlSetData($CmboPortsAvailable, $portlist[1]);show the first port found
    GUICtrlSetData($ComboFlow, $FlowType[$setflow])
    _GUICtrlComboBox_SetMinVisible($CmBoBaud, 10);restrict the length of the drop-down list

    $retval = 0

    While 1
        $msg = GUIGetMsg()
        If $msg = $BtnCancel Then
            If Not $mode Then $retval = -1
            ExitLoop
        EndIf



            Local $sportSetError
            $comboflowsel = GUICtrlRead($ComboFlow)
            For $n = 0 To 2
                If $comboflowsel = $FlowType[$n] Then
                    $setflow = $n
                    ConsoleWrite("flow = " & $setflow & @CRLF)
                    ExitLoop
                EndIf

            Next
            $setport = StringReplace(GUICtrlRead($CmboPortsAvailable), 'COM', '')
            _CommSetPort($setport, $sportSetError, GUICtrlRead($CmBoBaud), GUICtrlRead($CmboDataBits), GUICtrlRead($CmBoParity), GUICtrlRead($CmBoStop), $setflow)
            if $sportSetError = '' Then
            MsgBox(262144, 'Connected ','to COM' & $setport)
            Else
            MsgBox(262144, 'Setport error = ', $sportSetError)
            EndIf
            $mode = 1;
            ExitLoop



    WEnd
    GUIDelete($Form3)
    Return $retval


EndFunc   ;==>SetPort
#cs ======================================
	PAR SPIIKESAN© ELEVE DE TERMINALE SIN
	LANGAGE : AUTOIT V3
	RAISONS : SIMPLICITEE D'UTILISATION
	-- LA CONVERSION AUTOIT - LANGAGE C N'EST PAS TRES COMPLIQUEE --
	======================================
	ECRIRE L'ALGORITHME DE PILOTAGE
	DANS LA SUITE DE CE DOCUMENT
	AFIN DE SIMULER LE PILOTAGE DE
	L'ASCENSEUR. LES VARIABLES SONT DEJA
	DECLAREES. LES FONCTIONS NE SONT PAS
	FAITES. CERTAINES VARIABLE D'ENTREE
	ET DE SORTIES DEVRONT ETRE FAITES
	AUTREMENT. VOICI LA LISTE EXHAUSTIVE
	DES VARIABLES INUTILISABLES:
	- TOUTES LES FERMETURE_PORTE
	- TOUTES LES OUVERTURE_PORTE
	- TOUTES LES MOTEUR_OUVERTURE
	- TOUTES LES MOTEUR_FERMETURE
	D'AUTRES MOYENS SERONT UTILISES,
	NOTAMENT CERTAINES FONCTIONS AVEC
	LE MEME NOM AFIN DE SIMULER AU MIEUX
	L'UTILISATION DE CES VARIABLES
	(ajouter "(n°etage)" à la fin).
	- MOTEUR_MONTEE()
	- MOTEUR_DESCENTE()
	// DE LA CABINE //
	etc...

#ce ======================================
Global $OPENNED_TIME = 5
Global $LIGHT_TIME = 3
Global $stopped = 0
Global $stopStrob = 0
Global $COUNT_WAIT_OPEN = 0
Global $TIME_EC = 0
Global $FILE_ATTENTE[8]
Global $DOOR_ALREADY = 0
Global Enum $HAUT, $BAS
Global $direction = $HAUT
Global $etageSuivant = ""
Global $ok = 0
$obsState = 0

GUICtrlSetImage($CABINE_ETAGE_00,"res\Led_Red_On.bmp")
GUICtrlSetImage($CABINE_ETAGE_0,"res\Led_Red_On.bmp")

Func _Commande($type)
If $type = "stop" Then
	if $stopped Then
		$stopped = 0
	Else
		$stopped = 1
	EndIf
	If $UseCom Then _CommSendstring('s')
EndIf

EndFunc

While 1
    $h_ObjectEvents = ObjEvent($h_Context, "SpRecEvent_")
 $nMsg = GUIGetMsg()
 If $etageSuivant <> $FILE_ATTENTE[0] Then
	$etageSuivant = $FILE_ATTENTE[0]
	GUICtrlSetData($Etage_Suivant,"Suivant : "&$etageSuivant-1)
	If $etageSuivant = "" Then GUICtrlSetData($Etage_Suivant,"Suivant : Aucun")
EndIf
		If $obsState <> OBSTACLE_FERMETURE() Then
			$obsState = OBSTACLE_FERMETURE()
			If $UseCom Then _CommSendstring('o')
		EndIf
If Not $stopped Then
	 Switch $nMsg
	;~ 	 ==========================
		Case $GUI_EVENT_CLOSE
			Exit
	;~ 	 ==========================
		Case $STOP
			$stopped = 1
			If $UseCom Then _CommSendstring('s')
		Case $ENVOI_0
			_Add_File_Dattente(1)
		Case $ENVOI_1
			_Add_File_Dattente(2)
		Case $ENVOI_2
			_Add_File_Dattente(3)
		Case $ENVOI_3
			_Add_File_Dattente(4)

		Case $APPEL_DESCENTE_3
			_Add_File_Dattente(4)
			GUICtrlSetImage($VOYANT_DESCENTE_3,"res\Led_Green_On.bmp")
		Case $APPEL_MONTEE_2
			_Add_File_Dattente(30)
		Case $APPEL_DESCENTE_2
			_Add_File_Dattente(31)
		Case $APPEL_MONTEE_1
			_Add_File_Dattente(20)
		Case $APPEL_DESCENTE_1
			_Add_File_Dattente(21)
		Case $APPEL_MONTEE_0
			_Add_File_Dattente(1)
			GUICtrlSetImage($VOYANT_MONTEE_0,"res\Led_Green_On.bmp")

		EndSwitch
		_Executer_File_Dattente()

	Else
		If $nMsg = $STOP Then
			If $UseCom Then _CommSendstring('s')
			$stopped = 0
			GUICtrlSetImage($CABINE_ETAGE_00,"res\Led_Red_Off.bmp")
			GUICtrlSetImage($CABINE_ETAGE_01,"res\Led_Red_Off.bmp")
			GUICtrlSetImage($CABINE_ETAGE_02,"res\Led_Red_Off.bmp")
			GUICtrlSetImage($CABINE_ETAGE_03,"res\Led_Red_Off.bmp")
			GUICtrlSetImage($CABINE_ETAGE_0,"res\Led_Red_Off.bmp")
			GUICtrlSetImage($CABINE_ETAGE_1,"res\Led_Red_Off.bmp")
			GUICtrlSetImage($CABINE_ETAGE_2,"res\Led_Red_Off.bmp")
			GUICtrlSetImage($CABINE_ETAGE_3,"res\Led_Red_Off.bmp")
		EndIf
;~ 		===========================================
		If $nMsg = $GUI_EVENT_CLOSE Then Exit
;~ 		===========================================
		$stopStrob += 1
		Sleep(1)
		If $stopStrob = 20 Then
			GUICtrlSetImage($CABINE_ETAGE_00,"res\Led_Red_On.bmp")
			GUICtrlSetImage($CABINE_ETAGE_01,"res\Led_Red_On.bmp")
			GUICtrlSetImage($CABINE_ETAGE_02,"res\Led_Red_On.bmp")
			GUICtrlSetImage($CABINE_ETAGE_03,"res\Led_Red_On.bmp")
			GUICtrlSetImage($CABINE_ETAGE_0,"res\Led_Red_On.bmp")
			GUICtrlSetImage($CABINE_ETAGE_1,"res\Led_Red_On.bmp")
			GUICtrlSetImage($CABINE_ETAGE_2,"res\Led_Red_On.bmp")
			GUICtrlSetImage($CABINE_ETAGE_3,"res\Led_Red_On.bmp")
		ElseIf $stopStrob = 40 Then
			GUICtrlSetImage($CABINE_ETAGE_00,"res\Led_Red_Off.bmp")
			GUICtrlSetImage($CABINE_ETAGE_01,"res\Led_Red_Off.bmp")
			GUICtrlSetImage($CABINE_ETAGE_02,"res\Led_Red_Off.bmp")
			GUICtrlSetImage($CABINE_ETAGE_03,"res\Led_Red_Off.bmp")
			GUICtrlSetImage($CABINE_ETAGE_0,"res\Led_Red_Off.bmp")
			GUICtrlSetImage($CABINE_ETAGE_1,"res\Led_Red_Off.bmp")
			GUICtrlSetImage($CABINE_ETAGE_2,"res\Led_Red_Off.bmp")
			GUICtrlSetImage($CABINE_ETAGE_3,"res\Led_Red_Off.bmp")
			$stopStrob = 0
		EndIf
	EndIf
WEnd

Func _Add_File_Dattente($quel) ;$quel = 1-4(=etage+1) : 2-3(=etage+1)&0/1(=montée/descente)
	Local $n = 0
	;On vérifie que l'appel n'est pas déjà fait
	Local $dejaPresent = 0

	For $n=0 to 7
		If $FILE_ATTENTE[$n] = $quel Then $dejaPresent = 1
	Next

	If Not $dejaPresent Then
		$n = 0
		While $FILE_ATTENTE[$n] <> ""
			If $n=7 Then
				ExitLoop
			EndIf
			$n+=1
		WEnd
		$FILE_ATTENTE[$n] = $quel
		Switch $quel
			Case 20
				GUICtrlSetImage($VOYANT_MONTEE_1,"res\Led_Green_On.bmp")
			Case 30
				GUICtrlSetImage($VOYANT_MONTEE_2,"res\Led_Green_On.bmp")
			Case 21
				GUICtrlSetImage($VOYANT_DESCENTE_1,"res\Led_Green_On.bmp")
			Case 31
				GUICtrlSetImage($VOYANT_DESCENTE_2,"res\Led_Green_On.bmp")
		EndSwitch
		$voice.Speak("demande, enregistrée", 11)
		_Arranger_File_Dattente("arranger")
	EndIf
EndFunc

Func _Executer_File_Dattente()
	If $FILE_ATTENTE[0] <> "" Then
		ECLAIRAGE_CABINE(1)
		$TIME_EC=0

		Switch $FILE_ATTENTE[0]
			Case 1
				If $UseCom Then
					If Not $ok Then _CommSendstring("e1")
					$ok = 1
				EndIf
				If _go_etage(1) Then
					_Arranger_File_Dattente("suivant")
					$direction = $HAUT
					GUICtrlSetData($Direction_Inf,"Direction : HAUT")
					$ok = 0
				EndIf

			Case 2
				If $UseCom Then
					If Not $ok Then _CommSendstring("e2")
					$ok = 1
				EndIf
				If _go_etage(2) Then
					_Arranger_File_Dattente("suivant")
					$ok = 0
				EndIf

			Case 3
				If $UseCom Then
					If Not $ok Then _CommSendstring("e3")
					$ok = 1
				EndIf
				If _go_etage(3) Then
					_Arranger_File_Dattente("suivant")
					$ok = 0
				EndIf

			Case 4
				If _go_etage(4) Then
					_Arranger_File_Dattente("suivant")
					$direction = $BAS
					GUICtrlSetData($Direction_Inf,"Direction :  BAS")
				EndIf

			Case 20 ;MONTEE 1
				If $UseCom Then
					If Not $ok Then _CommSendstring("e2")
					$ok = 1
				EndIf
				If _go_etage(2) Then
					_Arranger_File_Dattente("suivant")
					$ok = 0
				EndIf

			Case 30 ;MONTEE 2
				If $UseCom Then
					If Not $ok Then _CommSendstring("e3")
					$ok = 1
				EndIf
				If _go_etage(3) Then
					_Arranger_File_Dattente("suivant")
					$ok = 0
				EndIf

			Case 21 ;DESCENTE 1
				If $UseCom Then
					If Not $ok Then _CommSendstring("e2")
					$ok = 1
				EndIf
				If _go_etage(2) Then
					_Arranger_File_Dattente("suivant")
					$ok = 0
				EndIf

			Case 31 ;DESCENTE 2
				If $UseCom Then
					If Not $ok Then _CommSendstring("e3")
					$ok = 1
				EndIf
				If _go_etage(3) Then
					_Arranger_File_Dattente("suivant")
					$ok = 0
				EndIf

		EndSwitch

	Else
		If $TIME_EC < $LIGHT_TIME*1000 Then
			$TIME_EC+=1
		Else
			ECLAIRAGE_CABINE(0)
		EndIf
	EndIf
EndFunc

Func _go_etage($etage)
	If CABINE_ETAGE() > $etage-1 Then
		MOTEUR_DESCENTE()
		$direction = $BAS
		GUICtrlSetData($Direction_Inf,"Direction : BAS")

	ElseIf CABINE_ETAGE() < $etage-1 Then
		MOTEUR_MONTEE()
		$direction = $HAUT
		GUICtrlSetData($Direction_Inf,"Direction : HAUT")

	ElseIf CABINE_ETAGE() = $etage-1 And $DOOR_ALREADY = 0 Then
		Switch $etage
			Case 1
				GUICtrlSetImage($VOYANT_MONTEE_0,"res\Led_Green_Off.bmp")
			Case 2
				GUICtrlSetImage($VOYANT_MONTEE_1,"res\Led_Green_Off.bmp")
				GUICtrlSetImage($VOYANT_DESCENTE_1,"res\Led_Green_Off.bmp")
			Case 3
				GUICtrlSetImage($VOYANT_MONTEE_2,"res\Led_Green_Off.bmp")
				GUICtrlSetImage($VOYANT_DESCENTE_2,"res\Led_Green_Off.bmp")
			Case 4
				GUICtrlSetImage($VOYANT_DESCENTE_3,"res\Led_Green_Off.bmp")
		EndSwitch
		If $etage > 1 Then
			$voice.Speak("Etage, "&$etage-1, 11)
		Else
			$voice.Speak("rez-de-chaussée.", 11)
		EndIf
		$DOOR_ALREADY = 1

	ElseIf $DOOR_ALREADY = 1 Then
		If Not OUVERTURE_PORTE_($etage-1) Then
			MOTEUR_OUVERTURE_($etage-1)
		Else
			$DOOR_ALREADY = 2

		EndIf

	ElseIf $DOOR_ALREADY = 2 Then
		If  $COUNT_WAIT_OPEN < $OPENNED_TIME*10 Then
			$COUNT_WAIT_OPEN += 1
		Else
			$voice.Speak("Attention, à la fermeture des portes.", 11)
			Sleep(2500)
			Beep(800)
			$COUNT_WAIT_OPEN = 0
			$DOOR_ALREADY = 3
		EndIf

	ElseIf $DOOR_ALREADY = 3 Then
		If Not FERMETURE_PORTE_($etage-1) Then
			If Not OBSTACLE_FERMETURE() Then MOTEUR_FERMETURE_($etage-1)
		Else

			$DOOR_ALREADY = 0
			Return 1
		EndIf
	EndIf
EndFunc

Func _Arranger_File_Dattente($action)
	Local $n = 0

		While $FILE_ATTENTE[$n] <> ""
			If $n=7 Then
				ExitLoop
			EndIf
			$n+=1
		WEnd

	If $action = "suivant" Then

		$FILE_ATTENTE[0] = ""

		For $i = $n To 7
			$FILE_ATTENTE[$i] = ""
		Next

		For $i = 0 To $n-1
			$next = $FILE_ATTENTE[$i+1]
			$FILE_ATTENTE[$i] = $next
		Next

		$FILE_ATTENTE[$n] = ""
	;EndIf
;#cs
	ElseIf $action = "arranger" Then
		Local $FILE_ATTENTE_TEMPORAIRE = $FILE_ATTENTE
		Local $max = -1
		Local $min = 999
		If $direction = $HAUT Then
			For $p = 0 To $n-2 ;On remplis chaque ligne
				For $p_temp = 0 To $n-2 ;On cherche la valeur la plus basse
					If $FILE_ATTENTE_TEMPORAIRE[$p_temp] < $min Then
						$min = $FILE_ATTENTE_TEMPORAIRE[$p_temp]
					EndIf
				Next
				For $p_temp = 0 To $n-2 ;On Supprime la valeur la plus basse
					If $FILE_ATTENTE_TEMPORAIRE[$p_temp] = $min Then
						$FILE_ATTENTE_TEMPORAIRE[$p_temp] = 999
					EndIf
				Next
				$FILE_ATTENTE[$p] = $min
				$min = 999
			Next

		ElseIf $direction = $BAS Then
			For $p = 0 To $n-1 ;On remplis chaque ligne

				For $p_temp = 0 To $n-1 ;On cherche la valeur la plus élevée
					If $FILE_ATTENTE_TEMPORAIRE[$p_temp] > $max Then
						$max = $FILE_ATTENTE_TEMPORAIRE[$p_temp]
					EndIf
				Next
				For $p_temp = 0 To $n-1 ;On Supprime la valeur la plus élevée
					If $FILE_ATTENTE_TEMPORAIRE[$p_temp] = $max Then
						$FILE_ATTENTE_TEMPORAIRE[$p_temp] = -1
					EndIf
				Next
				$FILE_ATTENTE[$p] = $max
				$max = -1
			Next
		EndIf
	EndIf

	$FILE_ATTENTE_TEMPORAIRE=""

EndFunc



