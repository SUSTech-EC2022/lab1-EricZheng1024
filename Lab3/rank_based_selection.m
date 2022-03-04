function [prob_list] = rank_based_selection (fitness_list)
% 性能优化
    [~, rank] = sort(fitness_list);
    [~, rank] = sort(rank);  % rank 从 1 开始
    sum_rank = sum(rank);
    prob_list = rank / sum_rank;
end

% function [prob_list] = rank_based_selection (fitness_list)
% mu = length(fitness_list);
% sortedi = sort(fitness_list); 
% rank = nan(1,mu);
% for i = 1:mu
%      tmp = find(sortedi==fitness_list(i))-1;  % 可能有重复排名
%      rank(i) = tmp(1);
% end
% prob_list = nan(mu,1);
% sum_rank = sum(rank) + mu;
% for i = 1:mu
%     prob_list(i) = (rank(i)+1)/sum_rank;
% end
% end

