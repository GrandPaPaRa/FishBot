#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force
SetMouseDelay, -1
SetBatchLines, -1
Process, Priority,, High


;*****preGui
;citire pesti

global pestiRaw := []
global pestiDrop := []
global pestiSelectie := []
global pestiGatit := []
global pestiSelectieNeinclusiv := []

initScoicaMode() ;se seteaza unele var din neinclusiv pentru excludere din array

readIniFileKeys("PestiSelectie","Pesti.ini",pestiSelectie,true)
;initFarmatMode() ;se seteaza unele var din Pesti Click

readIniFileKeys("PestiClick","Pesti.ini",pestiRaw,true)
readIniFileKeys("PestiDrop","Pesti.ini",pestiDrop,true)
readIniFileKeys("PestiSelectieNeinclusiv","Pesti.ini",pestiSelectieNeinclusiv,true)
readIniFileKeys("PestiGatit","Pesti.ini",pestiGatit,true)

;numele din fisierele .ini au acelasi nume ca variabilele de control din gui
;citire elemente din GUI

global radio := []
global radioNume := []
global cbFarmat := []
global cbInventar := []
global eStack
global eNume := []

readIniFileKeys("Radio","Gui.ini",radio)
readIniFileKeys("CheckBoxFarmat","Gui.ini",cbFarmat)
readIniFileKeys("CheckBoxInventar","Gui.ini",cbInventar)
readIniFileKeys("RadioNume","Gui.ini",radioNume)
readIniFileKeys("EditNume","Gui.ini",eNume)


;citire coord pt rezolutie

global rez:=[]
createCoordRez(rez)

;mod jigsaw /mod scoica / mod farmat

global isJigSaw
IniRead,isJigSaw,Gui.ini,Radio,radJigSaw
global isModScoica
IniRead,isModScoica,Gui.ini,Radio,radScoica
global isModFarmat
IniRead,isModFarmat,Gui.ini,Radio,radFarmat

;stack rame

global stackRame
IniRead,stackRame,Gui.ini,Edit,eNumarStackRame

;interval pt Spin

global intervalSpin
IniRead,intervalSpin,Gui.ini,Edit,eSpin

global maxCookQueue
IniRead,maxCookQueue,Gui.ini,Edit,eMaxCookQueue

global editNumeArray := []
initEditNume(editNumeArray)

global isUmplerePescar
IniRead,isUmplerePescar,Gui.ini,Radio,radPescar

global depozitName
depozitName := returnDepositName()

;variabile globale pt Img din Misc/Depozit


global cinciZeci := A_WorkingDir . "\Misc\cinci_zeci.png"
global suta := A_WorkingDir . "\Misc\suta.png"
global cinciZeciGri := A_WorkingDir . "\Misc\cinci_zeci_gri.png"
global sutaGri := A_WorkingDir . "\Misc\suta_gri.png"
global pescar := A_WorkingDir . "\Misc\pescar_shop.png"
global deschide := A_WorkingDir . "\Misc\deschide.png"
global inchide := A_WorkingDir . "\Misc\inchide.png"
global focDeTabara := A_WorkingDir . "\Misc\foc_de_tabara.png"
global focShop := A_WorkingDir . "\Misc\foc_shop.png"
global ramaPeJos := A_WorkingDir . "\Depozit\rama_pe_jos.png"
global focPeJos := A_WorkingDir . "\Depozit\foc_pe_jos.png"

;creeaza celulele inventarului(pt modul farmat) si pentru colectare rame

global inventarFarmat := []
intCreateInv(inventarFarmat)
global cookQueue := []

global inventarRame := []
intCreateInv(inventarRame)
global rameQueue := []
;*****GUI

Gui, Add, Tab3, x0 y0 w400 h540 Border AltSubmit vTabs gTab,Main|Tab2|Umplere Rama

Gui, Tab, 1

Gui,Font,s10

Gui, Add, Text,x155 y30 c0xc90606, Rezolutie



Gui, Add, Radio,x100 y+5 group vradRez1920 grez,1920 x 1080
Gui, Add, Radio,x+20 vradRez1366 grez,1366 x 768

Gui, Add, Text,x140 y+30 c0x222be0, Mod de Pescuit


Gui, Add, Radio,x80 y+5 group vradJigSaw gmodPescuit,JigSaw
Gui, Add, Radio,x+20 vradFarmat gmodPescuit,Farmat Pesti
Gui, Add, Radio,x+20 vradScoica gmodPescuit,Scoica



Gui, Add, Text,y+25 x150 c0x317321,Pesti Farmat

;F-ul de la sfarsitul variabilelor vine de la farmat, cb- CheckBox

Gui, Add, CheckBox, x10 y+10 vcbYabbyF gpestiFarmat,Yabby
Gui, Add, CheckBox,x+10 vcbPesteAuriuF gpestiFarmat,Peste auriu
Gui, Add, CheckBox,x+10 vcbAnghilaF gpestiFarmat,Anghila
Gui, Add, CheckBox,x+10 vcbShiriF gpestiFarmat,Shiri
Gui, Add, CheckBox,x10 y+10 vcbHamsieF gpestiFarmat,Hamsie
Gui, Add, CheckBox,x+10 vcbPesteMicF gpestiFarmat,(Test)Peste mic
Gui, Add, CheckBox,x+10 vcbCrapF gpestiFarmat,(Test)Crap
Gui, Add, CheckBox,x10 y+10 vcbPesteMandarinaF gpestiFarmat,(Test)Peste mandarina
Gui, Add, CheckBox,x+10 vcbSalauF gpestiFarmat,(Test)Salau

