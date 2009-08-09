function [mappedResult] = transformMap(points, refineResult, anchorNodes)
N=size(points,1);
[D, Z, TRANSFORM] = procrustes(points(anchorNodes,:), refineResult(anchorNodes,1:2));
mappedResult = TRANSFORM.b * refineResult(:,1:2) * TRANSFORM.T + ...
    repmat(TRANSFORM.c(1,:),N,1);

return;
