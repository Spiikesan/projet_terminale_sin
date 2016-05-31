//Programme créé pour la Terminale Systèmes d'Information et Numérique.
//Par Spiikesan (1° programme donc c'est laid, mais ça marche)
//A exécuter sur arduino Mega 2560, avec un ascenseur de chez Langlois

#include <LiquidCrystal.h>
// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(12, 11, 10, 9, 8, 7);
int Disp = 13;

//Variables internes pour fonctionnement
char Byte;
int OPENNED_TIME = 3; //En secondes
int LIGHT_TIME = 5; //En secondes
int Stopped = 0;
int stopStrob = 0;
int Count_Wait_Open = 0;
int Time_Ec = 0;
int FILE_ATTENTE[3] = {-1,-1,-1};
int haut = 1 , bas = 2;
int Direction = haut;
int etageSuivant = 0 ;
int count = 0;
int obsFromCom = 0;
int Step = 0; //Variable permettant de rendre le système non bloquant (simulation du multithread)
//Cela permet de faire des actions (tels que de choisir un étage) alors que l'ascenseur fait déjà
//quelque chose. Sa n'attend pas dans une boucle quoi.

int const Eclairage_LCD = 6;

// Variables des ENTREES (18 au total)
int const Cabine_Appel_0 = 31;
int const Cabine_Appel_1 = 35;
int const Cabine_Appel_2 = 27;
int const STOP = 37;
int const Obstacle_Fermeture = 33;
int const Appel_Montee_0 = 53;
int const Appel_Descente_1 = 49;
int const Appel_Montee_1 = 41;
int const Appel_Descente_2 = 51;
int const Cabine_Etage_0 = 52;
int const Cabine_Etage_1 = 39;
int const Cabine_Etage_2 = 29;
int const OUVERTURE_PORTE[3] = {50,47,43};
int const FERMETURE_PORTE[3] = {45,23,25};
////////////////////////////////////////

//Variables des SORTIES (16 au total)
int const Moteur_Montee = 38;
int const Moteur_Descente = 42;
int const MOTEUR_OUVERTURE[3] = {48,44,34}; // {(ouverture 0),(ouverture 1),(ouverture 2)}
int const MOTEUR_FERMETURE[3] = {46,40,36}; // {(fermeture 0),(fermeture 1),(fermeture 2)}
int const Voyant_Etage_0 = 32;
int const Voyant_Etage_1 = 30;
int const Voyant_Etage_2 = 28;
int const Voyant_Appel_Montee_0 = 26;
int const Voyant_Appel_Descente_1 = 24;
int const Voyant_Appel_Montee_1 = 22;
int const Voyant_Appel_Descente_2 = 2;
int const Voyant_Eclairage_Cabine = 3;

///////////////////////////////////////

