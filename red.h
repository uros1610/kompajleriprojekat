#ifndef RED_H
#define RED_H


struct Red {
    struct Cvor* glava;
    struct Cvor* rep;    
};

void dodajURed(struct Red* red,struct Cvor* cvor);
struct Cvor* ukloniSPocetka(struct Red* red);

void inicijalizujRed(struct Red* red);

#endif /* CVOR_H */
