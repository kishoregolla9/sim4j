% RCS: $Id: refinementOptC.m,v 1.2 2002/12/28 00:11:12 yshang Exp yshang $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Refinement of the relative map based on least-squares optimization
%%
%% Input: relativeMap - the coordinates of points
%%        distMatrix - distance matrix of all points
%%        distHopMatrix - the hop distance between all points
%% Output: newP - the coordinates of points after optimization
%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [newP] = refinementOptC(X0, distMatrix, distHopMatrix)

range = 2; % hop limit

[tmp,N] = size(distMatrix);
%tic;
distMatrix2 = [];
distHopMatrix2 = [];
for i=1:N-1
    distMatrix2 = [distMatrix2 distMatrix(i,i+1:end)];
    distHopMatrix2 = [distHopMatrix2 distHopMatrix(i,i+1:end)];
end
index = find(distHopMatrix2 <= range);

options = optimset('Display','off','LargeScale', 'off', 'MaxIter', 20, ...
    'TolFun', 1e-3,'Jacobian', 'on', 'DerivativeCheck', 'off');
X0 = X0'; X0 = X0(:);
% options = optimset('Display','iter','LargeScale', 'off');
[newP,resnorm] = lsqnonlin(@myObjFunC,X0, [],[],options, ...
    distMatrix2,distHopMatrix2, index);
% resnorm
% disp(['Local refinement takes ' num2str(toc) ' sec']);
newP = reshape(newP,2,[]);
newP = newP';
