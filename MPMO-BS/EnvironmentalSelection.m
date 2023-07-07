function [NewPop,frontno,fit] = EnvironmentalSelection(Population,N,FrontNo,Fitness)
   i = 1;
   n = 0;
   NewPop = [];
   fit = [];
   frontno = [];
   while n + length(find(FrontNo==i)) <= N
       n = n + length(find(FrontNo==i));
       NewPop = [NewPop,Population(FrontNo==i)];
       fit = [fit,Fitness(FrontNo==i)];
       frontno = [frontno,FrontNo(FrontNo==i)];
       i = i + 1;
   end
   Last = N - n;
   if Last > 0
       [~,Rank] = sort(Fitness(FrontNo==i),'descend');
       Next = Rank(1:Last);
       NextPop = Population(FrontNo==i);     
       NextFit = Fitness(FrontNo==i);
       NextFront = FrontNo(FrontNo==i);
       NewPop = [NewPop,NextPop(Next)];
       fit = [fit,NextFit(Next)];
       frontno = [frontno,NextFront(Next)];
   end
end