void setup(){ ////////// OK ///////////
  // Port USB //
  Serial.begin(9600);

  // LCD //
  pinMode(Disp, OUTPUT);
  lcd.begin(16, 2);
  analogWrite(Disp, 60);

  // ENTREES //
  pinMode(Cabine_Appel_0, INPUT);
  pinMode(Cabine_Appel_1, INPUT);
  pinMode(Cabine_Appel_2, INPUT);
  pinMode(STOP, INPUT);
  pinMode(Obstacle_Fermeture, INPUT);
  pinMode(Appel_Montee_0, INPUT);
  pinMode(Appel_Descente_1, INPUT);
  pinMode(Appel_Montee_1, INPUT);
  pinMode(Appel_Descente_2, INPUT);
  pinMode(Cabine_Etage_0, INPUT);
  pinMode(Cabine_Etage_1, INPUT);
  pinMode(Cabine_Etage_2, INPUT);
  pinMode(OUVERTURE_PORTE[0], INPUT);
  pinMode(FERMETURE_PORTE[0], INPUT);
  pinMode(OUVERTURE_PORTE[1], INPUT);
  pinMode(FERMETURE_PORTE[1], INPUT);
  pinMode(OUVERTURE_PORTE[2], INPUT);
  pinMode(FERMETURE_PORTE[2], INPUT);
  digitalWrite(Cabine_Appel_0, HIGH);
  digitalWrite(Cabine_Appel_1, HIGH);
  digitalWrite(Cabine_Appel_2, HIGH);
  digitalWrite(STOP, HIGH);
  digitalWrite(Obstacle_Fermeture, HIGH);
  digitalWrite(Appel_Montee_0, HIGH);
  digitalWrite(Appel_Descente_1, HIGH);
  digitalWrite(Appel_Montee_1, HIGH);
  digitalWrite(Appel_Descente_2, HIGH);
  digitalWrite(Cabine_Etage_0, HIGH);
  digitalWrite(Cabine_Etage_1, HIGH);
  digitalWrite(Cabine_Etage_2, HIGH);
  digitalWrite(OUVERTURE_PORTE[0], HIGH);
  digitalWrite(FERMETURE_PORTE[0], HIGH);
  digitalWrite(OUVERTURE_PORTE[1], HIGH);
  digitalWrite(FERMETURE_PORTE[1], HIGH);
  digitalWrite(OUVERTURE_PORTE[2], HIGH);
  digitalWrite(FERMETURE_PORTE[2], HIGH);

  // SORTIES //
  pinMode(Moteur_Montee, OUTPUT);
  pinMode(Moteur_Descente, OUTPUT);
  pinMode(MOTEUR_OUVERTURE[0], OUTPUT);
  pinMode(MOTEUR_FERMETURE[0], OUTPUT);
  pinMode(MOTEUR_OUVERTURE[1], OUTPUT);
  pinMode(MOTEUR_FERMETURE[1], OUTPUT);
  pinMode(MOTEUR_OUVERTURE[2], OUTPUT);
  pinMode(MOTEUR_FERMETURE[2], OUTPUT);
  pinMode(Voyant_Etage_0, OUTPUT);
  pinMode(Voyant_Etage_1, OUTPUT);
  pinMode(Voyant_Etage_2, OUTPUT);
  pinMode(Voyant_Appel_Montee_0, OUTPUT);
  pinMode(Voyant_Appel_Descente_1, OUTPUT);
  pinMode(Voyant_Appel_Montee_1, OUTPUT);
  pinMode(Voyant_Appel_Descente_2, OUTPUT);
  pinMode(Voyant_Eclairage_Cabine, OUTPUT);
  pinMode(Eclairage_LCD, OUTPUT);
  //Lance la procédure d'initialisation si le bouton "stop"
  //est enfoncé à l'allumage de la carte. C'est plus un check
  //pour voir que tout vas bien.
  if (!digitalRead(STOP)){
    _init();
  }
  Direction = haut;
}

