
#ifndef GRESKE_H
#define GRESKE_H

 extern int kolona;
 extern int brojGresaka;
 extern int red;
 void predugacakIdentifikator(int red,int kolona,const char* identifikator);
 void nezatvorenString(int red,int kolona,const char* str);
 void noviRedString(int red,int kolona,const char* str);
 void bezTacke(int red,int kolona,const char* str);
 void ugnjezdenJednolinijskiKomentar(int red,int kolona);
 void ugnjezdenViselinijskiKomentar(int red, int kolona);
 void nezatvorenKomentar(int red, int kolona);
 void nedefinisanIdent(int red, int kolona);
 void ponovnaDeklaracija(int red,int kolona);
 void Nekompatabilni(int red,int kolona);
 void konstGreska(int red,int kolona);
 void vecPostoji(int red, int kolona);


#endif // GRESKE_H