%--------------------------------------------------------------------------
%Fuzzy Natural Neighbor Outlier Detection Algorithm IV
%--------------------------------------------------------------------------
%Authors: Ramiro Saltos, Richard Weber
%Matlab Implementation: Ramiro Saltos
%Version: 1.1.0
%Date: January 29, 2024
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

% Apply Min-Max Normalization
Data = normalize(Data,'range');

%Create a KD Tree
KdT = KDTreeSearcher(Data);

%Initialize variables
n = size(Data,1);

%KNN Search
KNN = knnsearch(KdT,Data,'K',n);
KNN(:,1) = [];

%--------------------------------------------------------------------------
%Stage 2: Fuzzy Natural Neighbors
%--------------------------------------------------------------------------

%Membership degrees of x to the Fuzzy Natural Neighborhood set of y
nuP = nan(n);

%Compute membership degrees
myFlag = zeros(n^2,1);
myRows = 1:n;
for j = n - 1: -1: 1
    myCols = KNN(:,j)';
    idx = [sub2ind([n,n], myRows, myCols) sub2ind([n,n], myCols, myRows)];
    nuP(idx(myFlag(idx) == 0)) = 1/j;
    myFlag(idx) = 1;
end

%Fuzzifier 
eta = 2;

%Membership degrees of x to the fuzzy set "Few"
cumSP = sum(cumsum(sort(nuP,2,'descend'),2,'omitnan'),2);
uB = n*(harmonic(n)-1);
lB = n/2;
muF = 1 - ((cumSP - lB)/(uB - lB)).^(2/(eta-1));

%Membership degrees of x to the fuzzy set "Far Away of the Rest"
sumD = sum((1 + pdist2(Data,Data).^2).^(-1),2);
muFA = 1 - ((sumD - 1)/(n - 1)).^(2/(eta-1));

%Membership degrees of x to the fuzzy set "Outlier"
muO = muF.*muFA;
score = muO;

%Performance Evaluation

%AUC-ROC
[FPR,TPR,~,AUC] = perfcurve(y,score,1);

%AUC-PR
[Recall,Prec,~,AUCPR] = perfcurve(y,score,1,'YCrit','ppv','XCrit','tpr');

Metrics = [AUC max(Prec(2:end)) AUCPR];