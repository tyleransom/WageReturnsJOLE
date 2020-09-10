#!/bin/sh
#$ -q all.q
#$ -S /bin/sh
#$ -N "BEA create"
#$ -cwd -j y
#$ -V
#$ -M tmr17@duke.edu -m e
/usr/local/stata11/stata-se -b do BEA_create.do