void _init(){
  // LCD //
  digitalWrite(Eclairage_LCD, HIGH);
  lcd.setCursor(0,0);
  lcd.print("Initialisation :");
  lcd.setCursor(0,1);
  lcd.print("Voyants...");
  delay(1000);


  //Voyants
  digitalWrite(Voyant_Etage_0, HIGH);
  digitalWrite(Voyant_Etage_1, HIGH);
  digitalWrite(Voyant_Etage_2, HIGH);
  digitalWrite(Voyant_Appel_Montee_0, HIGH);
  digitalWrite(Voyant_Appel_Descente_1, HIGH);
  digitalWrite(Voyant_Appel_Montee_1, HIGH);
  digitalWrite(Voyant_Appel_Descente_2, HIGH);
  digitalWrite(Voyant_Eclairage_Cabine, HIGH);
  digitalWrite(Eclairage_LCD, LOW);
  delay(2000);
  digitalWrite(Voyant_Etage_0, LOW);
  digitalWrite(Voyant_Etage_1, LOW);
  digitalWrite(Voyant_Etage_2, LOW);
  digitalWrite(Voyant_Appel_Montee_0, LOW);
  digitalWrite(Voyant_Appel_Descente_1, LOW);
  digitalWrite(Voyant_Appel_Montee_1, LOW);
  digitalWrite(Voyant_Appel_Descente_2, LOW);
  digitalWrite(Voyant_Eclairage_Cabine, LOW);
  digitalWrite(Eclairage_LCD, HIGH);

  int count = 0;
  //Go à l'étage 0, arrêt d'une seconde à chaque étage.
  int etage_final = 0;
  int etage_intermediaire = 0;
  int etage_haut = 0;

  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("Initialisation :");
  lcd.setCursor(0,1);
  lcd.print("Cabine...");

  while(!etage_haut){
    etage_haut = (!digitalRead(Cabine_Etage_2)) ? 1 : 0;
    digitalWrite(Moteur_Montee, HIGH);
  }
  delay(3000);
  digitalWrite(Moteur_Montee, LOW);

  while(!etage_final){

    delay(1);

    etage_final = (!digitalRead(Cabine_Etage_0)) ? 1 : 0;
    /*    <=>
     if (!digitalRead(Cabine_Etage_0)){
     etage_final = 1;
     }else{
     etage_final = 0;
     }*/

    etage_intermediaire = (!digitalRead(Cabine_Etage_1) || !digitalRead(Cabine_Etage_2)) ? 1 : 0 ;

    digitalWrite(Moteur_Descente, HIGH);
    if (etage_intermediaire && count > 1000){
      digitalWrite(Moteur_Descente, LOW);
      delay(1000);
      count = 0;
    }
    count++;
    delay(1);


  }

  digitalWrite(Moteur_Descente, LOW);

  // Fonctionnement des portes :
  int Step_0 = 0;
  int Step_1 = 0;
  int Step_2 = 0;

  lcd.setCursor(0,1);
  lcd.print("Portes...");

  digitalWrite(MOTEUR_OUVERTURE[0], HIGH);
  delay(800);
  digitalWrite(MOTEUR_OUVERTURE[1], HIGH);
  delay(800);
  digitalWrite(MOTEUR_OUVERTURE[2], HIGH);

  delay(1000);
  while (!(Step_0 == 2 && Step_1 == 2 && Step_2 == 2)){

    //Porte 0 (RDC)
    if(!Step_0){
      Step_0 = (!digitalRead(OUVERTURE_PORTE[0])) ? 1 : 0;
    }
    else if(Step_0 == 1){
      digitalWrite(MOTEUR_OUVERTURE[0], LOW);
      digitalWrite(MOTEUR_FERMETURE[0], HIGH);
      Step_0 = (!digitalRead(FERMETURE_PORTE[0])) ? 2 : 1;
    }

    //Porte 1
    if(!Step_1){
      Step_1 = (!digitalRead(OUVERTURE_PORTE[1])) ? 1 : 0;
    }
    else if(Step_1 == 1){
      digitalWrite(MOTEUR_OUVERTURE[1], LOW);
      digitalWrite(MOTEUR_FERMETURE[1], HIGH);
      Step_1 = (!digitalRead(FERMETURE_PORTE[1])) ? 2 : 1;
    }

    //Porte 2
    if(!Step_2){
      Step_2 = (!digitalRead(OUVERTURE_PORTE[2])) ? 1 : 0;
    }
    else if(Step_2 == 1){
      digitalWrite(MOTEUR_OUVERTURE[2], LOW);
      digitalWrite(MOTEUR_FERMETURE[2], HIGH);
      Step_2 = (!digitalRead(FERMETURE_PORTE[2])) ? 2 : 1;
    }

    //Extinction des portes
    if(Step_0 == 2){
      digitalWrite(MOTEUR_FERMETURE[0], LOW);
    }
    if(Step_1 == 2){
      digitalWrite(MOTEUR_FERMETURE[1], LOW);
    }
    if(Step_2 == 2){
      digitalWrite(MOTEUR_FERMETURE[2], LOW);
    }

  }

  if(!digitalRead(Cabine_Appel_0)){
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Initialisation :");
    lcd.setCursor(0,1);
    lcd.print("Fonc go_etage(0)");
    while (_go_etage_0()!=2){
      delay(1);
    }
    Direction = haut;
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Initialisation :");
    lcd.setCursor(0,1);
    lcd.print("go_etage(0) OK");
  }
  if(!digitalRead(Cabine_Appel_1)){
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Initialisation :");
    lcd.setCursor(0,1);
    lcd.print("Fonc go_etage1)");
    if(Direction == haut){
      while (_go_etage_1_descente()!=2){
        delay(1);
      }
    }else{
      while (_go_etage_1_montee()!=2){
        delay(1);
      }
    }
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Initialisation :");
    lcd.setCursor(0,1);
    lcd.print("go_etage(1) OK");
  }

  if(!digitalRead(Cabine_Appel_2)){
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Initialisation :");
    lcd.setCursor(0,1);
    lcd.print("Fonc go_etage(2)");
    while (_go_etage_2()!=2){
      delay(1);
    }
    Direction = bas;
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Initialisation :");
    lcd.setCursor(0,1);
    lcd.print("go_etage(2) OK");
  }


  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("Initialisation :");
  lcd.setCursor(0,1);
  lcd.print("Terminee.");
  delay(2000);
  lcd.clear();
  Direction = haut;
}//////////////////////////////////////////////////////////////



