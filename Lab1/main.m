% note：modified部分 将原来的注释掉，写上自己的

clear, close all, clc

rng(2)

fitFunc = 'objFunc'; % name of objective/fitness function
T = 200; % total number of evaluations
[bestSoFarFit, bestSoFarSolution] = simpleEA(fitFunc, T);
