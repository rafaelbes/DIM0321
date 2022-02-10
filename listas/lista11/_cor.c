#include <stdlib.h>
#include <stdio.h>
#include <time.h>

struct Cor {
	int r, g, b;
};

typedef struct Cor Cor;

void alterarCor(Cor *ptr, int r, int g, int b) {
	ptr->r = r;
	ptr->g = g;
	ptr->b = b;
	if(ptr->r < 0)
		ptr->r = 0;
	if(ptr->g < 0)
		ptr->g = 0;
	if(ptr->b < 0)
		ptr->b = 0;
	if(ptr->r > 255)
		ptr->r = 255;
	if(ptr->g > 255)
		ptr->g = 255;
	if(ptr->b > 255)
		ptr->b = 255;
}

void printCor(Cor x) {
	printf("cor (%d, %d, %d)\n", x.r, x.g, x.b);
}

Cor obterBranco() {
	Cor res = {255, 255, 255};
	return res;
}

Cor obterAzul() {
	Cor res = {0, 0, 255};
	return res;
}

void escurecer(Cor *ptr) {
	alterarCor(ptr, ptr->r - 10, ptr->g - 10, ptr->b - 10);
}

void clarear(Cor *ptr) {
	alterarCor(ptr, ptr->r + 10, ptr->g + 10, ptr->b + 10);
}

Cor corAleatoria() {
	Cor res;
	res.r = rand()%255;
	res.g = rand()%255;
	res.b = rand()%255;
	return res;
}

int main() {

	Cor c1 = {120, 80, 140};

	srand(time(NULL));

	printf("Cor c1 antes da alteracao: ");
	printCor(c1);
	alterarCor(&c1, 200, -20, 300);
	printf("Cor c1 depois da alteracao: ");
	printCor(c1); //deve escrever 200, 0, 255

	Cor azul = obterAzul();
	printf("Azul: ");
	printCor(azul);

	Cor branco = obterBranco();
	printf("Branco: ");
	printCor(branco);

	for(int i = 0; i < 5; i++) {
		printf("Branco mais escuro: ");
		escurecer(&branco);
		printCor(branco);
	}

	printf("c1 antes do clareamento: ");
	printCor(c1);
	clarear(&c1);
	printf("c1 depois do clareamento: ");
	printCor(c1);

	Cor *v; //ponteiro para cor
	int n, i;

	srand(time(NULL));

	printf("Digite a quantidade de cores: ");
	scanf("%d", &n);

	v = malloc(sizeof(Cor)*n);

	for(i = 0; i < n; i++)
		v[i] = corAleatoria();

	for(i = 0; i < n; i++) {
		printf("Cor #%d: ", i);
		printCor(v[i]);
	}

	free(v);


	return 0;
}