void _Add_File_Dattente(int quel){
  int n = 0;
  int dejaPresent = 0;

  for (n = 0; n <= 2; n++){
    if (FILE_ATTENTE[n] == quel)
    {
      dejaPresent = 1;
    }
  }

  if (!dejaPresent){
    n=0;
    while (!(FILE_ATTENTE[n]==-1))
    {
      if(n==2){
        break;
      }
      n++;
    }
    FILE_ATTENTE[n] = quel;
  }
}


void _Executer_File_Dattente(){

  // ECLAIRAGE //
  if(FILE_ATTENTE[0]!=-1){
    digitalWrite(Eclairage_LCD, HIGH);
    digitalWrite(Voyant_Eclairage_Cabine, HIGH);
    Time_Ec = 0;
  }
  else{
    if(Time_Ec >= LIGHT_TIME*1000){
      digitalWrite(Eclairage_LCD, LOW);
      digitalWrite(Voyant_Eclairage_Cabine, LOW);
    }
    else{
      Time_Ec++;
    }
  }

  // FILE D'ATTENTE //
  switch (FILE_ATTENTE[0])
  {
  case 0:
    if (_go_etage_0()==2){
      Direction = haut;
     FILE_ATTENTE[0] = -1;
     _Arranger_File_Dattente();
    }
    break;
  case 1:
    if(Direction == haut){
      if (_go_etage_1_montee() == 2){
      FILE_ATTENTE[0] = -1;
      _Arranger_File_Dattente();
    }
    }else{
      if (_go_etage_1_descente() == 2){
      FILE_ATTENTE[0] = -1;
      _Arranger_File_Dattente();
    }
    }
    break;
  case 2:
    if (_go_etage_2()==2){
      Direction = bas;
      FILE_ATTENTE[0] = -1;
      _Arranger_File_Dattente();
    }
    break;
  }
}

void lumiere_etage(int num_etage){
  switch (num_etage){
    case 0:
      digitalWrite(Voyant_Etage_0, HIGH);
      digitalWrite(Voyant_Etage_1, LOW);
      digitalWrite(Voyant_Etage_2, LOW);
    break;
    case 1:
      digitalWrite(Voyant_Etage_0, LOW);
      digitalWrite(Voyant_Etage_1, HIGH);
      digitalWrite(Voyant_Etage_2, LOW);
    break;
    case 2:
      digitalWrite(Voyant_Etage_0, LOW);
      digitalWrite(Voyant_Etage_1, LOW);
      digitalWrite(Voyant_Etage_2, HIGH);
    break;
    case 3:
      digitalWrite(Voyant_Etage_0, LOW);
      digitalWrite(Voyant_Etage_1, LOW);
      digitalWrite(Voyant_Etage_2, LOW);
    break;
  }
}

int _go_etage_0(){
    if ((!digitalRead(Obstacle_Fermeture) || obsFromCom) && Step == 4 && count >= OPENNED_TIME*1000){
      digitalWrite(MOTEUR_FERMETURE[0], LOW);
      digitalWrite(MOTEUR_OUVERTURE[1], LOW);
      Step = 2;
    }

  if(Step == 0){
    Step = (!digitalRead(Cabine_Etage_0)) ? 2 : 0;
    digitalWrite(Moteur_Descente, HIGH);
    lumiere_etage(3);
    _Arranger_File_Dattente();
  }

  if(Step == 2){
    lumiere_etage(0);
    digitalWrite(Moteur_Descente, LOW);
    digitalWrite(Voyant_Appel_Montee_0, LOW);
    digitalWrite(MOTEUR_OUVERTURE[0], HIGH);
    Step = (!digitalRead(OUVERTURE_PORTE[0])) ? 3 : 2;
  }
  else if(Step == 3){
    digitalWrite(MOTEUR_OUVERTURE[0], LOW);
    Step++;
  }

  if(Step == 4){
    count++;
  }

  if(Step == 4 && count >= OPENNED_TIME*1000){
    digitalWrite(MOTEUR_FERMETURE[0], HIGH);
    Step = (!digitalRead(FERMETURE_PORTE[0])) ? 5 : 4;

  }
  else if(Step == 5){
    digitalWrite(MOTEUR_FERMETURE[0], LOW);

    Step = 0;
    count = 0;
    return 2;
  }

}


