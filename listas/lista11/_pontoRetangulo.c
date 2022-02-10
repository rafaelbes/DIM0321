#include <math.h>
#include <stdio.h>

typedef struct Ponto {
	float x, y;
} Ponto;

typedef struct Retangulo {
	struct Ponto p1, p2;
} Retangulo;

float distanciaEuclidiana(Ponto p1, Ponto p2) {
	return sqrt((p1.x-p2.x)*(p1.x-p2.x) + (p1.y-p2.y)*(p1.y-p2.y));
}

float area(Retangulo r) {
	float dx = r.p2.x - r.p1.x;
	float dy = r.p1.y - r.p2.y;
	return dx*dy;
}

float perimetro(Retangulo r) {
	float dx = r.p2.x - r.p1.x;
	float dy = r.p1.y - r.p2.y;
	return 2*dx + 2*dy;
}

float comprimentoDiagonal(Retangulo r) {
	return distanciaEuclidiana(r.p1, r.p2);
}

void printRetangulo(Retangulo r) {
	printf("(%.02f, %.02f) -- (%.02f, %.02f)\n", r.p1.x, r.p1.y, r.p2.x, r.p2.y);
}

void inflar(Retangulo *r) {
	Ponto np1 = {r->p1.x-0.5, r->p1.y+0.5};
	Ponto np2 = {r->p2.x+0.5, r->p2.y-0.5};
	r->p1 = np1;
	r->p2 = np2;
}

int main() {

	Retangulo r;
	scanf("%f %f %f %f", &r.p1.x, &r.p1.y, &r.p2.x, &r.p2.y);
	printRetangulo(r);
	printf("%.2f %.2f\n", area(r), perimetro(r));
	inflar(&r);
	printRetangulo(r);
	printf("%.2f %.2f\n", area(r), perimetro(r));


	return 0;
}

