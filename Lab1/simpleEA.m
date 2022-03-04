function [bestSoFarFit ,bestSoFarSolution ...
    ]=simpleEA( ...  % name of your simple EA function
    fitFunc, ... % name of objective/fitness function
    T, ... % total number of evaluations
    input) % replace it by your input arguments

% Check the inputs
if isempty(fitFunc)
  warning(['Objective function not specified, ''' objFunc ''' used']);
  fitFunc = 'objFunc';
end
if ~ischar(fitFunc)
  error('Argument FITFUNC must be a string');
end
if isempty(T)
  warning(['Budget not specified. 1000000 used']);
  T = '1000000';
end
eval(sprintf('objective=@%s;',fitFunc));
% Initialise variables
nbGen = 0; % generation counter
nbEval = 0; % evaluation counter
bestSoFarFit = 0; % best-so-far fitness value  应根据问题上下界设置
bestSoFarSolution = NaN; % best-so-far solution
%recorders
fitness_gen=[]; % record the best fitness so far
solution_gen=[];% record the best phenotype of each generation
fitness_pop=[];% record the best fitness in current population 
%% Below starting your code

% Initialise a population
%% TODO
populationSize = 4;  % 种群大小
lowerBound = 0;  % 下界
upperBound = 1023;  % 上界
lenGene = 10;  % 二进制编码长度
population = randi([lowerBound,upperBound],populationSize,1);  % 表现型
genotypes = dec2bin(population);  % 基因型，字符串，效率应该比较低？

% Evaluate the initial population
%% TODO
fitness = objective(population);  % fitness与population一一对应；objective句柄通过前面eval产生
[A,index] = sort(fitness,1,'descend');  % 排序适应度值
fitness_pop=[fitness_pop,A(1)]  % print log
% ---------- modified ----------
% for i = 1:populationSize
%     if fitness(i) > bestSoFarFit
%         bestSoFarFit = fitness(i);
%         bestSoFarSolution = population(i,:);
%     end
% end
if fitness(index(1)) > bestSoFarFit
    bestSoFarFit = fitness(index(1));
    bestSoFarSolution = population(index(1),:);
end
% ---------- end ----------

nbEval = nbEval + populationSize;  % 初始化耗费函数评价次数
nbGen =  nbGen +1;
fitness_gen=horzcat(fitness_gen, bestSoFarFit);  % 等价于[fitness_gen, bestSoFarFit]
solution_gen=horzcat(solution_gen, bestSoFarSolution);  % 等价于[solution_gen, bestSoFarSolution]
% Start the loop
while (nbEval<T) % [QUESTION] this stopping condition is not perfect, why?  死板，浪费计算资源
% Reproduction (selection, crossver)
%% TODO
crossoverProb = fitness./sum(fitness);  % 个体被选中概率计算
offspringGenes = [];
for i = 1:populationSize/2  % 选择种群大小一半的父母对，进行交叉
    parentIndexes = [];
    for j = 1:2
        r = rand();
        for k = 1:populationSize
            if r>sum(crossoverProb(1:k-1)) && r<=sum(crossoverProb(1:k))  % roulette-wheel selection
                break;
            end
        end
        parentIndexes = [parentIndexes, k];
    end
    crossoverPoint = randi(lenGene-1);
    offspringGenes = [offspringGenes; [genotypes(parentIndexes(1),1:crossoverPoint), genotypes(parentIndexes(2),crossoverPoint+1:end)]];  % 单点交叉，父母产生的第一个个体
    offspringGenes = [offspringGenes; [genotypes(parentIndexes(2),1:crossoverPoint), genotypes(parentIndexes(1),crossoverPoint+1:end)]];  % 父母产生的第二个个体
end
% Mutation
%% TODO

mutationProb = 1/lenGene;  % 1 bit-flip
for i = 1:populationSize
    isMutation = rand(1,lenGene)<mutationProb;
    offspringGenes(i,isMutation) = dec2bin('1'-offspringGenes(i,isMutation))';
end
genotypes = offspringGenes;
% ---------- modified ----------
% population = bin2dec(genotypes);
% fitness = objective(population);
% 方法1，保留前四个，收敛更快，但容易陷入局部最优
population = [population; bin2dec(genotypes)];
fitness = objective(population);
[~,index] = sort(fitness,1,'descend');
population = population(index(1:populationSize));
fitness = fitness(index(1:populationSize));
% 方法2，只保留最优，其他随缘
% population = [population; bin2dec(genotypes)];
% fitness = objective(population);
% [~,index] = max(fitness,[],1);
% r = randi(populationSize*2,1,populationSize-1);
% population = [population(index(1)); population(r)];
% fitness = [fitness(index(1)); fitness(r)];
% 方法4，保留前四个适应度高且表现型不同的
% ...
% ---------- end ----------
[A,index] = sort(fitness,1,'descend');
fitness_pop=[fitness_pop,A(1)]
% ---------- modified ----------
% for i = 1:populationSize
%     if fitness(i) > bestSoFarFit
%         bestSoFarFit = fitness(i);
%         bestSoFarSolution = population(i,:);
%     end
% end
if fitness(index(1)) > bestSoFarFit
    bestSoFarFit = fitness(index(1));
    bestSoFarSolution = population(index(1),:);
end
% ---------- end ----------
nbEval = nbEval + populationSize;
nbGen = nbGen + 1;
fitness_gen=horzcat(fitness_gen, bestSoFarFit);
solution_gen=horzcat(solution_gen, bestSoFarSolution);
end
bestSoFarFit
bestSoFarSolution

figure,plot(1:nbGen,fitness_gen,'b')  % 迄今为止最优个体（区分种群中最优个体，种群中最优个体会流失）
title('Fitness\_Gen')

figure,plot(1:nbGen,solution_gen,'b')  % 迄今为止最优表现型的值
title('Solution\_Gen')

figure,plot(1:nbGen,fitness_pop,'b')  % 每一代种群最优值
title('Fitness\_Pop')