int _go_etage_2(){

  if ((!digitalRead(Obstacle_Fermeture) || obsFromCom) && Step == 4 && count >= OPENNED_TIME*1000){
      digitalWrite(MOTEUR_FERMETURE[2], LOW);
      digitalWrite(MOTEUR_OUVERTURE[1], LOW);
      Step = 2;
    }

  if(Step == 0){
    Step = (!digitalRead(Cabine_Etage_2)) ? 2 : 0;
    digitalWrite(Moteur_Montee, HIGH);
    lumiere_etage(3);
    _Arranger_File_Dattente();
  }


  if(Step == 2){
    lumiere_etage(2);
    digitalWrite(Moteur_Montee, LOW);
    digitalWrite(Voyant_Appel_Descente_2, LOW);
    digitalWrite(MOTEUR_OUVERTURE[2], HIGH);
    Step = (!digitalRead(OUVERTURE_PORTE[2])) ? 3 : 2;
  }
  else if(Step == 3){
    digitalWrite(MOTEUR_OUVERTURE[2], LOW);
    Step++;
  }

  if(Step == 4){
    count++;
  }

  if(Step == 4 && count >= OPENNED_TIME*1000){

    digitalWrite(MOTEUR_FERMETURE[2], HIGH);
    Step = (!digitalRead(FERMETURE_PORTE[2])) ? 5 : 4;

  }
  else if(Step == 5){
    digitalWrite(MOTEUR_FERMETURE[2], LOW);

    Step = 0;
    count = 0;
    return 2;
  }
}



int _go_etage_1_descente(){


 if ((!digitalRead(Obstacle_Fermeture) || obsFromCom ) && Step == 4 && count >= OPENNED_TIME*1000){
      digitalWrite(MOTEUR_FERMETURE[1], LOW);
      digitalWrite(MOTEUR_OUVERTURE[1], LOW);
      Step = 2;
    }

  if(Step == 0){
    Step = (!digitalRead(Cabine_Etage_1)) ? 2 : 0;
    digitalWrite(Moteur_Descente, HIGH);
    lumiere_etage(3);
    _Arranger_File_Dattente();
  }


  if(Step == 2){
    lumiere_etage(1);
    digitalWrite(Moteur_Descente, LOW);
    digitalWrite(Voyant_Appel_Montee_1, LOW);
    digitalWrite(Voyant_Appel_Descente_1, LOW);
    digitalWrite(MOTEUR_OUVERTURE[1], HIGH);
    Step = (!digitalRead(OUVERTURE_PORTE[1])) ? 3 : 2;
  }
  else if(Step == 3){
    digitalWrite(MOTEUR_OUVERTURE[1], LOW);
    Step++;
  }

  if(Step == 4){
    count++;
  }

  if(Step == 4 && count >= OPENNED_TIME*1000){

    digitalWrite(MOTEUR_FERMETURE[1], HIGH);
    Step = (!digitalRead(FERMETURE_PORTE[1])) ? 5 : 4;

  }
  else if(Step == 5){
    digitalWrite(MOTEUR_FERMETURE[1], LOW);

    Step = 0;
    count = 0;
    return 2;
  }
}