initControlStatus(cbFarmat,"CheckBoxFarmat",true)

Gui, Add,Text,y+40 x120 c0918316,Pesti de pastrat in inventar

;I-ul vine de la inventar

Gui, Add, CheckBox,x10 y+10 vcbYabbyI gpestiInventar,Yabby
Gui, Add, CheckBox,x+10 vcbPesteAuriuI gpestiInventar,Peste auriu
Gui, Add, CheckBox, x+10 vcbAnghilaI gpestiInventar,Anghila
Gui, Add, CheckBox,x+10 vcbScoicaI gpestiInventar,Scoica
Gui, Add, CheckBox,x10 y+10 vcbHamsieI gpestiInventar,Hamsie
Gui, Add, CheckBox,x+10 vcbShiriI gpestiInventar,Shiri
Gui, Add, CheckBox,x+10 vcbCheieDeArgintI gpestiInventar,Cheie de Argint
Gui, Add, CheckBox,x+10 vcbCheieKelpieI gpestiInventar,Cheie Kelpie
Gui, Add, CheckBox,x10 y+10 vcbCheieDeAurI gpestiInventar,Cheie de Aur
Gui, Add, CheckBox,x+10 vcbPesteMicI gpestiInventar,(Test)Peste mic
Gui, Add, CheckBox,x+10 vcbCrapI gpestiInventar,(Test)Crap
Gui, Add, CheckBox,x10 y+10 vcbPesteMandarinaI gpestiInventar,(Test)Peste mandarina
Gui, Add, CheckBox,x+10 vcbSalauI gpestiInventar,(Test)Salau

initControlStatus(cbInventar,"CheckBoxInventar")

;edit field pentru numarul de stacuri de rame ce se iau de la pescar


Gui, Add, Text,x10 y+40 c0x9728b0, Stacuri de rame(cumpara de la pescar)
Gui, Add, Edit,x+20 w20 h18 number limit2 veNumarStackRame geditNumber,%stackRame%

Gui, Add, Text,x10 y+10 c0xc98036,Inrerval de timp pt Spin (in rame)
Gui, Add, Edit,x+20 w35 h18 number limit4 veSpin geditNumber,%intervalSpin%

Gui, Add, Text,x10 y+10 c0x1D906F,Numar Maxim CookQueue
Gui, Add, Edit,x+20 w20 h18 number limit2 veMaxCookQueue geditNumber,%maxCookQueue%

Gui, Tab, 2

Gui,Font,s10
Gui, Add, Text,x10 y100 c0x1D906F,Numar Maxim CookQueue

Gui, Tab, 3

Gui, Font,s10
Gui, Add, Text, x120 y30, Mod Procurare Rama/Foc
Gui, Add, Radio, group x100 y+10 vradPescar gmodUmplereRama,Pescar
Gui, Add, Radio, x+30 vradCaracterDepozit gmodUmplereRama,Caracter Depozit

Gui, Add, Radio,vradNume1 gradioNume group x10 y+20,
Gui, Add, Radio,vradNume2 gradioNume x+155 ,
Gui, Add, Radio,vradNume3 gradioNume x10 y+18,
Gui, Add, Radio,vradNume4 gradioNume x+155 ,
Gui, Add, Radio,vradNume5 gradioNume x10 y+18,
Gui, Add, Radio,vradNume6 gradioNume x+155 ,
Gui, Add, Radio,vradNume7 gradioNume x10 y+18,
Gui, Add, Radio,vradNume8 gradioNume x+155 ,
Gui, Add, Radio,vradNume9 gradioNume x10 y+18,
Gui, Add, Radio,vradNume10 gradioNume x+155 ,

Gui, Add, Edit, x45 y90 limit100 w140 h18 veNume1 geditNume,% editNumeArray[1]
Gui, Add, Edit, x+50 limit100 w140 h18 veNume2 geditNume,% editNumeArray[2]
Gui, Add, Edit, x45 y+16 limit100 w140 veNume3 h18 geditNume,% editNumeArray[3]
Gui, Add, Edit, x+50 limit100 w140 h18 veNume4 geditNume,% editNumeArray[4]
Gui, Add, Edit, x45 y+16 limit100 w140 veNume5 h18 geditNume,% editNumeArray[5]
Gui, Add, Edit, x+50 limit100 w140 h18 veNume6 geditNume,% editNumeArray[6]
Gui, Add, Edit, x45 y+16 limit100 w140 veNume7 h18 geditNume,% editNumeArray[7]
Gui, Add, Edit, x+50 limit100 w140 h18 veNume8 geditNume,% editNumeArray[8]
Gui, Add, Edit, x45 y+16 limit100 w140 veNume9 h18 geditNume,% editNumeArray[9]
Gui, Add, Edit, x+50 limit100 w140 h18 veNume10 geditNume,% editNumeArray[10]

initControlStatus(radioNume,"RadioNume",true)

Gui, Tab,

initControlStatus(radio,"Radio")

Gui,Font,s10
Gui, Add, Button,x20 y550 h40 w70 ghelp,Help
Gui, Add, Button,x+220 h40 w70 gapply,Apply

Gui, Show, w400 h600 ,FishBot Gamma

;*****Etichete

