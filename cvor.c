#include "cvor.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "cvor.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

Cvor* kreirajCvor(char* vrijednost) {
    Cvor* noviCvor = (Cvor*)malloc(sizeof(Cvor));
    

    noviCvor->vrijednost = strdup(vrijednost);
    noviCvor->broj_sinova = 0;
    noviCvor->sinovi = NULL;
    noviCvor->sljedeci = NULL;
    noviCvor->nivo = 0;

    return noviCvor;
}


void dodajSina(Cvor* roditelj, Cvor* sin) {
    roditelj->broj_sinova++;
    
    roditelj->sinovi = (Cvor**)realloc(roditelj->sinovi, roditelj->broj_sinova * sizeof(Cvor*));
  
    
    roditelj->sinovi[roditelj->broj_sinova - 1] = sin;
}