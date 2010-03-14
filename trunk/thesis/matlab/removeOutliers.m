function [ y,outliers ] = removeOutliers( x )

mu = mean(x);
sigma = std(x);
[n,p] = size(x);
% Create a matrix of mean values by
% replicating the mu vector for n rows
MeanMat = repmat(mu,n,1);
% Create a matrix of standard deviation values by
% replicating the sigma vector for n rows
SigmaMat = repmat(sigma,n,1);
% Create a matrix of zeros and ones, where ones indicate
% the location of outliers
outliers = abs(x - MeanMat) > 3*SigmaMat;

y=x;  
y(outliers)=[]; % remove the outliers from x


end