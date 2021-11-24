#!/bin/bash

declare -A numTesteAtual
declare -A statusQuestao

#bg: 40 a 47, 100 a 107
#0;fg;bg
vermelho='\033[0;31m'
verde='\033[0;32m'
normal='\033[0m'
azul='\033[0;36m'
corProblema='\033[1;97;44m'

args=("$@")
ls $1
avaliar () {
	file=${args[0]}$1
	if ! [ -n "${numTesteAtual[$1]}" ]; then
		echo -e "${corProblema}              problema $1            ${normal}"
	fi
	numTesteAtual[$1]=$((numTesteAtual[$1]+1))
	if [ -f $file.c ]; then
		if [ ! -f exec$1 ]; then
			arq=$file.c
			if command -v file &> /dev/null && command -v iconv &> /dev/null; then
				charset="$(file -bi "$file.c" | awk -F "=" '{print $2}')"
				if [ "$charset" != utf-8 ]; then
					iconv -f "$charset" -t utf8 "$file.c" -o tmp.c
					arq=tmp.c
				fi
			fi
			if ! gcc "$arq" -o exec$1 -lm  2> /dev/null; then
				if ! [ -n "${statusQuestao[$1]}" ]; then
					statusQuestao[$1]='código '$file.c' não compila'
					echo -e "${vermelho} ${statusQuestao[$1]} ${normal}"
				fi
			fi
		fi
		echo -e "$2" > input
		echo -e "$3" > gabarito
		if [ -f exec$1 ]; then
			timeout 2 ./exec$1 < input > output
			printf 'Teste %d: ' ${numTesteAtual[$1]}
			if ! diff -wB output gabarito > /dev/null; then
				echo -e "${vermelho} [x]${normal}"
				echo -e '\tEntrada:' "${azul} $2 ${normal}"
				echo -e '\tSaída do seu programa:' "${azul} $(cat output) ${normal}"
				echo -e '\tSaída esperada       :' "${azul} $3 ${normal}"
			else
				echo -e "${verde} [ok] ${normal}"
			fi
		fi
	else
		if ! [ -n "${statusQuestao[$1]}" ]; then
			statusQuestao[$1]='código '$file.c' não existe'
			echo -e "${vermelho} ${statusQuestao[$1]} ${normal}"
		fi
	fi
}

if [ -e tmp.c ]; then echo "Existe um diretório/arquivo tmp.c, abortando"; exit 1; fi
if [ -e gabarito ]; then echo "Existe um diretório/arquivo gabarito, abortando"; exit 1; fi
if [ -e input ]; then echo "Existe um diretório/arquivo input, abortando"; exit 1; fi
if [ -e output ]; then echo "Existe um diretório/arquivo output, abortando"; exit 1; fi


avaliar 'q2a' '3' '6'
avaliar 'q2a' '10' '55'
avaliar 'q2a' '20' '210'
avaliar 'q2a' '100' '5050'

avaliar 'q2b' 'a' 'b'
avaliar 'q2b' 'p' 'q'
avaliar 'q2b' 'r' 's'
avaliar 'q2b' 't' 'u'
avaliar 'q2b' 'P' 'Q'
avaliar 'q2b' 'R' 'S'
avaliar 'q2b' 'B' 'C'
avaliar 'q2b' 'z' 'a'
avaliar 'q2b' 'Z' 'A'

avaliar 'q2c' '3' 'numero'
avaliar 'q2c' '8' 'numero'
avaliar 'q2c' 'a' 'letra minuscula'
avaliar 'q2c' 'k' 'letra minuscula'
avaliar 'q2c' 'u' 'letra minuscula'
avaliar 'q2c' 'z' 'letra minuscula'
avaliar 'q2c' 'A' 'letra maiuscula'
avaliar 'q2c' 'K' 'letra maiuscula'
avaliar 'q2c' 'U' 'letra maiuscula'
avaliar 'q2c' 'Z' 'letra maiuscula'

