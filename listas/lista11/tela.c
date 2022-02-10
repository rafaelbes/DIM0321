#include <stdio.h>
#include <stdlib.h>
#include "tela.h"
#include "cor.h"

Tela criarTela(int largura, int altura) {
	Tela t;
	t.canvas.p1.x = 0;
	t.canvas.p1.y = altura;
	t.canvas.p2.x = largura;
	t.canvas.p2.y = 0;
	t.size = 10;
	t.n = 0;
	t.v = malloc(sizeof(Retangulo)*t.size);
	return t;
}

void adicionarRetangulo(Tela *t, Retangulo r) {
	if(t->n+1 > t->size) {
		t->size *= 2;
		t->v = realloc(t->v, sizeof(Retangulo)*t->size);
	}
	t->v[t->n++] = r;
}

void criarImagem(Tela t) {
	FILE *arq;
	arq = fopen("imagem.ppm", "w");
	int w = (int) t.canvas.p2.x;
	int h = (int) t.canvas.p1.y;
	fprintf(arq, "P3\n%d %d\n255\n", w, h);
	Cor **img;
	img = malloc(sizeof(Cor *)*h);
	for(int i = 0; i < h; i++)
		img[i] = malloc(sizeof(Cor)*w);
	for(int i = 0; i < h; i++)
		for(int j = 0; j < w; j++) {
			Cor c = {255, 255, 255};
			img[i][j] = c;
		}
	for(int i = 0; i < t.n; i++) {
		printf("Rendering %d at (%f %f %f %f)\n", i, t.v[i].p1.x, t.v[i].p1.y, t.v[i].p2.x, t.v[i].p2.y);
		for(int y = t.v[i].p2.y; y <= t.v[i].p1.y; y++)
			for(int x = t.v[i].p1.x; x <= t.v[i].p2.x; x++) {
				Cor c = {t.v[i].cor.r, t.v[i].cor.g, t.v[i].cor.b};
				img[h-y-1][x] = c;
			}
	}
	for(int i = 0; i < h; i++) {
		for(int j = 0; j < w; j++) {
			Cor c = img[i][j];
			fprintf(arq, "%d %d %d ", c.r, c.g, c.b);
		}
		fprintf(arq, "\n");
	}
	fclose(arq);
}

