
#ifndef GRESKE_H
#define GRESKE_H

 int kolona;
 int brojGresaka;
 int red;
 void predugacakIdentifikator(int red,int kolona,const char* identifikator);
 void nezatvorenString(int red,int kolona,const char* str);
 void noviRedString(int red,int kolona,const char* str);
 void bezTacke(int red,int kolona,const char* str);
 void ugnjezdenJednolinijskiKomentar(int red,int kolona);
 void ugnjezdenViselinijskiKomentar(int red, int kolona);
 void nezatvorenKomentar(int red, int kolona);
 void nedefinisanIdent(int red, int kolona);
 void ponovnaDeklaracija(int red,int kolona);


#endif // GRESKE_H