clc; clear all;
delete compare10runs.diary;
diary  compare10runs.diary;
tic

run01_97 = importdata('y97_t0_16/HetAsvabBackgroundAllBinnedSchInt/results.csv');
run02_97 = importdata('y97_t0_16/HetAsvabBackgroundAllBinnedSchIntFromPvs/results.csv');
run03_97 = importdata('y97_t0_16/Het1Load03/results.csv');
run04_97 = importdata('y97_t0_16/Het1Load04/results.csv');
run05_97 = importdata('y97_t0_16/Het1Load05/results.csv');
run06_97 = importdata('y97_t0_16/Het1Load06/results.csv');
run07_97 = importdata('y97_t0_16/Het1Load07/results.csv');
run08_97 = importdata('y97_t0_16/Het1Load08/results.csv');
run09_97 = importdata('y97_t0_16/Het1Load09/results.csv');
run10_97 = importdata('y97_t0_16/Het1Load10/results.csv');

run01_79 = importdata('y79_t0_16/HetAsvabBackgroundAllBinnedSchInt/results.csv');
run02_79 = importdata('y79_t0_16/HetAsvabBackgroundAllBinnedSchIntFromPvs/results.csv');
run03_79 = importdata('y79_t0_16/Het1Load03/results.csv');
run04_79 = importdata('y79_t0_16/Het1Load04/results.csv');
run05_79 = importdata('y79_t0_16/Het1Load05/results.csv');
run06_79 = importdata('y79_t0_16/Het1Load06/results.csv');
run07_79 = importdata('y79_t0_16/Het1Load07/results.csv');
run08_79 = importdata('y79_t0_16/Het1Load08/results.csv');
run09_79 = importdata('y79_t0_16/Het1Load09/results.csv');
run10_79 = importdata('y79_t0_16/Het1Load10/results.csv');

like79 = [
run01_79(end,1) 
run02_79(end,1) 
run03_79(end,1) 
run04_79(end,1) 
run05_79(end,1) 
run06_79(end,1) 
run07_79(end,1) 
run08_79(end,1) 
run09_79(end,1) 
run10_79(end,1) 
]

like97 = [
run01_97(end,1) 
run02_97(end,1) 
run03_97(end,1) 
run04_97(end,1) 
run05_97(end,1) 
run06_97(end,1) 
run07_97(end,1) 
run08_97(end,1) 
run09_97(end,1) 
run10_97(end,1) 
]

asvab79 = [
run01_79(1681:1686,1)' 
run02_79(1681:1686,1)' 
run03_79(1681:1686,1)' 
run04_79(1681:1686,1)' 
run05_79(1681:1686,1)' 
run06_79(1681:1686,1)' 
run07_79(1681:1686,1)' 
run08_79(1681:1686,1)' 
run09_79(1681:1686,1)' 
run10_79(1681:1686,1)' 
]

wage79 = [
run01_79(1675:1680,1)' 
run02_79(1675:1680,1)' 
run03_79(1675:1680,1)' 
run04_79(1675:1680,1)' 
run05_79(1675:1680,1)' 
run06_79(1675:1680,1)' 
run07_79(1675:1680,1)' 
run08_79(1675:1680,1)' 
run09_79(1675:1680,1)' 
run10_79(1675:1680,1)' 
]

asvab97 = [
run01_97(1663:1668,1)' 
run02_97(1663:1668,1)' 
run03_97(1663:1668,1)' 
run04_97(1663:1668,1)' 
run05_97(1663:1668,1)' 
run06_97(1663:1668,1)' 
run07_97(1663:1668,1)' 
run08_97(1663:1668,1)' 
run09_97(1663:1668,1)' 
run10_97(1663:1668,1)' 
]

wage97 = [
run01_97(1657:1662,1)' 
run02_97(1657:1662,1)' 
run03_97(1657:1662,1)' 
run04_97(1657:1662,1)' 
run05_97(1657:1662,1)' 
run06_97(1657:1662,1)' 
run07_97(1657:1662,1)' 
run08_97(1657:1662,1)' 
run09_97(1657:1662,1)' 
run10_97(1657:1662,1)' 
]

toc
diary off;
