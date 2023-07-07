function SubPop = Reallocate(Population,M,nP)
        N = length(Population);
        Objs = Population.objs;
        %% reallocate each solution into different subpop
        Niche = zeros(M,nP);
        NicheNum = ones(1,M);  %每个niche个体数
        Temp = N;
        Tag = zeros(1,N);
        % 依次将种群中i维最小的个体加入niche i
        while Temp > 0
            for i = 1 : M
                if Temp > 0
                    [~,loc] = find(Tag==0);
                    %[~,loc1] = max(Objs(loc,i));
                    [~,loc1] = min(Objs(loc,i));
                    loc = loc(loc1);
                    Niche(i,NicheNum(i)) = loc;
                    NicheNum(i) = NicheNum(i) + 1;
                    Tag(loc) = 1;
                    Temp = Temp - 1;
                end
            end
        end
        SubPop = {};
        for i = 1 : M
            pop = Niche(i,:);
            pop(find(pop==0))=[];   %niche中所有个体在种群的位置
            SubPop{i} = Population(pop);
        end
end