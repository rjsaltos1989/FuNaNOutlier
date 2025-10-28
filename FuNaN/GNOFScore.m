%--------------------------------------------------------------------------
%GNOF Algorithm
%--------------------------------------------------------------------------
%Authors: Yang et al.
%Matlab Implementation: Ramiro Saltos
%Version: 1.0.0
%Date: July 29, 2024
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%Stage 0: Loading the data
%--------------------------------------------------------------------------
% clear;
% myPath = '/Users/ramirojavier/Mi Unidad/MATLAB/DataOut/';
% dataset = 'Motivation.mat';
% load(strcat(myPath,dataset));

%--------------------------------------------------------------------------
%Stage 1: Initialization
%--------------------------------------------------------------------------

NaNSearch;

%--------------------------------------------------------------------------
%Stage 2: Structural Similarity
%--------------------------------------------------------------------------

%Node structure
Gamma = horzcat(transpose(1:n),KNNr);

%Structural similarity
sigma = zeros(n);
FMat = zeros(n);

for i = 1:n
    for j = i+1:n
        FMat(i,j) = (numel(intersect(Gamma(i,:),Gamma(j,:)))/sqrt(numel(Gamma(i,:))*numel(Gamma(j,:))))/(Dist(i,KNN(i,:) == j)^2);
        FMat(j,i) = FMat(i,j);
    end
end

%--------------------------------------------------------------------------
%Stage 3: Gravitation-based Natural Eigenvalue Search
%--------------------------------------------------------------------------

%Sort data points according to the higher values of F
[FMatS,GKNN] = maxk(FMat,n,2);
nb = zeros(n,1);

for r = 1:n-1
    [GR,UN] = groupcounts(GKNN(:,r));
    nb(UN) = nb(UN) + GR;
    lambda = r;
    if cr - sum(nb==0) == 0 || sum(nb==0) == 0
        break;
    else
        cr = sum(nb==0);
    end
end
GKNNr = GKNN(:,1:lambda);
kappa = max(nb);

%--------------------------------------------------------------------------
%Stage 4: Gravitation-based Natural Neighbors Computation
%--------------------------------------------------------------------------

parfor i = 1:n
    [GRNN{i},~] = find(GKNNr==i);
    GNatN{i} = intersect(GKNNr(i,:),GRNN{i});
end
GNatN = GNatN';

%--------------------------------------------------------------------------
%Stage 5: K-Distances
%--------------------------------------------------------------------------

%K-distance
kdist = FMatS(:,kappa);

%K-tilde distance
ktdist = zeros(n,n);
Nk = zeros(n,n);
GKNNk = GKNN(:,1:kappa);

parfor i = 1:n

    %ktdist matrix computation
    for j = 1:n
        if i ~= j
            ktdist(i,j) = min(kdist(j),FMatS(i,GKNN(i,:) == j));
            if FMatS(i,GKNN(i,:) == j) >= kdist(i)
                Nk(i,j) = 1;
            end
        end
    end

    %Gravitation-based Natural Influence Space
    [GRNN{i},~] = find(GKNNk==i);
    GNIS{i} = union(GKNNk(i,:),GRNN{i});
end

GNIS = GNIS';

%Local reachability density
ldr = sum(Nk,2)./(sum(Nk.*ktdist,2));

%--------------------------------------------------------------------------
%Stage 6: Gravitation-based Natural Outlier Factor
%--------------------------------------------------------------------------

GNOF = zeros(n,1);
parfor i = 1:n
    GNOF(i) = sum(ldr(GNIS{i}))/(numel(GNIS{i})*ldr(i));
end

%--------------------------------------------------------------------------
%Stage 7: Outlier Detection
%--------------------------------------------------------------------------

%Performance Evaluation
score = 1./GNOF;

%AUC-ROC
[FPR,TPR,~,AUC] = perfcurve(y,score,1);

%AUC-PR
[Recall,Prec,~,AUCPR] = perfcurve(y,score,1,'YCrit','ppv','XCrit','tpr');

Metrics = [AUC max(Prec(2:end)) AUCPR];