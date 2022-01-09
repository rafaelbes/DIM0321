
#include <stdio.h>

int main() {

	char m[20][21];
	int n; //numero de linhas
	int c; //numero de colunas
	int x, y; //local que sera checado

	scanf("%d", &n);
	for(int i = 0; i < n; i++) {
		scanf("%s", &m[i][0]);
		c = strlen(m[i]); //assume-se igual para todas as linhas
	}

	scanf("%d %d", &y, &x);

	//verificar se eh bomba, caso contrario contar e exibir
	//quantas bombas ha nas adjacencias

	return 0;
}

