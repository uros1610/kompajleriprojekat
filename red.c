#include <stdio.h>
#include <stdlib.h>
#include "cvor.h"
#include "red.h"

void inicijalizujRed(struct Red* red) {
    red->glava = 0;
    red->rep = 0;
}

void dodajURed(struct Red* red, struct Cvor* cvor) {

     if (red->glava == NULL) {
        red->glava = cvor;
        red->rep = cvor;
    } else {
        red->rep->sljedeci = cvor;
        red->rep = cvor;
    }
    
}

struct Cvor* ukloniSPocetka(struct Red* red) {
    if(red == 0) {
        return 0;
    }
    else {
        struct Cvor* tmp = red->glava;
        red->glava = red->glava->sljedeci;

        if(red->glava == 0) {
            red->rep = 0;
        }

        return tmp;

    }
}