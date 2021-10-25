#include <stdio.h>
#include <math.h>

int main() {

	//coordenada do robo
	float x0, y0;
	//coordenada da bomba
	float x1, y1;

	//raio de explosao da bomba
	float r = 3;
	//distancia entre o robo e a bomba
	float d;

	printf("Digite a coordenada do robo: ");
	scanf("%f %f", &x0, &y0);
	printf("Digite a coordenada da bomba: ");
	scanf("%f %f", &x1, &y1);

	d = sqrt((x0-x1)*(x0-x1) + pow(y0 - y1, 2));

	printf("O robo vai sofrer dano: %d\n", d <= r);

	return 0;
}

