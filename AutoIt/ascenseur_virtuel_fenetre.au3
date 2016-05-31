#include-once
#cs ----------------------------------------------------------------------------

	AutoIt Version : 3.3.8.1
	Auteur:         MonNom

	Fonction du Script :
	Modèle de Script AutoIt.

#ce ----------------------------------------------------------------------------
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>

HotKeySet("{ESC}","_sortie")
Global $h=328,$p0=100,$p1=100,$p2=100,$p3=100,$etage=0
#Region ### START Koda GUI section ### Form= Ascenseur Virtuel
GUICreate("ASCENSEUR VIRTUEL par Spiikesan©", 615, 437, 433, 123)
GUICtrlCreateGroup("CAGE D'ASCENSEUR", 328, 0, 118, 433, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER,$WS_BORDER,$WS_CLIPSIBLINGS), $WS_EX_STATICEDGE)
Global $CABINE = GUICtrlCreatePic("res\Cabine_Lumiere_Off.bmp", 336, $h, 100, 100, BitOR($GUI_SS_DEFAULT_PIC,$SS_CENTERIMAGE))
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $APPEL_DESCENTE_3 = GUICtrlCreateButton("Descente", 8, 64, 75, 25)
Global $APPEL_MONTEE_2 = GUICtrlCreateButton("Montée", 8, 128, 75, 25)
Global $APPEL_DESCENTE_2 = GUICtrlCreateButton("Descente", 8, 168, 75, 25)
Global $APPEL_MONTEE_1 = GUICtrlCreateButton("Montée", 8, 232, 75, 25)
Global $APPEL_DESCENTE_1 = GUICtrlCreateButton("Descente", 8, 272, 75, 25)
Global $APPEL_MONTEE_0 = GUICtrlCreateButton("Montée", 8, 344, 75, 25)
GUICtrlCreateGroup("PORTES DE L'ASCENSEUR", 152, 0, 161, 433, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER,$WS_BORDER,$WS_CLIPSIBLINGS), $WS_EX_STATICEDGE)
Global $PORTE_ETAGE_0 = GUICtrlCreateProgress(160, 328, 142, 97, $PBS_SMOOTH)
GUICtrlSetData(-1, $p0)
GUICtrlSetLimit(-1, 80)
Global $PORTE_ETAGE_1 = GUICtrlCreateProgress(160, 224, 142, 97, $PBS_SMOOTH)
GUICtrlSetData(-1, $p1)
GUICtrlSetLimit(-1, 80)
Global $PORTE_ETAGE_2 = GUICtrlCreateProgress(160, 120, 142, 97, $PBS_SMOOTH)
GUICtrlSetData(-1, $p2)
GUICtrlSetLimit(-1, 80)
Global $PORTE_ETAGE_3 = GUICtrlCreateProgress(160, 16, 142, 97, $PBS_SMOOTH)
GUICtrlSetData(-1, $p3)
GUICtrlSetLimit(-1, 80)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $CABINE_ETAGE_3 = GUICtrlCreatePic("res\Led_Red_Off.bmp", 112, 40, 28, 28, BitOR($GUI_SS_DEFAULT_PIC,$SS_CENTERIMAGE,$SS_RIGHTJUST))
Global $CABINE_ETAGE_2 = GUICtrlCreatePic("res\Led_Red_Off.bmp", 112, 146, 28, 28)
Global $CABINE_ETAGE_1 = GUICtrlCreatePic("res\Led_Red_Off.bmp", 112, 250, 28, 28)
Global $CABINE_ETAGE_0 = GUICtrlCreatePic("res\Led_Red_Off.bmp", 112, 362, 28, 28)
Global $VOYANT_DESCENTE_3 = GUICtrlCreatePic("res\Led_Green_Off.bmp", 88, 66, 28, 28, BitOR($GUI_SS_DEFAULT_PIC,$SS_CENTERIMAGE,$SS_RIGHTJUST))
Global $VOYANT_MONTEE_2 = GUICtrlCreatePic("res\Led_Green_Off.bmp", 88, 122, 28, 28, BitOR($GUI_SS_DEFAULT_PIC,$SS_CENTERIMAGE,$SS_RIGHTJUST))
Global $VOYANT_DESCENTE_2 = GUICtrlCreatePic("res\Led_Green_Off.bmp", 88, 170, 28, 28, BitOR($GUI_SS_DEFAULT_PIC,$SS_CENTERIMAGE,$SS_RIGHTJUST))
Global $VOYANT_MONTEE_1 = GUICtrlCreatePic("res\Led_Green_Off.bmp", 88, 226, 28, 28, BitOR($GUI_SS_DEFAULT_PIC,$SS_CENTERIMAGE,$SS_RIGHTJUST))
Global $VOYANT_DESCENTE_1 = GUICtrlCreatePic("res\Led_Green_Off.bmp", 88, 274, 28, 28, BitOR($GUI_SS_DEFAULT_PIC,$SS_CENTERIMAGE,$SS_RIGHTJUST))
Global $VOYANT_MONTEE_0 = GUICtrlCreatePic("res\Led_Green_Off.bmp", 88, 338, 28, 28, BitOR($GUI_SS_DEFAULT_PIC,$SS_CENTERIMAGE,$SS_RIGHTJUST))
GUICtrlCreateGroup("CABINE", 456, 112, 150, 320, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER,$WS_BORDER,$WS_CLIPSIBLINGS), $WS_EX_STATICEDGE)
Global $ENVOI_0 = GUICtrlCreateButton("Étage 0", 462, 320, 90, 60)
Global $CABINE_ETAGE_00 = GUICtrlCreatePic("res\Led_Red_Off.bmp", 568, 336, 28, 28)
Global $ENVOI_1 = GUICtrlCreateButton("Étage 1", 462, 256, 90, 60)
Global $ENVOI_2 = GUICtrlCreateButton("Étage 2", 462, 192, 90, 60)
Global $ENVOI_3 = GUICtrlCreateButton("Étage 3", 462, 128, 90, 60)
Global $CABINE_ETAGE_01 = GUICtrlCreatePic("res\Led_Red_Off.bmp", 568, 274, 28, 28)
Global $CABINE_ETAGE_02 = GUICtrlCreatePic("res\Led_Red_Off.bmp", 568, 210, 28, 28)
Global $CABINE_ETAGE_03 = GUICtrlCreatePic("res\Led_Red_Off.bmp", 568, 144, 28, 28, BitOR($GUI_SS_DEFAULT_PIC,$SS_CENTERIMAGE,$SS_RIGHTJUST))
Global $STOP = GUICtrlCreateButton("STOP", 462, 382, 131, 41)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Autres", 456, 0, 150, 105, BitOR($GUI_SS_DEFAULT_GROUP,$BS_CENTER,$WS_BORDER,$WS_CLIPSIBLINGS), $WS_EX_STATICEDGE)
Global $VOYANT_ECLAIRAGE_CABINE = GUICtrlCreatePic("res\Led_Green_Off.bmp", 566, 14, 28, 28)
GUICtrlCreateLabel("Éclairage Cabine", 464, 14, 94, 31, BitOR($SS_CENTER,$SS_CENTERIMAGE))
Global $OBSTACLE_FERMETURE = GUICtrlCreateCheckbox("Obstacle Fermeture", 462, 46, 137, 49, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_RIGHTBUTTON,$BS_PUSHLIKE))
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $Direction_Inf = GUICtrlCreateLabel("Direction : HAUT", 8, 8, 120, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
Global $Etage_Suivant = GUICtrlCreateLabel("Suivant :", 8, 32, 100, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


#Region ENTRÉES

Func MOTEUR_MONTEE()
	Sleep(45)
	$h-=1
	GUICtrlSetPos($CABINE,336,$h)
EndFunc ;==> MOTEUR_MONTEE()

Func MOTEUR_DESCENTE()
	Sleep(50)
	$h+=1
	GUICtrlSetPos($CABINE,336,$h)
EndFunc ;==> MOTEUR_DESCENTE()

Func MOTEUR_OUVERTURE_($porte)
	Switch $porte
		Case 0
			$p0-=1
			GUICtrlSetData($PORTE_ETAGE_0,$p0)
		Case 1
			$p1-=1
			GUICtrlSetData($PORTE_ETAGE_1,$p1)
		Case 2
			$p2-=1
			GUICtrlSetData($PORTE_ETAGE_2,$p2)
		Case 3
			$p3-=1
			GUICtrlSetData($PORTE_ETAGE_3,$p3)
	EndSwitch
	Sleep(20)
EndFunc ;==> MOTEUR_OUVERTURE($porte)

Func MOTEUR_FERMETURE_($porte)
	Switch $porte
		Case 0
			$p0+=1
			GUICtrlSetData($PORTE_ETAGE_0,$p0)
		Case 1
			$p1+=1
			GUICtrlSetData($PORTE_ETAGE_1,$p1)
		Case 2
			$p2+=1
			GUICtrlSetData($PORTE_ETAGE_2,$p2)
		Case 3
			$p3+=1
			GUICtrlSetData($PORTE_ETAGE_3,$p3)
	EndSwitch
	Sleep(20)
EndFunc ;==> MOTEUR_FERMETURE($porte)
#EndRegion ENTRÉES

#Region SORTIES

Func ECLAIRAGE_CABINE($sw)
	If $sw = 0 Then
		GUICtrlSetImage($CABINE, "res\Cabine_Lumiere_Off.bmp")
		GUICtrlSetImage($VOYANT_ECLAIRAGE_CABINE, "res\Led_Green_Off.bmp")
	Else
		GUICtrlSetImage($CABINE, "res\Cabine_Lumiere_On.bmp")
		GUICtrlSetImage($VOYANT_ECLAIRAGE_CABINE, "res\Led_Green_On.bmp")
	EndIf
EndFunc ;==> ECLAIRAGE_CABINE($sw)

Func OBSTACLE_FERMETURE()
	$retour = 0
	$etat = GUICtrlRead($OBSTACLE_FERMETURE)
	If $etat = $GUI_CHECKED Then $retour = 1
	Return $retour
EndFunc ;==> OBSTACLE_FERMETURE()

Func OUVERTURE_PORTE_($etage)
	Switch $etage
		Case 0
			If $p0 <= 5 Then
				Return 1
			Else
				Return 0
			EndIf
		Case 1
			If $p1 <= 5 Then
				Return 1
			Else
				Return 0
			EndIf
		Case 2
			If $p2 <= 5 Then
				Return 1
			Else
				Return 0
			EndIf
		Case 3
			If $p3 <5= 5 Then
				Return 1
			Else
				Return 0
			EndIf
		Case Else
			MsgBox(64,"ERREUR","Fonction : OUVERTURE_PORTE"&@CRLF&"La porte " &$etage&" n'existe pas.")
	EndSwitch
EndFunc ;==> OUVERTURE_PORTE($etage)

Func FERMETURE_PORTE_($etage)
Switch $etage
		Case 0
			If $p0 = 100 Then
				Return 1
			Else
				Return 0
			EndIf
		Case 1
			If $p1 = 100 Then
				Return 1
			Else
				Return 0
			EndIf
		Case 2
			If $p2 = 100 Then
				Return 1
			Else
				Return 0
			EndIf
		Case 3
			If $p3 = 100 Then
				Return 1
			Else
				Return 0
			EndIf
		Case Else
			MsgBox(64,"ERREUR","Fonction : FERMETURE_PORTE"&@CRLF&"La porte " &$etage&" n'existe pas.")
	EndSwitch
EndFunc ;==> FERMETURE_PORTE($etage)

Func CABINE_ETAGE()
			If $h = 328 Then
				$etage = 0
				GUICtrlSetImage($CABINE_ETAGE_0,"res\Led_Red_On.bmp")
				GUICtrlSetImage($CABINE_ETAGE_00,"res\Led_Red_On.bmp")
				Return $etage
			ElseIf $h = 228 Then
				$etage = 1
				GUICtrlSetImage($CABINE_ETAGE_1,"res\Led_Red_On.bmp")
				GUICtrlSetImage($CABINE_ETAGE_01,"res\Led_Red_On.bmp")
				Return $etage
			ElseIf $h = 120 Then
				$etage = 2
				GUICtrlSetImage($CABINE_ETAGE_2,"res\Led_Red_On.bmp")
				GUICtrlSetImage($CABINE_ETAGE_02,"res\Led_Red_On.bmp")
				Return $etage
			ElseIf $h = 15 Then
				$etage = 3
				GUICtrlSetImage($CABINE_ETAGE_3,"res\Led_Red_On.bmp")
				GUICtrlSetImage($CABINE_ETAGE_03,"res\Led_Red_On.bmp")
				Return $etage
			Else
				GUICtrlSetImage($CABINE_ETAGE_0,"res\Led_Red_Off.bmp")
				GUICtrlSetImage($CABINE_ETAGE_00,"res\Led_Red_Off.bmp")
				GUICtrlSetImage($CABINE_ETAGE_1,"res\Led_Red_Off.bmp")
				GUICtrlSetImage($CABINE_ETAGE_01,"res\Led_Red_Off.bmp")
				GUICtrlSetImage($CABINE_ETAGE_2,"res\Led_Red_Off.bmp")
				GUICtrlSetImage($CABINE_ETAGE_02,"res\Led_Red_Off.bmp")
				GUICtrlSetImage($CABINE_ETAGE_3,"res\Led_Red_Off.bmp")
				GUICtrlSetImage($CABINE_ETAGE_03,"res\Led_Red_Off.bmp")
				Return $etage
			EndIf
EndFunc

#EndRegion SORTIES

Func _sortie()
	Exit
EndFunc
