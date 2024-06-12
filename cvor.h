#ifndef CVOR_H
#define CVOR_H

struct Cvor {
    char* vrijednost;
    struct Cvor** sinovi;
    int broj_sinova;
    struct Cvor* sljedeci;
    int nivo;
    int tip;
};

typedef struct Cvor Cvor;

void dodajSina(Cvor* roditelj,Cvor* sin);
Cvor* kreirajCvor(char* vrijednost);

#endif /* CVOR_H */
