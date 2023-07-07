function [FrontNo,Type] = FrontCal(Population,k,Type)
Objs = Population.objs;
[N,M] = size(Objs);

%% bias sorting
front = zeros(M,N);
Obj_1 = Objs(:,k);
for i = 1 :M
    if i ~= k
        Obj_2 = Objs(:,i);
        Obj = [Obj_1,Obj_2];
        [front(i,:),~] = NDSort(Obj,N);
    end
end
front(k,:) = nan;
FrontNo = max(front,[],1);
[~, ~, forwardRank] = unique(FrontNo);
FrontNo = forwardRank.';

NDFront = NDSort(Objs,N);  % a archive which remain front with ND Sorting method

FirstFront = find(FrontNo == 1);
if length(FirstFront) >= 0.8*length(FrontNo) || Type == 2
    FrontNo = NDFront;
    Type = 2;
end

end