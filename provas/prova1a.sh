#!/bin/bash

declare -A sumarioAcertos
declare -A sumarioTotal
declare -A sumarioStatus
vermelho='\033[0;31m'
verde='\033[0;32m'
normal='\033[0m'
azul='\033[0;36m'
amarelo='\033[46m'

args=("$@")
avaliar () {
	file=$1
	if [ ! -z ${args[0]} ] && [ ! ${args[0]} == $1 ]; then
		return 1
	fi
	if ! [ -n "${sumarioTotal[$1]}" ]; then
		echo -e "${amarelo}              problema $1            ${normal}"
	fi
	sumarioTotal[$1]=$((sumarioTotal[$1]+1))
	if ! [ -n "${sumarioAcertos[$1]}" ]; then
		sumarioAcertos[$1]=0
	fi
	if [ -f $file.c ]; then
		if [ ! -f exec$file ]; then
			charset="$(file -bi "$file.c" | awk -F "=" '{print $2}')"
			arq=$file.c
			if [ "$charset" != utf-8 ]; then
				iconv -f "$charset" -t utf8 "$file.c" -o tmp.c
				arq=tmp.c
			fi
			if ! gcc $arq -o exec$file -lm  2> /dev/null; then
				sumarioStatus[$1]='código '$file.c' não compila'
			fi
		fi
		echo -e "$2" > input
		echo -e "$3" > gabarito
		if [ -f exec$file ]; then
			timeout 2 ./exec$file < input > output
			printf 'Teste %d: ' ${sumarioTotal[$1]}
			if ! diff -wB output gabarito > /dev/null; then
				echo -e "${vermelho} [x]${normal}"
				echo -e '\tEntrada:' "${azul} $2 ${normal}"
				echo -e '\tSaída do seu programa:' "${azul} $(cat output) ${normal}"
				echo -e '\tSaída esperada:' "${azul} $3 ${normal}"
			else
				echo -e "${verde} [ok] ${normal}"
				sumarioAcertos[$1]=$((sumarioAcertos[$1]+1))
			fi
		fi
	else
		sumarioStatus[$1]='código '$file.c' não existe'
	fi
}

avaliar 'q1' '5 7 3 15' 'Episodios: A B C'
avaliar 'q1' '8 10 11 19' 'Episodios: A B'
avaliar 'q1' '8 10 3 19' 'Episodios: A B'
avaliar 'q1' '20 20 10 65' 'Episodios: A B C'
avaliar 'q1' '20 19 10 40' 'Episodios: A B'
avaliar 'q1' '30 30 30 20' 'Proximo sabado'
avaliar 'q1' '30 30 30 40' 'Episodios: A'
avaliar 'q1' '1 1 1 0' 'Proximo sabado'
avaliar 'q1' '1 1 1 3' 'Episodios: A B C'
avaliar 'q1' '1 1 1 2' 'Episodios: A B'
avaliar 'q1' '1 1 1 1' 'Episodios: A'
avaliar 'q1' '15 1 3 14' 'Proximo sabado'
avaliar 'q1' '120 100 5 200' 'Episodios: A'
avaliar 'q1' '120 80 4 201' 'Episodios: A B'
avaliar 'q1' '120 80 120 400' 'Episodios: A B C'

avaliar 'q2' '10 1 1 1 1 1 1 1 1 1 1' 'S'
avaliar 'q2' '10 1 1 1 1 1 2 2 2 2 2' 'S'
avaliar 'q2' '10 1 1 1 1 1 6 6 6 6 6' 'N'
avaliar 'q2' '8 1 2 3 4 5 6 1 2' 'N'
avaliar 'q2' '30 4 5 6 6 3 6 5 2 1 3 5 2 2 4 3 2 1 2 4 3 4 2 4 3 6 2 1 5 4 6' 'N'
avaliar 'q2' '30 4 5 1 1 1 6 5 2 1 3 1 1 1 1 3 2 1 2 4 1 1 2 4 3 6 2 1 5 4 6' 'S'
avaliar 'q2' '40 1 4 5 6 1 3 2 2 2 3 3 3 5 2 3 1 1 2 5 4 4 3 6 4 3 5 3 3 5 5 4 5 4 1 2 5 1 2 3 6' 'N'
avaliar 'q2' '40 2 3 2 3 1 4 1 3 2 5 2 1 6 4 1 3 1 2 4 4 3 5 1 4 5 5 3 1 3 3 1 2 4 6 1 1 2 2 1 4' 'S'
avaliar 'q2' '50 2 1 1 5 4 2 6 6 1 5 1 1 4 5 4 4 3 5 4 1 2 6 2 1 5 4 3 5 2 2 2 1 1 1 4 6 5 3 4 2 5 2 3 6 6 6 4 6 4 4' 'N'
avaliar 'q2' '50 6 6 1 5 6 2 4 1 2 1 3 2 1 3 1 2 5 6 5 5 5 1 5 4 6 3 3 1 5 4 3 3 4 5 4 4 5 4 4 6 4 3 2 3 5 4 5 1 1 6' 'N'

avaliar 'q3' '3 4 5 2 3 0' '2 3'
avaliar 'q3' '7 2 2 2 0' '3 1'
avaliar 'q3' '1 0' '0 1'
avaliar 'q3' '2 0' '1 0'
avaliar 'q3' '12 20 30 20 10 5 7 8 0' '6 2'
avaliar 'q3' '3 7 17 19 31 33 20 10000 0' '2 6'
avaliar 'q3' '0' '0 0'
avaliar 'q3' '97 42 87 48 42 42 36 48 19 66 27 82 24 24 72 88 49 7 43 12 22 81 18 45 1 6 71 50 14 93 71 36 69 77 42 77 20 79 90 84 24 37 21 13 48 7 73 12 45 19 15 39 46 60 68 41 94 44 32 9 4 82 19 66 84 20 8 3 76 67 90 42 70 79 10 25 44 55 62 44 35 34 80 17 64 45 52 42 47 13 24 70 84 72 13 29 40 3 6 23 0' '57 43'

rm tmp.c gabarito input output exec* 2> /dev/null
