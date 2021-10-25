#include <stdio.h>

int main() {

	float peso, altura;
	float imc;
	printf("Digite o seu peso: ");
	scanf("%f", &peso);
	printf("Digite a sua altura: ");
	scanf("%f", &altura);
	imc = peso/(altura*altura);
	printf("O seu IMC eh: %f\n", imc);

	return 0;
}