Tab:
	Gui, Submit,NoHide
return

rez:
	Gui,Submit,NoHide
	writeControlStatus(radRez1920,"Gui.ini","Radio","radRez1920")
	writeControlStatus(radRez1366,"Gui.ini","Radio","radRez1366")
	switch A_GuiControl{
		case "radRez1920":
			writeCoordRez("inventar",1732,671,1916,1016)
			writeCoordRez("selectie",658,990,1262,1051)
			writeCoordRez("locRama",889,1064)
			writeCoordRez("locRamaShop",1616,97)
			writeCoordRez("offsetRamaShop",8)
			writeCoordRez("offsetPescar",20,10)
			writeCoordRez("deschide",844,354,1085,544)
			writeCoordRez("inchide",1523,12,1704,177)
			writeCoordRez("existaRama",869,1039,902,1074)
			writeCoordRez("fereastraPescuit",533,202,613,221)
			writeCoordRez("cercRosu",537,264,620,302)
			writeCoordRez("zonaPescuit",494,256,654,408)
			writeCoordRez("offsetInv",30,740,1770)
			writeCoordRez("offsetDropItm",300,5)
			writeCoordRez("da",827,511,1070,582)
			writeCoordRez("goFish",663,1020,1262,1051)
			writeCoordRez("locFocDeTabaraShop",1570,61)
			writeCoordRez("updateInventar",1755,730,1780,755)
			writeCoordRez("locInchidePescuit",705,208)
			writeCoordRez("locDeschideSoapta",1217,1030)
		case "radRez1366":
			writeCoordRez("inventar",1188,355,1365,705)
			writeCoordRez("selectie",385,677,925,740)
			writeCoordRez("locRama",613,750)
			writeCoordRez("locRamaShop",1049,93)
			writeCoordRez("offsetRamaShop",8)
			writeCoordRez("offsetPescar",20,10)
			writeCoordRez("deschide",525,216,864,466)
			writeCoordRez("inchide",1087,0,1160,56)
			writeCoordRez("existaRama",588,722,632,767)
			writeCoordRez("fereastraPescuit",263,90,554,131)
			writeCoordRez("cercRosu",382,174,424,188)
			writeCoordRez("zonaPescuit",340,174,475,301)
			writeCoordRez("offsetInv",30,430,1215)
			writeCoordRez("offsetDropItm",300,5)
			writeCoordRez("da",582,376,689,426)
			writeCoordRez("goFish",384,708,925,740)
			writeCoordRez("locFocDeTabaraShop",1023,61)
			writeCoordRez("updateInventar",1202,415,1227,440)
			writeCoordRez("locInchidePescuit",538,118)
			writeCoordRez("locDeschideSoapta",941,717)
	}
return

modUmplereRama:
	Gui,Submit,NoHide
	writeControlStatus(radPescar,"Gui.ini","Radio","radPescar")
	writeControlStatus(radCaracterDepozit,"Gui.ini","Radio","radCaracterDepozit")
	if(A_GuiControl = "radPescar"){
		disableCheckBox(radioNume)
		disableCheckBox(eNume)
	}else{
		enableCheckBox(radioNume)
		enableCheckBox(eNume)
	}

return

modPescuit:
	Gui,Submit,NoHide
	writeControlStatus(radJigSaw,"Gui.ini","Radio","radJigSaw")
	writeControlStatus(radFarmat,"Gui.ini","Radio","radFarmat")
	writeControlStatus(radScoica,"Gui.ini","Radio","radScoica")

	if(radJigSaw = 1 or radScoica = 1)
		disableCheckBox(cbFarmat)
	else
		enableCheckBox(cbFarmat)

return

radioNume:
	Gui,Submit,NoHide
	GuiControlGet,value,,%A_GuiControl%
	loop 10{
		name := "radNume" . A_Index
		writeControlStatus(0,"Gui.ini","RadioNume",name)
	}
	writeControlStatus(%A_GuiControl%,"Gui.ini","RadioNume",A_GuiControl)
return

editNume:
	Gui,Submit,NoHide
	writeControlStatus(%A_GuiControl%,"Gui.ini","EditNume",A_GuiControl)
return

pestiFarmat:
	Gui,Submit,NoHide
	writeControlStatus(%A_GuiControl%,"Gui.ini","CheckBoxFarmat",A_GuiControl)
	GuiControlGet,value,,%A_GuiControl%
	switch A_GuiControl{
		case "cbYabbyF":
			writeControlStatus(value,"Pesti.ini","PestiSelectie","yabby")
			writeControlStatus(value,"Pesti.ini","PestiGatit","yabby")
		case "cbPesteAuriuF":
			writeControlStatus(value,"Pesti.ini","PestiSelectie","peste_auriu")
			writeControlStatus(value,"Pesti.ini","PestiGatit","peste_auriu")
		case "cbAnghilaF":
			writeControlStatus(value,"Pesti.ini","PestiSelectie","anghila")
			writeControlStatus(value,"Pesti.ini","PestiGatit","anghila")
		case "cbShiriF":
			writeControlStatus(value,"Pesti.ini","PestiSelectie","shiri")
			writeControlStatus(value,"Pesti.ini","PestiGatit","shiri")
		case "cbHamsieF":
			writeControlStatus(value,"Pesti.ini","PestiSelectie","hamsie")
			writeControlStatus(value,"Pesti.ini","PestiGatit","hamsie")
		case "cbPesteMicF":
			writeControlStatus(value,"Pesti.ini","PestiSelectie","peste_mic")

		case "cbCrapF":
			writeControlStatus(value,"Pesti.ini","PestiSelectie","crap")
			writeControlStatus(value,"Pesti.ini","PestiGatit","crap")
		case "cbPesteMandarinaF":
			writeControlStatus(value,"Pesti.ini","PestiSelectie","peste_mandarina")
			writeControlStatus(value,"Pesti.ini","PestiGatit","peste_mandarina")
		case "cbSalauF":
			writeControlStatus(value,"Pesti.ini","PestiSelectie","salau")
			writeControlStatus(value,"Pesti.ini","PestiGatit","salau")
	}
