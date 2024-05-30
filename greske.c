#include "greske.h"
#include <stdio.h>

int brojGresaka = 0;

void predugacakIdentifikator(int red, int kolona, const char* identifikator) {
    brojGresaka++;
    printf("Greska na liniji %d karakter %d identifikator %s je predugacak\n", red, kolona, identifikator);
}

void nezatvorenString(int red, int kolona, const char* str) {
    brojGresaka++;
    printf("Greska na liniji %d karakter %d string %s nije zatvoren\n", red, kolona, str);
}

void noviRedString(int red, int kolona, const char* str) {
    brojGresaka++;
    printf("Greska na liniji %d karakter %d string %s sadrzi novi red\n", red, kolona, str);
}

void bezTacke(int red, int kolona, const char* str) {
    brojGresaka++;
    printf("Greska na liniji %d karakter %d broj %s ne sadrzi tacku\n", red, kolona, str);
}

void ugnjezdenJednolinijskiKomentar(int red, int kolona) {
    brojGresaka++;
    printf("Greska na liniji %d karakter %d nije moguce ugnjezdavanje komentara\n", red, kolona);
}

void ugnjezdenViselinijskiKomentar(int red, int kolona) {
    brojGresaka++;
    printf("Greska na liniji %d karakter %d nije moguce ugnjezdavanje komentara\n", red, kolona);
}

void nezatvorenKomentar(int red, int kolona) {
    brojGresaka++;
    printf("Greska na liniji %d karakter %d nezatvoren komentar\n", red, kolona);
}

void nedefinisanIdent(int red,int kolona) {
    brojGresaka++;
    printf("Nije definisan Identifikator na liniji %d karakter %d",red,kolona);

}

void ponovnaDeklaracija(int red,int kolona) {
    brojGresaka++;
    printf("Ponovna deklaracija na liniji %d karakter %d",red,kolona);

}
