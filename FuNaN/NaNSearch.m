%--------------------------------------------------------------------------
%Natural Neighbor Algorithm
%--------------------------------------------------------------------------
%Authors: Zhu et al. (2016)
%Matlab Implementation: Ramiro Saltos
%Version: 1.0.0
%Date: June 02, 2023
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%Stage 1: Initialization
%--------------------------------------------------------------------------

%Create a KD Tree
KdT = KDTreeSearcher(Data);

%Initialize variables
n = size(Data,1);
nb = zeros(n,1);
NN = zeros(n,n);
RNN = cell(n,1);
NatN = cell(n,1);
cr = n;

%KNN Search
[KNN,Dist] = knnsearch(KdT,Data,'K',n);
KNN(:,1) = [];
Dist(:,1) = [];

%--------------------------------------------------------------------------
%Stage 2: Natural Eigenvalue Search
%--------------------------------------------------------------------------

for r = 1:n-1
    [GR,UN] = groupcounts(KNN(:,r));
    nb(UN) = nb(UN) + GR;
    lambda = r;
    if cr - sum(nb==0) == 0 || sum(nb==0) == 0
        break;
    else
        cr = sum(nb==0);
    end
end
KNNr = KNN(:,1:lambda);
kappa = max(nb);

%--------------------------------------------------------------------------
%Stage 3: Natural Neighbors Computation
%--------------------------------------------------------------------------

parfor i = 1:n
    [RNN{i},~] = find(KNNr==i);
    NatN{i} = intersect(KNNr(i,:),RNN{i});
end