%--------------------------------------------------------------------------
%NWOD Algorithm
%--------------------------------------------------------------------------
%Authors: Xiong et al.
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
%Stage 2: Weighted Undirected Saturated Neighborhood Graph
%--------------------------------------------------------------------------

%Compute the weights of the graph
myW = zeros(n);
myFlag = zeros(n^2,1);
myRows = 1:n;

for j = 1:n-1
    myCols = KNN(:,j)';
    idx = [sub2ind([n,n], myRows, myCols) sub2ind([n,n], myCols, myRows)];
    myW(idx(myFlag(idx) == 0)) = j;
    myFlag(idx) = 1;
end

myW(myW > lambda) = 0;

%--------------------------------------------------------------------------
%Stage 3: NWLOF Score
%--------------------------------------------------------------------------

%Weighted local density
wld = zeros(n,1);
parfor i = 1:n
    wld(i) = lambda^2 / (sum(myW(i,KNNr(i,:)))*sum(Dist(i,1:lambda)));
end

%Neighborhood weighted outlier factor
NWLOF = zeros(n,1);

parfor i = 1:n
    NWLOF(i) = sum(wld(KNNr(i)))/(lambda*wld(i));
end

%--------------------------------------------------------------------------
%Stage 4: Outlier Detection
%--------------------------------------------------------------------------

%Performance Evaluation
score = NWLOF;

%AUC-ROC
[FPR,TPR,~,AUC] = perfcurve(y,score,1);

%AUC-PR
[Recall,Prec,~,AUCPR] = perfcurve(y,score,1,'YCrit','ppv','XCrit','tpr');

Metrics = [AUC max(Prec(2:end)) AUCPR];