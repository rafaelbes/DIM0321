#ifndef TELA_H
#define TELA_H

#include "retangulo.h"

typedef struct Tela {
	Retangulo canvas;
	Retangulo *v;
	int n;
	int size;
} Tela;

Tela criarTela(int largura, int altura);
void adicionarRetangulo(Tela *t, Retangulo r);
void criarImagem(Tela t);

#endif