avaliar 'q2d' '1 10' '4'
avaliar 'q2d' '40 90' '12'
avaliar 'q2d' '300 500' '33'
avaliar 'q2d' '300 700' '63'
avaliar 'q2d' '1 500' '95'
avaliar 'q2d' '501 1000' '73'
avaliar 'q2d' '1 1000' '168'

avaliar 'q2e' '15 1 1955' '15 de janeiro de 1955'
avaliar 'q2e' '19 2 2103' '19 de fevereiro de 2103'
avaliar 'q2e' '7 3 1900' '7 de marco de 1900'
avaliar 'q2e' '1 4 1942' '1 de abril de 1942'
avaliar 'q2e' '30 5 1812' '30 de maio de 1812'
avaliar 'q2e' '12 6 1995' '12 de junho de 1995'
avaliar 'q2e' '27 7 1993' '27 de julho de 1993'
avaliar 'q2e' '11 8 1975' '11 de agosto de 1975'
avaliar 'q2e' '13 9 1500' '13 de setembro de 1500'
avaliar 'q2e' '22 10 1912' '22 de outubro de 1912'
avaliar 'q2e' '20 11 2002' '20 de novembro de 2002'
avaliar 'q2e' '31 12 1999' '31 de dezembro de 1999'

avaliar 'q3a' '30 20 8' '3'
avaliar 'q3a' '60.0 40.0 11' '4'
avaliar 'q3a' '100.0 95.0 7.0' '7'
avaliar 'q3a' '10 10 10' '1'
avaliar 'q3a' '10 10 15' '0'

avaliar 'q3b' '220 284' 'S'
avaliar 'q3b' '284 220' 'S'
avaliar 'q3b' '1184 1210' 'S'
avaliar 'q3b' '2620 2924' 'S'
avaliar 'q3b' '12285 14595' 'S'
avaliar 'q3b' '500 800' 'N'
avaliar 'q3b' '45 92' 'N'
avaliar 'q3b' '93 95' 'N'
avaliar 'q3b' '100 30' 'N'
avaliar 'q3b' '924 327' 'N'

avaliar 'q4' '0.9 2.53 1.53 1.73 1.42 0.77 1.58 0.57 1.42 0.68 1.15 0.04 1.98 -1.34 0.45 -0.83 1.25 -0.29 1.31 -0.86' '97'
avaliar 'q4' '-1.74 1.65 0.1 -1.21 -0.21 1.17 0.9 4.37 1.38 1.6 -1.93 2.52 1.76 0.78 1.13 -0.4 -2.84 -1.37 -2.71 0.32' '46'
avaliar 'q4' '2.5 5.01 4.89 3.62 4.12 2.78 6.03 -2.01 6.97 -1.72 4.85 -2.4 3.42 -1.08 -4.56 -2.42 -5.35 -2.25 -0.5 1.01' '26'
avaliar 'q4' '-2.2 -0.86 -3.91 1.35 -2.12 3.36 -1.43 0.9 -0.9 1.75 0.05 -1.94 3.74 1.38 0.42 -3.69 2.35 -2.06 -1.24 -4.5' '33'
avaliar 'q4' '-2.8 0.7 -2.83 1.94 -2.78 1.89 -1.74 0.9 -2.02 1.99 -1.76 1.69 -0.58 1.35 -1.63 1.24 -1.54 0.99 -1.64 0.32' '75'
avaliar 'q4' '1.85 -2.3 1.28 -2.9 0.93 -1.79 0.15 0.13 0.43 -0.35 0.34 -0.58 0.38 0.02 -0.63 0.77 -0.82 1.8 -1.61 1.14' '104'
avaliar 'q4' '-2.59 -0.53 -2.36 0.34 -2.54 0.65 -2.3 -0.56 -2.16 0.09 -2.04 -0.23 -0.95 1.36 -0.0 0.96 -0.29 0.43 -0.41 1.07' '95'

rm tmp.c gabarito input output exec* 2> /dev/null
