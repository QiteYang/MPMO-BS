function Archive = UpdateArchive(Archive,N,W)
Choose = Selection(Archive.objs,W,N);
Archive = Archive(Choose);
end

function Choose = Selection(ArcObj,W,NA)
[Na,M] = size(ArcObj);
[NW,~] = size(W);
%% Normalization
% Detect the extreme points
Extreme = zeros(1,M);
w       = zeros(M)+1e-6+eye(M);
for i = 1 : M
    [~,Extreme(i)] = min(max(ArcObj./repmat(w(i,:),Na,1),[],2));
end
% Calculate the intercepts of the hyperplane constructed by the extreme
% points and the axes
Hyperplane = ArcObj(Extreme,:)\ones(M,1);
a = 1./Hyperplane;
if any(isnan(a))
    a = max(ArcObj,[],1)';
end
% Normalization
ArcObj = ArcObj./repmat(a',Na,1);

%% Associate each solution with one reference point
% Calculate the distance of each solution to each reference vector
Cosine   = 1 - pdist2(ArcObj,W,'cosine');
Distance = repmat(sqrt(sum(ArcObj.^2,2)),1,NW).*sqrt(1-Cosine.^2);
% Associate each solution with its nearest reference point
[d,pi] = min(Distance',[],1);

Rset = zeros(1,NW);
Kset = zeros(1,NW);
Choose = [];
while length(Choose) < NA
    loc = find(Rset == min(Rset));
    if length(loc) > 1   % there are multiple reference lines have minimum count
        if sum(Kset) == 0 % K is empty
            Kset(loc(unidrnd(size(loc)))) = 1;
        end
        locK = find(Kset == 1);
        dq = sum(pdist2(W(loc,:),W(locK,:)),2);
        [~,r] = max(dq);
    else % only one reference line have minimum count
        r = 1;
    end
    Kset(loc(r)) = 1;   % r is added into K
    solutions = find(pi == loc(r));  % all solutions that associate with r
    if ~isempty(solutions)
        [~,selected] = min(d(solutions));
        Choose = [Choose,solutions(selected)];
    else
        [~,select_in_A] = min(Distance(:,loc(r)));
        Choose = [Choose,select_in_A];
    end
    Rset(loc(r)) = Rset(loc(r)) + 1;
end
end