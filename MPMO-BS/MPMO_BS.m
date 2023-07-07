classdef MPMO_BS < ALGORITHM
    % <multi> <real/binary/permutation> <constrained/none>
    % Q.-T. Yang, Z.-H. Zhan, S. Kwong, and J. Zhang,"Multiple Populations for Multiple Objectives Framework with
    % Bias Sorting for Many-objective Optimization," in IEEE Transactions on Evolutionary Computation, 2022, DOI:10.1109/TEVC.2022.3212058.
    
    methods
        function main(Algorithm,Problem)
            %% reference points
            [W,Problem.N] = UniformPoint(Problem.N,Problem.M);
            
            %% Generate random population
            Archive = [];
            nP = ceil(Problem.N /Problem.M); % number of solutions in each subpop
            Problem.N = nP*Problem.M;
            SubPop = cell(1,Problem.M);
            Fitness = cell(1,Problem.M);  % fitness of each subpop
            FrontNo = cell(1,Problem.M);  % front of each subpop
            Type = ones(1,Problem.M); % the type of sorting method used in each subpop
            
            %% Initilization
            for i = 1 : Problem.M
                SubPop{i} = Problem.Initialization(nP);
                [FrontNo{i},Type(i)] = FrontCal(SubPop{i},i,Type(i)); % sorting
                pop = SubPop{i};
                Fitness{i} = FitCal(pop.objs,FrontNo{i},Type(i),i); % ACF calculation
                Archive = InsertArchive(Archive,pop(FrontNo{i}==1)); % archive update
            end
            
            gen = 0;
            %% Optimization
            while Algorithm.NotTerminated(Archive)
                gen = gen + 1;
                %% convergence maintenace for each subpop
                for i = 1 : Problem.M
                    Pop = SubPop{i};
                    %% GA
                    Offspring = [];
                    for j = 1 : nP
                        MatingPool = TournamentSelection(2,2,FrontNo{i},Fitness{i});
                        offspring  = OperatorGAhalf(Pop(MatingPool));
                        Offspring = [Offspring,offspring];
                    end
                    [FrontNo{i},Type(i)] = FrontCal([Pop,Offspring],i,Type(i));
                    pop = [Pop,Offspring];
                    Fitness{i} = FitCal(pop.objs,FrontNo{i},Type(i),i);
                    [SubPop{i},FrontNo{i},Fitness{i}] = EnvironmentalSelection([Pop,Offspring],nP,FrontNo{i},Fitness{i});
                    pop = SubPop{i};
                    Archive = InsertArchive(Archive,pop);
                end
                
                %% ELS
                theta = 0.5;
                ArcDec = Archive.decs;
                [LenArc,~] = size(ArcDec);
                upper = Problem.upper;
                lower = Problem.lower;
                for i = 1 : ceil(0.5*LenArc)
                    id = unidrnd(Problem.D);
                    ArcDec(i,id) = ArcDec(i,id) + (upper(id)-lower(id))*normrnd(0,theta.^2);
                end
                ELS = SOLUTION(ArcDec);
                Archive = InsertArchive(Archive,ELS);
                
                %% diversity maintenance
                if length(Archive) > Problem.N
                    Archive = UpdateArchive(Archive,Problem.N,W);
                end
                
                %% population reallocation
                if length(Archive) == Problem.N
                    SubPop = Reallocate(Archive,Problem.M,nP);
                    for i = 1 : Problem.M
                        [FrontNo{i},Type(i)] = FrontCal(SubPop{i},i,Type(i));
                        pop = SubPop{i};
                        Fitness{i} = FitCal(pop.objs,FrontNo{i},Type(i),i);
                    end
                end
                
            end
        end
    end
end