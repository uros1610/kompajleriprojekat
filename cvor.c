#include "cvor.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Cvor* kreirajCvor(char* vrijednost) {
Cvor* noviCvor = malloc(sizeof(struct Cvor));

noviCvor->vrijednost = strdup(vrijednost);
noviCvor->broj_sinova = 0;
noviCvor->sinovi = 0;
noviCvor->sljedeci = 0;
noviCvor->nivo = 0;

return noviCvor;


}

void dodajSina(Cvor* roditelj,Cvor* sin) {
    roditelj->broj_sinova++;
    roditelj->sinovi = realloc(roditelj->sinovi,(sizeof(Cvor)*roditelj->broj_sinova));
    roditelj->sinovi[roditelj->broj_sinova-1] = sin;
}
