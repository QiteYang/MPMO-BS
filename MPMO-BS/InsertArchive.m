function Archive = InsertArchive(Archive,Input)
% insert non-dominated solutions into the archive
if isempty(Archive)
    Archive = Input;
else
    
    %% Non-dominated solutions determining
%     Input = [Archive,Input];
%     N = length(Input);
%     Archive = [];
%     for i = 1 : N
%         flag = true;
%         for j = 1 : N
%             if j ~= i
%                 isDom = any(Input(j).obj<Input(i).obj)-any(Input(j).obj>Input(i).obj);
%                 if isDom == 1  % j dominates i
%                     flag = false;
%                     break;
%                 end
%             end
%         end
%         if flag == true
%             Archive = [Archive,Input(i)];
%         end
%     end
    
    %% Using NDSort to insert the first front solutions
    Archive = [Archive,Input];
    FrontNo = NDSort(Archive.objs,inf);
    Archive = Archive(FrontNo==1);


end
end