int _go_etage_1_montee(){
    if ((!digitalRead(Obstacle_Fermeture) || obsFromCom) && Step == 4 && count >= OPENNED_TIME*1000){
      digitalWrite(MOTEUR_FERMETURE[1], LOW);
      digitalWrite(MOTEUR_OUVERTURE[1], LOW);
      Step = 2;
    }

    if(Step == 0){
      Step = (!digitalRead(Cabine_Etage_1)) ? 2 : 0;
      digitalWrite(Moteur_Montee, HIGH);
      lumiere_etage(3);
      _Arranger_File_Dattente();
    }

  if(Step == 2){
    lumiere_etage(1);
    digitalWrite(Moteur_Montee, LOW);
    digitalWrite(Voyant_Appel_Montee_1, LOW);
    digitalWrite(Voyant_Appel_Descente_1, LOW);
    digitalWrite(MOTEUR_OUVERTURE[1], HIGH);
    Step = (!digitalRead(OUVERTURE_PORTE[1])) ? 3 : 2;
  }
  else if(Step == 3){
    digitalWrite(MOTEUR_OUVERTURE[1], LOW);
    Step++;
  }

  if(Step == 4){
    count++;
  }

  if(Step == 4 && count >= OPENNED_TIME*1000){

    digitalWrite(MOTEUR_FERMETURE[1], HIGH);
    Step = (!digitalRead(FERMETURE_PORTE[1])) ? 5 : 4;

  }
  else if(Step == 5){
    digitalWrite(MOTEUR_FERMETURE[1], LOW);

    Step = 0;
    count = 0;
    return 2;
  }
}

void _Arranger_File_Dattente(){
  int n = 0;
  int next = 0;

  while (FILE_ATTENTE[n]!=-1 or n == 2)
  {
    n++;
  }
    if (Direction == haut){
     int i,tmp,max_temp,max = 2;
        do
        {
            for(i=0, max_temp = 0 ; i<max ; i++)
            {
                if(FILE_ATTENTE[i] > FILE_ATTENTE[i+1])
                {
                    tmp = FILE_ATTENTE[i];
                    FILE_ATTENTE[i] = FILE_ATTENTE[i+1];
                    FILE_ATTENTE[i+1] = tmp;
                    max_temp = i;
                }
            }
            max = max_temp;
        }while(max > 0);
    }
    else if (Direction == bas){
      int i,tmp,max_temp,max = 2;
        do
        {
            for(i=0, max_temp = 0 ; i<max ; i++)
            {
                if(FILE_ATTENTE[i] < FILE_ATTENTE[i+1])
                {
                    tmp = FILE_ATTENTE[i];
                    FILE_ATTENTE[i] = FILE_ATTENTE[i+1];
                    FILE_ATTENTE[i+1] = tmp;
                    max_temp = i;
                }
            }
            max = max_temp;
        }while(max > 0);
    }
    int i,tmp,max_temp,max = 2;
        do
        {
            for(i=0, max_temp = 0 ; i<max ; i++)
            {
                if(FILE_ATTENTE[i] == -1)
                {
                    tmp = FILE_ATTENTE[i];
                    FILE_ATTENTE[i] = FILE_ATTENTE[i+1];
                    FILE_ATTENTE[i+1] = tmp;
                    max_temp = i;
                }
            }
            max = max_temp;
        }while(max > 0);
}


void actualise_lcd(){
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Bienvenue");
/*    lcd.setCursor(10, 0); // DEBUG
    lcd.print(FILE_ATTENTE[0]);
    lcd.setCursor(12, 0);
    lcd.print(FILE_ATTENTE[1]);
    lcd.setCursor(14, 0);
    lcd.print(FILE_ATTENTE[2]);*/
    lcd.setCursor(0, 1);

    switch (FILE_ATTENTE[0])
    {
    case 0:
      lcd.print("Rez de chausse");
      break;

    case 1:
      lcd.print("Etage 1");
      break;

    case 2:
      lcd.print("Etage 2");
      break;

    case -1:
      lcd.print("En attente.");
      break;
    }
    etageSuivant = FILE_ATTENTE[0];
}

