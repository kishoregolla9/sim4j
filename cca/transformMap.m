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

if nargin < 5
    operations=4;
end


N=size(points,1);
[D, Z, TRANSFORM] = procrustes(points(anchorNodes,:), refineResult(anchorNodes,1:2));
%Z = TRANSFORM.b * Y * TRANSFORM.T + TRANSFORM.c;

switch operations
    case 4
        % All operations
        mappedResult = TRANSFORM.b * refineResult(:,1:2) * TRANSFORM.T + ...
            repmat(TRANSFORM.c(1,:),N,1);
    case 3
        %NO TRANSLATION
        mappedResult = TRANSFORM.b * refineResult(:,1:2) * TRANSFORM.T ;
    case 2
        %NO SCALING
        mappedResult = refineResult(:,1:2) * TRANSFORM.T + ...
            repmat(TRANSFORM.c(1,:),N,1);
    case 1
        %NO ROTATION/REFLECTION
        mappedResult = TRANSFORM.b * refineResult(:,1:2) + ...
            repmat(TRANSFORM.c(1,:),N,1);
        return;
end
end 