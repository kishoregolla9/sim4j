function [node] = compareMaps(node, mappedResult)

% set output
% t.xyEstimate = mappedResult;
node(startNode).patched_network_transform=mappedResult;
D_C = sqrt(disteusq(mappedResult,mappedResult,'x'));

differenceVector=abs(mappedResult-network.points);

D_dist_mean = mean((mean(abs(D_C-distanceMatrix)))');
D_dist_mean=D_dist_mean/r;
node(startNode).patched_net_dist_error_mean=D_dist_mean;

node(startNode).differenceVector=differenceVector;
node(startNode).mappedPoints=mappedResult;

return;