return

pestiInventar:
	Gui,Submit,NoHide
	writeControlStatus(%A_GuiControl%,"Gui.ini","CheckBoxInventar",A_GuiControl)
	GuiControlGet,value,,%A_GuiControl%
	switch A_GuiControl{
		case "cbYabbyI":
			writeControlStatus(!value,"Pesti.ini","PestiDrop","yabby_mort")
		case "cbPesteAuriuI":
			writeControlStatus(!value,"Pesti.ini","PestiDrop","peste_auriu_mort")
		case "cbAnghilaI":
			writeControlStatus(!value,"Pesti.ini","PestiDrop","anghila_moarta")
		case "cbHamsieI":
			writeControlStatus(!value,"Pesti.ini","PestiDrop","hamsie_moarta")
		case "cbShiriI":
			writeControlStatus(!value,"Pesti.ini","PestiDrop","shiri_mort")
		case "cbCheieDeArgintI":
			writeControlStatus(!value,"Pesti.ini","PestiDrop","cheie_de_argint")
		case "cbCheieKelpieI":
			writeControlStatus(!value,"Pesti.ini","PestiDrop","cheie_kelpie")
		case "cbCheieDeAurI":
			writeControlStatus(!value,"Pesti.ini","PestiDrop","cheie_de_aur")
		case "cbScoicaI":
			writeControlStatus(!value,"Pesti.ini","PestiClick","scoica")
		case "cbPesteMicI":
			writeControlStatus(!value,"Pesti.ini","PestiDrop","peste_mic")
		case "cbCrapI":
			writeControlStatus(!value,"Pesti.ini","PestiDrop","crap_mort")
		case "cbPesteMandarinaI":
			writeControlStatus(!value,"Pesti.ini","PestiDrop","peste_mandarina_mort")
		case "cbSalauI":
			writeControlStatus(!value,"Pesti.ini","PestiDrop","salau_mort")
	}
return

editNumber:
	Gui,Submit,Nohide
	writeControlStatus(%A_GuiControl%,"Gui.ini","Edit",A_GuiControl)
return

GuiClose:
	ExitApp
return

help:
	msgbox,Salut eu sunt Mihai
	msgbox,Ok
	msgbox,Pa!
return

apply:
	Reload
return

;*****Hotkey

