%--------------------------------------------------------------------------
%NaNOF Algorithm
%--------------------------------------------------------------------------
%Authors: Zhu et al.
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
%Stage 2: Weighted Natural Neighbor Graph
%--------------------------------------------------------------------------

%Compute the weights of the natural neighbor graph
myW = zeros(n);
myFlag = zeros(n^2,1);
myRows = 1:n;

for j = n-1: -1: 1
    myCols = KNN(:,j)';
    idx = [sub2ind([n,n], myRows, myCols) sub2ind([n,n], myCols, myRows)];
    myW(idx(myFlag(idx) == 0)) = j;
    myFlag(idx) = 1;
end

myW(myW > lambda) = 0;

%--------------------------------------------------------------------------
%Stage 3: NaNOF Score
%--------------------------------------------------------------------------
NaNOF = nan(n,1);
myWaux = myW;
myWaux(myW == 0) = inf;

parfor i = 1:n
    degxi = nnz(myW(i,:) > 0);
    if degxi >= 1
        maxw = max(myW(i,:));
        minw = min(myWaux(i,:));
        NaNOF(i) = (maxw - minw)/degxi;
    end
end

%--------------------------------------------------------------------------
%Stage 4: Outlier Detection
%--------------------------------------------------------------------------

%The outliers are the top n data points with higher NaNOF score
% top = 1;
% NaNOFList = sortrows(horzcat(transpose(1:n),NaNOF),2,"descend");
% Outliers = sort(NaNOFList(1:top,1));

%Performance Evaluation
[BadRecall,Recall,Threshold,AUC,OptROC] = perfcurve(y,NaNOF,1);
[Prec, tpr, fpr, thresh] = prec_rec(NaNOF, y);

Metrics = [AUC max(Prec)];