void loop(){


   if(etageSuivant != FILE_ATTENTE[0]){actualise_lcd();}
   delay(1);

  if (!Stopped){
    _Executer_File_Dattente();
    //Port série. Utilisé avec mon programme de "simulation/pilotage à distance"
    //et mon gestionnaire de reconnaissance vocale.
    if (Serial.available() > 0) { // si données disponibles sur le port série
		// lit l'octet entrant
                Byte = Serial.read();
                delay(100);
                if (Byte == 'e') {
                  Byte = Serial.read();
                  //Serial.println(Byte); // DEBUG COM
                  if(Byte == '1'){
                    _Add_File_Dattente(0);
                  }else if(Byte == '2'){
                    _Add_File_Dattente(1);
                  }else if (Byte == '3'){
                    _Add_File_Dattente(2);
                  }
                }else if (Byte == 'o'){ //Obstacle fermeture
                  if (obsFromCom){
                    obsFromCom = 0;
                  }else{
                    obsFromCom = 1;}
                }else if (Byte == 's'){
                  Stopped = 1;
                  lcd.clear();
                  lcd.setCursor(0, 0);
                  lcd.print("####  STOP ####");
                  lcd.setCursor(0,1);
                  lcd.print("#### CABINE ####");
                  digitalWrite(Moteur_Montee, LOW);
                  digitalWrite(Moteur_Descente, LOW);
                  digitalWrite(MOTEUR_OUVERTURE[0], LOW);
                  digitalWrite(MOTEUR_OUVERTURE[1], LOW);
                  digitalWrite(MOTEUR_OUVERTURE[2], LOW);
                  digitalWrite(MOTEUR_FERMETURE[0], LOW);
                  digitalWrite(MOTEUR_FERMETURE[1], LOW);
                  digitalWrite(MOTEUR_FERMETURE[2], LOW);
                }
	}
    if (digitalRead(Cabine_Appel_0)==0){
      _Add_File_Dattente(0);
    }
    else if (digitalRead(Cabine_Appel_1)==0){
      _Add_File_Dattente(1);
    }
    else if (digitalRead(Cabine_Appel_2)==0){
      _Add_File_Dattente(2);
    }
    else if (digitalRead(Appel_Montee_0)==0){
      digitalWrite(Voyant_Appel_Montee_0, HIGH);
      _Add_File_Dattente(0);
    }
    else if (digitalRead(Appel_Descente_1)==0){
      digitalWrite(Voyant_Appel_Descente_1, HIGH);
      _Add_File_Dattente(1);
    }
    else if (digitalRead(Appel_Montee_1)==0){
      digitalWrite(Voyant_Appel_Montee_1, HIGH);
      _Add_File_Dattente(1);
    }
    else if (digitalRead(Appel_Descente_2)==0){
      digitalWrite(Voyant_Appel_Descente_2, HIGH);
      _Add_File_Dattente(2);
    }

    else if (digitalRead(STOP)==0){
      Stopped = 1;
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("####  STOP ####");
      lcd.setCursor(0,1);
      lcd.print("#### CABINE ####");
      digitalWrite(Moteur_Montee, LOW);
      digitalWrite(Moteur_Descente, LOW);
      digitalWrite(MOTEUR_OUVERTURE[0], LOW);
      digitalWrite(MOTEUR_OUVERTURE[1], LOW);
      digitalWrite(MOTEUR_OUVERTURE[2], LOW);
      digitalWrite(MOTEUR_FERMETURE[0], LOW);
      digitalWrite(MOTEUR_FERMETURE[1], LOW);
      digitalWrite(MOTEUR_FERMETURE[2], LOW);
      while(!digitalRead(STOP)){
        delay(1);
      }
    }
  }
  else{
    if (Serial.available() > 0) {
      Byte = Serial.read();
      if(Byte == 's'){
      Stopped = 0;
      actualise_lcd();
      digitalWrite(Voyant_Etage_0, LOW);
      digitalWrite(Voyant_Etage_1, LOW);
      digitalWrite(Voyant_Etage_2, LOW);
      }
    }
    if (digitalRead(STOP)==0){
      Stopped = 0;
      while(digitalRead(STOP)==0){
        delay(1);
      }
      actualise_lcd();
      digitalWrite(Voyant_Etage_0, LOW);
      digitalWrite(Voyant_Etage_1, LOW);
      digitalWrite(Voyant_Etage_2, LOW);
    }
    stopStrob++;
    if (stopStrob == 500){
      digitalWrite(Voyant_Etage_0, HIGH);
      digitalWrite(Voyant_Etage_1, HIGH);
      digitalWrite(Voyant_Etage_2, HIGH);
    }
    else if(stopStrob == 1000){
      digitalWrite(Voyant_Etage_0, LOW);
      digitalWrite(Voyant_Etage_1, LOW);
      digitalWrite(Voyant_Etage_2, LOW);
      stopStrob = 0;
    }
  }
}
