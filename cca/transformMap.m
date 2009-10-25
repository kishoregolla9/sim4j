function [mappedResult] = transformMap(points, refineResult, anchorNodes, ...
    operations)
% Transform the map using the procrustes algorithm
% points: the input points (only anchor nodes are used)
% refineResult: the local map points, so far
% anchor Nodes:
% operations: 4 - all
%             3 - no translation
%             2 - no rotation/reflection
%             1 - no scaling

if nargin < 4
    operations=4;
end


n=size(points,1);
%      c:  the translation component
%      T:  the orthogonal rotation and reflection component
%      b:  the scale component
%   That is, Z = tr.b * Y * tr.T + tr.c.
X=points(anchorNodes,:);
Y=refineResult(anchorNodes,1:2);
YComplete=refineResult(:,1:2);
[d, Z, tr] = procrustes(X, Y);
fprintf(1,'Done Transform for %i', operations);
switch operations
    case 4
        % All operations
        % do nothing
    case 3
        %NO TRANSLATION
        trUntranslated.T = tr.T;
        trUntranslated.b = tr.b;
        trUntranslated.c = ones(size(tr.c));
        tr=trUntranslated;
    case 2
        %NO SCALING
        trUnscaled.T = tr.T;
        trUnscaled.b = 1;
        trUnscaled.c = mean(X) - mean(Y) * trUnscaled.T;
        tr=trUnscaled;
    case 1
        %NO ROTATION/REFLECTION
        trUnrotated.T = ones(size(tr.T));
        trUnrotated.b = tr.b;
        trUnrotated.c = mean(X) - mean(Y) * trUnrotated.T;
        tr=trUnrotated;
end
mappedResult = tr.b * YComplete * tr.T + repmat(tr.c(1,:),n,1);
end 