F5::
	miscare := 0
	initSpin() ;seteaza camera
	initCoordPlatosa(xPlatosa,yPlatosa)
	loop{
		miscare++
		if(miscare = intervalSpin){ ;initiaza spin dupa interval spin
			spin() ;previne blocarea jocului
			miscare := 0
		}
		umplereRama() ;verifica daca are rama
		sen("1")
		Sleep,200
		sen("Space")

		loop{   ;asteapta pana apare fereastra de pescuit
			if(A_Index > 50)
				break
			ImageSearch, x1,y1, % rez["fereastraPescuit"][1], % rez["fereastraPescuit"][2], % rez["fereastraPescuit"][3], % rez["fereastraPescuit"][4],*20 pescuit.png
			if(ErrorLevel=0)
				break
			Sleep, 300
		}
		Sleep, 100
		;inceput selectie

		;cauta cazul select de ton auriu
		isTonAuriu := sansaTonAuriu(rez["selectie"][1],rez["selectie"][2],rez["selectie"][3],rez["selectie"][4])

		if(isJigSaw = 1 or isModScoica = 1){    ;selectia JigSaw
			searchFishArray(xp,yp,1,pestiSelectieNeinclusiv,rez["selectie"][1],rez["selectie"][2],rez["selectie"][3],rez["selectie"][4])
			if(xp != -1000){
				skipFishPlatosa(xPlatosa,yPlatosa,true)
				sleep, 50
				continue
			}
		}else{    ;selectia Farmat
			searchFishArray(xp,yp,1,pestiSelectie,rez["selectie"][1],rez["selectie"][2],rez["selectie"][3],rez["selectie"][4])
			if(xp = -1000){
				skipFishPlatosa(xPlatosa,yPlatosa,true)
				sleep, 50
				continue
			}
		}

		;inceput pescuit
		loop{
			ImageSearch, x1,y1, % rez["fereastraPescuit"][1], % rez["fereastraPescuit"][2], % rez["fereastraPescuit"][3], % rez["fereastraPescuit"][4],*20 pescuit.png
			if(ErrorLevel=0){
				loop{
					if(A_Index > 500){
						IniRead,value,Error.ini,EroarePescuit,pesti_neprinsi
						value++
						IniWrite,%value%,Error.ini,EroarePescuit,pesti_neprinsi
						break
					}


					PixelSearch, x, y, % rez["cercRosu"][1], % rez["cercRosu"][2], % rez["cercRosu"][3], % rez["cercRosu"][4], 0xC7ADFF,16,Fast
					if(ErrorLevel = 0){
						PixelSearch, x, y, % rez["zonaPescuit"][1], % rez["zonaPescuit"][2], % rez["zonaPescuit"][3], % rez["zonaPescuit"][4], 0x7C5A38,3 ,Fast
						if(ErrorLevel = 1)
							continue
						MouseMove, x, y + 7
						Sleep,5
						Click,Down
						Sleep,300
						Click,Up
						Sleep,250
						break

				}
				}
		}else
			break
	}
	Sleep,100

	;sfarsit pescuit


	if(goFish() = false){
		clickTonAuriu(isTonAuriu)
		;checkUpgradeUndita()
		skipFishPlatosa(xPlatosa,yPlatosa)
		continue
	}

	;checkUpgradeUndita()

	;apasa pe deschide in cazul select ton auriu
	clickTonAuriu(isTonAuriu)

	Sleep, 600

	refreshInv()

    ;***CAUTAT IN INVENTAR

	if(isModFarmat = 1){ ;cautarea in inventar mod farmat cu campfire
		updateInventar(inventarFarmat,cookQueue,pestiGatit)

		if(cookQueue.Count() >= maxCookQueue){
			shopPescar(-1000) ; cumpara campfire
			clickFocDeTabara()
			ImageSearch, x, y, 0, 0,A_ScreenWidth, A_ScreenHeight, *10 *TransBlack %focDeTabara%

			MouseMove, % x + 20, % y + 10
			Sleep,200
			Click,Right
			Sleep,200

			for index, element in cookQueue{
				element.clickFoc(x,y)
			}
			if(cookQueue.Count() != 0)
				cookQueue.Delete(1,cookQueue.Count())

			resetInventar(inventarFarmat)

			MouseMove,0,0
			Sleep,200

			umplereRama() ;muta textul mai in sus pt a nu mai aparea cuvantul "primit"
			sen("1")
			Sleep,200
			skipFishPlatosa(xPlatosa,yPlatosa)
		}


	}else{ ;cautarea in inventar pe moduri non farmat(clasic)


		;cauta in inventar pestii de dat click dreapta (Pestii_Click)

		index := 1
		loop{
			searchFishArray(xp,yp,index,pestiRaw,rez["inventar"][1],rez["inventar"][2],rez["inventar"][3],rez["inventar"][4])
			if(xp = -1000)
				break
			MouseMove,xp,yp
			Sleep, 200
			Click,1,Right
			Sleep, 50
			MouseMove,0,0
		}

		;cauta si arunca pestii din Pesti_Drop

		index := 1
		loop{
			searchFishArray(xp,yp,index,pestiDrop,rez["inventar"][1],rez["inventar"][2],rez["inventar"][3],rez["inventar"][4])
			if(xp = -1000)
				break
			dropItm(xp,yp)
			Sleep, 200
		}
	}

	;sfarsit cautat in inventar


}
return

F6::
	Reload
return

F7::ExitApp

;Teste
F8::
	sendDrop("MicaMalina","foc",1)
	pickupItem(focPeJos)
return
	;Clase ***

Class CelulaInventar{
	x1 := 0
	y1:= 0
	x2 := 0
	y2 := 0
	exista := 0

	__New(xSus,ySus,xJos,yJos,exist){
		this.x1 := xSus
		this.y1 := ySus
		this.x2 := xJos
		this.y2 := yJos
		this.exista := exist
	}
	clickFoc(x,y){

			MouseMove,this.x1 ,this.y1
			Sleep,200
			Click,1
			Sleep,200
			MouseMove, x + 20, y + 10
			Sleep,200
			Click,1
			Sleep,200

	}
}


	;functii*******


sen(key){   ; apasa un buton
	send, {%key% down}
	sleep, 200
	send, {%key% up}
}

refreshInv(){
	loop, 9{
		y := (A_Index-1)* rez["offsetInv"][1] + rez["offsetInv"][2]
		loop, 5{
			x :=(A_Index-1)* rez["offsetInv"][1] + rez["offsetInv"][3]
			MouseMove,x,y
			Sleep,20
		}
	}
	MouseMove,0,0
}

dropItm(x, y){
	MouseMove,x,y
	Sleep,200
	Click,Left,Down
	Sleep,200
	MouseMove, % A_ScreenWidth // 2,10
	Sleep, 200
	Click,Left,Up
	Sleep, 200
	ImageSearch,xd, yd , % rez["da"][1], % rez["da"][2], % rez["da"][3], % rez["da"][4], *20 da.png
	MouseMove, % xd + rez["offsetDropItm"][2], % yd + rez["offsetDropItm"][2]
	Sleep,200
	Click,1
}

goFish(){ ; determina daca a prins un peste
	go := true
	loop, 5{
		ImageSearch, x, y, % rez["selectie"][1], % rez["selectie"][2], % rez["selectie"][3], % rez["selectie"][4], *10 *TransBlack pierdut_momeala.png
			if(ErrorLevel = 0)
				go := false
	}
	return go


}

