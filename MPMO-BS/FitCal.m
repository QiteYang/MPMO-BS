function Fitness = FitCal(PopObj,FrontNo,Type,objk)
if Type == 1
    PopObj(:,objk) = [];
end

PopObj = PopObj - min(PopObj,[],1) + 10e-6;

%% fitness calculation
MaxNo = max(FrontNo);
Fitness = zeros(1,length(FrontNo));
for k = 1 : MaxNo
    Loc = find(FrontNo == k);
    [N,M] = size(PopObj(Loc,:));
    obj = PopObj(Loc,:);
    cv = inf(N,N);
    for i = 1 : N
        for j = [1:i-1,i+1: N]
            cv(j,i) = max(obj(j,:)./obj(i,:));
        end
    end
    if N == 1
        cv = 0;
    end
    Fitness(Loc) = min(cv,[],1);
end

end