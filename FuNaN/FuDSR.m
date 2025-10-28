%--------------------------------------------------------------------------
%Fuzzy Dynamic Scanning Radius Algorithm
%--------------------------------------------------------------------------
%Authors: Saltos et al.
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

%Membership degrees of x to the fuzzy set "Few"
sumNuP = sum(nuP,2,'omitmissing');

%--------------------------------------------------------------------------
%Stage 3: Fuzzy Dynamic Scanning Radius
%--------------------------------------------------------------------------

%Fuzzy Dynamic scanning radius
EDist = pdist2(Data,Data);
fudsr = sum((1 - nuP).*EDist,2,'omitmissing')./sumNuP;
score = fudsr;

%Performance Evaluation

%AUC-ROC
[FPR,TPR,~,AUC] = perfcurve(y,score,1);

%AUC-PR
[Recall,Prec,~,AUCPR] = perfcurve(y,score,1,'YCrit','ppv','XCrit','tpr');

Metrics = [AUC max(Prec(2:end)) AUCPR];