searchFishArray(byref x, byref y, byref index, pesti, coordx0, coordy0, coordx1, coordy1,trans = true){ ; x = -1000 daca nu a gasit nimic, trans = true daca imaginea are fundal negru trans = true din default

	if(trans = true){
		for index, element in pesti{
			ImageSearch, x, y, %coordx0%, %coordy0%, %coordx1%, %coordy1%, *10 *TransBlack %element%
			if(ErrorLevel = 0)
				return
	}
	}else{
		for index, element in pesti{
			ImageSearch, x, y, %coordx0%, %coordy0%, %coordx1%, %coordy1%, *10 %element%
			if(ErrorLevel = 0)
				return
	}
	}
	x := -1000
	return
}

readIniFileKeys(section,fileName,array,imagine = false){ ; parametrul imagine stabileste daca pregateste vectorul pentru adresa imaginilor (de peste)
	if(imagine = true){
		switch section{
			case "PestiClick":
				folder := "Pesti_Click"
			case "PestiDrop":
				folder := "Pesti_Drop"
			case "PestiSelectie":
				folder := "Pesti_Selectie"
			case "PestiSelectieNeinclusiv":
				folder := "Pesti_Selectie_Neinclusiv"
			case "PestiGatit":
			folder := "Pesti_Gatit"
		}
	}
	charSection := section ; sectiunea fara []
	section := "[" . section . "]"
	loop{
		FileReadLine, string, %fileName%, %A_Index%
		    if(InStr(string,"[")){
				if(string = section){
					index := A_Index + 1
					loop{
						FileReadLine, string, %fileName%, %index%
							if(InStr(string,"[") or ErrorLevel = 1)
								return
							eqPos := InStr(string,"=")
							string := SubStr(string,1,eqPos-1)
							if(imagine = true){
								IniRead,value,%fileName%,%charSection%,%string%
								if(value = 1)
									array.push(A_WorkingDir . "\" . folder . "\" . string . ".png")
							}
							else
								array.push(string)
						index++
					}
				}
			}
	}
}

skipFish(isEscape = false){ ; isEscape = true foloseste si escape in secventa
	if(isEscape = true){
		sen("Esc")
		sleep, 150
	}
	sleep, 200
	send, {Ctrl down} {g down}
	sleep, 200
	send, {g up}
	sleep, 200
	send, {g down}
	sleep, 200
	send, {g up}
	sleep, 200
	send, {Ctrl up}
	sleep, 200
}
skipFishPlatosa(x,y,isEscape = false){ ; isEscape = true foloseste si escape in secventa
	if(isEscape = true){

		MouseMove,% rez["locInchidePescuit"][1],% rez["locInchidePescuit"][2]
		Sleep,200
		Click,1
		Sleep,200
	}
	MouseMove, x, y
	Sleep,200
	Click, Right
	Sleep,200
	MouseMove,0,0
}
initCoordPlatosa(byref x, byref y){
	index := 1

	while(index <= 5){	;numarul de platose
		string:= A_WorkingDir . "\Misc\platosa" . index . ".png"
		ImageSearch, x, y, % rez["inventar"][1], % rez["inventar"][2], % rez["inventar"][3], % rez["inventar"][4], *10 %string%
		if(ErrorLevel = 0)
			return
		index++
	}
	msgbox, Armura negasita!
	Reload
}
sansaTonAuriu(coordx0,coordy0,coordx1,coordy1){ ;coord sunt pentru preselectie
	ton := A_WorkingDir . "/Pesti_Selectie/ton_auriu.png"
	ImageSearch, x, y, %coordx0%, %coordy0%, %coordx1%, %coordy1%, *10 *TransBlack %ton%
	if(ErrorLevel = 0)
		return 1
	return 0
}
clickTonAuriu(isTon){
	if(isTon = 1){
		Sleep, 4000
		ImageSearch, x, y, % rez["deschide"][1], % rez["deschide"][2], % rez["deschide"][3], % rez["deschide"][4], *10 *TransBlack deschide.png
		if(ErrorLevel = 0){
			MouseMove, x-5, y+5
			Sleep,100
			Click,1
		}
		Sleep,2000
	}
}
existaRama(coordx0,coordy0,coordx1,coordy1){
	ImageSearch, x, y, %coordx0%, %coordy0%, %coordx1%, %coordy1%, *10 *TransBlack rama.png
	if(ErrorLevel = 0)
		return true
	return false
}
umplereRama(){
		loop{
		isRama := existaRama(rez["existaRama"][1],rez["existaRama"][2],rez["existaRama"][3],rez["existaRama"][4])
			if(isRama = true)
				return
		ImageSearch, x, y, % rez["inventar"][1], % rez["inventar"][2], % rez["inventar"][3], % rez["inventar"][4], *10 *TransBlack rama.png
			if(ErrorLevel = 1){
				if(isUmplerePescar = 0){
					sendDrop(depozitName,"rama",stackRame)
					pickupItem(ramaPeJos)
				}else
					shopPescar(stackRame)
			}
			else
				break
		}
	MouseMove,x,y
	Sleep, 200
	Click,1
	Sleep,200
	MouseMove,% rez["locRama"][1], % rez["locRama"][2]
	Sleep,200
	Click,1
	Sleep,100
	MouseMove,0,0
	Sleep, 200
}
checkUpgradeUndita(){
	ImageSearch, x, y, 658, 990, 1262, 1051, *10 *TransBlack du-te_la_pescar.png
	if(ErrorLevel = 0)
		msgbox,upgrade time
}
culegeRama(count){
	loop %count%{

		MouseMove, % rez["locRamaShop"][1], % rez["locRamaShop"][2]
		Sleep,200
		loop, 4{
			Click, Right
			Sleep, 1000
		}

	updateInventar(inventarRame,rameQueue,cinciZeci,false)
	index := 1

	while(index < rameQueue.Count()){
		MouseMove,% rameQueue[index].x1,% rameQueue[index].y1
		Sleep,200
		Click,1
		MouseMove,% rameQueue[index + 1].x1,% rameQueue[index + 1].y1
		Sleep,200
		Click,1
		Sleep,200
		index++
	}
	if(rameQueue.Count()!=0)
		rameQueue.Delete(1,rameQueue.Count())
	resetInventar(inventarRame)
	/*
		loop, 4{

			ImageSearch,x,y, % rez["inventar"][1], % rez["inventar"][2], % rez["inventar"][3], % rez["inventar"][4], *5 *TransBlack %cinciZeci%
			if(ErrorLevel = 1)
				ImageSearch,x,y, % rez["inventar"][1], % rez["inventar"][2], % rez["inventar"][3], % rez["inventar"][4], *5 *TransBlack %cinciZeciGri%
			MouseMove, % x + rez["offsetRamaShop"][1], % y + rez["offsetRamaShop"][1]
			Sleep,100
			Click,1
			Sleep,200
		}

		loop, 2{
			ImageSearch,x,y, % rez["inventar"][1], % rez["inventar"][2], % rez["inventar"][3], % rez["inventar"][4], *5 *TransBlack %suta%
			if(ErrorLevel = 1)
				ImageSearch,x,y, % rez["inventar"][1], % rez["inventar"][2], % rez["inventar"][3], % rez["inventar"][4], *5 *TransBlack %sutaGri%
			MouseMove, % x + rez["offsetRamaShop"][1], % y + rez["offsetRamaShop"][1]
			Sleep,100
			Click,1
			Sleep,200
		}
	*/
	}
}
shopPescar(count){ ;daca count == -1000 cumpara un foc de tabara, count > 0 cumpara count stacuri de rame
	ImageSearch,x,y,0, 0, A_ScreenWidth, A_ScreenHeight, *5 *TransBlack %pescar%
	MouseMove, % x + rez["offsetPescar"][1], % y + rez["offsetPescar"][2]
	Sleep,200
	Click,1
	loop{ ;asteapta pana apare deschide
		if(A_Index > 30)
			break
		ImageSearch,x,y, % rez["deschide"][1], % rez["deschide"][2], % rez["deschide"][3], % rez["deschide"][4], *5 *TransBlack %deschide%
		if(ErrorLevel = 0)
			break
		Sleep,200
	}
	MouseMove,x,y
	Sleep,200
	Click,1

	loop{ ;asteapta pana apare inventarul shop
		if(A_Index > 30)
			break
		ImageSearch,x,y, % rez["inchide"][1], % rez["inchide"][2], % rez["inchide"][3], % rez["inchide"][4], *5 *TransBlack %inchide%
		if(ErrorLevel = 0)
			break
		Sleep,200
	}
	if(count = -1000){
		MouseMove, % rez["locFocDeTabaraShop"][1], % rez["locFocDeTabaraShop"][2]
		Sleep,200
		Click, Right
	}else{
		culegeRama(count)
	}
	Sleep,200
	ImageSearch,x,y, % rez["inchide"][1], % rez["inchide"][2], % rez["inchide"][3], % rez["inchide"][4], *5 *TransBlack %inchide%
	MouseMove,x,y
	Sleep,200
	Click,1
	Sleep,200

}

createCoordRez(array){ ;extrage numele din section si variabilele din Rez.ini ex rez[section][1]
	temp:=[]
	varName:="NULL"
	index:=5
	loop{
		FileReadLine, string, Rez.ini, %A_Index%
			if(InStr(string,"[")){
				array[varName]:=temp.Clone()
				temp.Delete(1,index-1)
				string:=LTrim(string,"[")
				string:=RTrim(string,"]")
				varName:=string
				index:=1
				continue
			}
		if(ErrorLevel = 1){
			array[varName]:=temp.Clone()
			temp.Delete(1,index-1)
			return
		}

		eqPos := InStr(string,"=")
		string := SubStr(string,eqPos+1)

		temp[index]:=string
		index++
	}
}
writeCoordRez(section,x1,x2=-1,x3=-1,x4=-1){
	tempArray := []
	tempArray.push(x1)
	if(x2 != -1)
		tempArray.push(x2)
	if(x3 != -1)
		tempArray.push(x3)
	if(x4 != -1)
		tempArray.push(x4)

	for index, keyValue in tempArray{
		keyName := "x" . index
		IniWrite,%keyValue%,Rez.ini,%section%,%keyName%
	}

}

sendHold(key,time){
	send, {%key% down}
	sleep, %time%
	send, {%key% up}
}

initSpin(){
	MouseMove,0,0
	loop,20{
		sendHold("f",100)
	}
	loop,20{
		sendHold("g",100)
	}
}

spin(){
	MouseMove,0,0
	loop, 20{
		sendHold("t",100)
	}
	loop, 20{
		sendHold("f",100)
	}
	loop, 25{
		sendHold("e",300)
	}
	loop,20{
		sendHold("g",100)
	}
	Sleep,200
}

initScoicaMode(){
	IniRead,isScoica,Gui.ini,Radio,radScoica
		value := isScoica
		IniWrite,%value%,Pesti.ini,PestiSelectieNeinclusiv,colorant
		IniWrite,%value%,Pesti.ini,PestiSelectieNeinclusiv,inalbitor
		IniWrite,%value%,Pesti.ini,PestiSelectieNeinclusiv,inel
		IniWrite,%value%,Pesti.ini,PestiSelectieNeinclusiv,mantia_secretelor
		IniWrite,%value%,Pesti.ini,PestiSelectieNeinclusiv,regelui

}

initFarmatMode(){
	IniRead,isFarmat,Gui.ini,Radio,radFarmat
	value := !isFarmat
	for index, element in pestiSelectie{
		trim := A_WorkingDir . "\Pesti_Selectie\"
		rezult := SubStr(element,StrLen(trim)+1,StrLen(element)-StrLen(trim)+1)
		rezult := SubStr(rezult,1,InStr(rezult,".")-1)
		if(rezult != "ton_auriu")
			IniWrite,%value%,Pesti.ini,PestiClick,%rezult%
	}
}

intCreateInv(array){
	loop,9{
		indexY := A_Index
		loop,5{
			array.push(new CelulaInventar(rez["updateInventar"][1] + (A_Index - 1) * 32, rez["updateInventar"][2] + (indexY - 1) * 32, rez["updateInventar"][3] + (A_Index - 1) * 32, rez["updateInventar"][4] + (indexY - 1) * 32, 0)) ;*32 este aceiasi ratie si pe 1920 si 1366 nu este nevoie de offset
		}
	}
}
resetInventar(array){
	for index, element in array{
		element.exista := 0
	}
}

updateInventar(inv, queue, imagini, isArray = true){ ;isArray = true cauta mai multe imagini, false doar una
	for index, element in inv{
		if(element.exista = 1)
			continue
		if(isArray = true){
			searchFishArray(xp,yp,1,imagini, element.x1, element.y1, element.x2, element.y2)
			if(xp = -1000)
				continue
		}else{
			ImageSearch, xp, yp, % element.x1, % element.y1, % element.x2, element.y2, *10 *TransBlack %imagini%
			if(ErrorLevel = 1)
				continue
		}

		queue.push(new CelulaInventar(xp,yp,0,0,0))
		element.exista := 1
	}
}
clickFocDeTabara(){
	ImageSearch, x, y, % rez["inventar"][1], % rez["inventar"][2], % rez["inventar"][3], % rez["inventar"][4], *10 %focShop%
	MouseMove, x, y
	Sleep, 200
	Click, Right
	Sleep, 200
}
sendString(string){
	index := 1
	lenght := StrLen(string)
	while(index <= lenght){
		char := SubStr(string,index,1)
		if(char = "^")
			char := "Space"
		else if(char = "~")
			char := "Enter"
		sen(char)
		index++
	}
}
sendDrop(name,type,count){
	sen("Enter")
	Sleep,200
	MouseMove, % rez["locDeschideSoapta"][1], % rez["locDeschideSoapta"][2]
	Sleep,200
	Click,1
	Sleep,200
	name := name . "~"
	sendString(name)
	Sleep,200
	command := "%" . type . "^@" . count . "~"
	sendString(command)
	Sleep,200
	sen("Escape")
	Sleep,200
	sen("Escape")
	Sleep,200
}
pickupItem(adresaImg){
	loop{ ;asteapta item pe jos
		if(A_Index > 400){
			msgbox, Nume gresit/Depozit fara iteme necesare
			Reload
		}
		ImageSearch,x,y, 0, 0, A_ScreenWidth, A_ScreenHeight, *5 *TransBlack %adresaImg%
		if(ErrorLevel = 0)
			break
	}
	loop{
		ImageSearch,x,y, 0, 0, A_ScreenWidth, A_ScreenHeight, *5 *TransBlack %adresaImg%
		MouseMove,x,y
		Sleep,200
		Click,1
		Sleep,200
		MouseMove,0,0
		Sleep,2000
		if(ErrorLevel = 1)
			break
	}
}
returnDepositName(){
	loop 10{
		name := "radNume" . A_Index
		index := A_Index
		IniRead,val,Gui.ini,RadioNume,%name%
		if(val = 1)
			break
	}
	return editNumeArray[index]
}
	;functii GUI*******

writeControlStatus(value,file,section,key){
	IniWrite,%value%,%file%,%section%,%key%
}

initControlStatus(array,section,state = false){ ; state = true inseamna ca initializeaza daca cb este disable sau enable
	for index, element in array{
		IniRead, var,Gui.ini,%section%,%element%
		GuiControl,,%element%,%var%
	}
	if(state = true){
		IniRead, valJigSaw,Gui.ini,Radio,radJigSaw
		IniRead, valScoica,Gui.ini,Radio,radScoica
		IniRead, valPescar,Gui.ini,Radio,radPescar
		if(valJigSaw = 1 or valScoica = 1)
			disableCheckBox(cbFarmat)
		if(valPescar = 1){
			disableCheckBox(radioNume)
			disableCheckBox(eNume)
		}

	}

}

disableCheckBox(array){
	for index, element in array{
		GuiControl,Disable,%element%
	}
}

enableCheckBox(array){
	for index, element in array{
		GuiControl,Enable,%element%
	}
}
initEditNume(array){
	loop 10{
		nume := "eNume" . A_Index
		IniRead, valNume,Gui.ini,EditNume,%nume%
		array.push(valNume)
	}
}