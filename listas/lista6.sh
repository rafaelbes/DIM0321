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

avaliar 'q1'  '..xxx.x..x 0' '0'
avaliar 'q1'  '..xxx.x..x 1' '1'
avaliar 'q1'  '..xxx.x..x 5' '2'
avaliar 'q1'  '..xxx.x..x 4' 'bum!'
avaliar 'q1'  '..xxx.x..x 9' 'bum!'
avaliar 'q1'  '..xxx.x..x 8' '1'
avaliar 'q1'  'x 0' 'bum!'
avaliar 'q1'  '. 0' '0'
avaliar 'q1'  '.x 1' 'bum!'
avaliar 'q1'  'x. 1' '1'
avaliar 'q1'  '.x 0' '1'
avaliar 'q1'  '.. 1' '0'

avaliar 'q2'  'teste algo' 'taelsgtoe'
avaliar 'q2'  'asa inconstitucionalidade' 'aisnaconstitucionalidade'
avaliar 'q2'  'rslao eutd' 'resultado'
avaliar 'q2'  'rslao eutds' 'resultados'
avaliar 'q2'  'abc defghi' 'adbecfghi'
avaliar 'q2'  'defghi abc' 'daebfcghi'

avaliar 'q3'  'Esta eh uma string' 'E574 3h um4 57r1ng'
avaliar 'q3'  'Ando devagar porque ja tive pressa' 'Ando d3v4g4r porqu3 j4 71v3 pr3554'
avaliar 'q3'  'Sao Paulo eh a capital de Sao Paulo' 'S4o P4ulo 3h 4 c4p174l d3 S4o P4ulo'

avaliar 'q4'  'Quantas palavras ha nessa frase?' '5'
avaliar 'q4'  'Esta-eh-uma str:ng' '2'
avaliar 'q4'  'Este eh um ponto .' '5'
avaliar 'q4'  'Um exemplo um pouco mais longo e com mais palavras' '10'
avaliar 'q4'  'Teste com espaco no fim ' '5'
avaliar 'q4'  ' Teste com espaco no comeco' '5'
avaliar 'q4'  ' Teste com espaco no comeco e no fim ' '8'
avaliar 'q4'  ' ' '0'
avaliar 'q4'  ' ' '0'
avaliar 'q4'  ' 1 ' '1'

avaliar 'q5'  'AAA-0000' 'S'
avaliar 'q5'  'RWX-2392' 'S'
avaliar 'q5'  'DAX-9384' 'S'
avaliar 'q5'  'ZQE-8938' 'S'
avaliar 'q5'  'RWX-8381' 'S'
avaliar 'q5'  'CWX-4999' 'S'
avaliar 'q5'  'FDX-0002' 'S'
avaliar 'q5'  'GRE-0000' 'S'
avaliar 'q5'  'AWH-1230' 'S'
avaliar 'q5'  'DWC-5727' 'S'
avaliar 'q5'  'ZZZ-9999' 'S'
avaliar 'q5'  'AAA-00200' 'N'
avaliar 'q5'  'RAWX-2392' 'N'
avaliar 'q5'  'DAX--9384' 'N'
avaliar 'q5'  'ZE-8938' 'N'
avaliar 'q5'  'RWX-881' 'N'
avaliar 'q5'  'CWX4999' 'N'
avaliar 'q5'  '3929-FDX' 'N'
avaliar 'q5'  'G3F9X-32' 'N'
avaliar 'q5'  '-AFS3292' 'N'
avaliar 'q5'  '--------' 'N'
avaliar 'q5'  'A-3' 'N'
avaliar 'q5'  '-ASE3213' 'N'
avaliar 'q5'  '238-2321' 'N'
avaliar 'q5'  'SD2-D232' 'N'
avaliar 'q5'  '1D2-D2F2' 'N'
avaliar 'q5'  'AAA-0000AAA-0000' 'N'

avaliar 'q6'  '35-0' 'S'
avaliar 'q6'  '35-2' 'N'
avaliar 'q6'  '35-7' 'N'
avaliar 'q6'  '35-5' 'N'
avaliar 'q6'  '35-1' 'N'
avaliar 'q6'  '35-00' 'N'
avaliar 'q6'  '35-' 'N'
avaliar 'q6'  '08-3' 'S'
avaliar 'q6'  '74-5' 'S'
avaliar 'q6'  '41-4' 'S'
avaliar 'q6'  '33-1' 'S'
avaliar 'q6'  '00-0' 'S'
avaliar 'q6'  '65-6' 'S'
avaliar 'q6'  '17-2' 'S'
avaliar 'q6'  '08-5' 'N'
avaliar 'q6'  '74-4' 'N'
avaliar 'q6'  '41-1' 'N'
avaliar 'q6'  '33-0' 'N'
avaliar 'q6'  '00-4' 'N'
avaliar 'q6'  '65-2' 'N'
avaliar 'q6'  '08-3!' 'N'
avaliar 'q6'  '74-55' 'N'
avaliar 'q6'  '412-4' 'N'
avaliar 'q6'  '331-1' 'N'
avaliar 'q6'  '0--0' 'N'
avaliar 'q6'  '6544' 'N'
avaliar 'q6'  '654-' 'N'
avaliar 'q6'  '08-308-3' 'N'
avaliar 'q6'  '08-3a' 'N'

avaliar 'q7'  '3491' '3491'
avaliar 'q7'  '0001k-jt3' '13'
avaliar 'q7'  '-gm12' '-12'
avaliar 'q7'  '52a3' '523'
avaliar 'q7'  '-3299' '-3299'
avaliar 'q7'  '--3299' '-3299'
avaliar 'q7'  '-' '0'
avaliar 'q7'  'asd' '0'
avaliar 'q7'  '99922' '99922'
avaliar 'q7'  'd93kf23' '9323'

avaliar 'q8'  'tes100te' '3'
avaliar 'q8'  'as1tri2g' '2'
avaliar 'q8'  'os9fg8wk2f' '3'
avaliar 'q8'  'a0w9r8t3235z' '7'
avaliar 'q8'  'sX84xakoc0Gsk3kxj8e' '5'
avaliar 'q8'  'qfV0nlIYqE0K2FWtMa9' '4'
avaliar 'q8'  'VzgVp0aXDana1MNjSDC' '2'
avaliar 'q8'  'Z74K4mROWnfSSvS4e12' '6'
avaliar 'q8'  'pVA4a9Z86CGnIJO' '4'
avaliar 'q8'  'MmMPfwGbiujh' '0'
avaliar 'q8'  'Dvg6AIW0RpeV' '2'

avaliar 'q9'  'teste e p' 'tpstp'
avaliar 'q9'  'TraTativa T u' 'urauativa'
avaliar 'q9'  'sabia a o' 'sobio'
avaliar 'q9'  'palavra a i' 'pilivri'
avaliar 'q9'  'aaaab a c' 'ccccb'
avaliar 'q9'  'baaaa a c' 'bcccc'

rm tmp.c gabarito input output exec* 2> /dev/null
