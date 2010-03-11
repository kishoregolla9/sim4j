function [node] = compareMaps(network, node, mappedResult, radius)

% set output
% t.xyEstimate = mappedResult;
distanceMatrix=network.distanceMatrix;
node.patched_network_transform=mappedResult;
D_C = sqrt(disteusq(mappedResult,mappedResult,'x'));

differenceVector=abs(mappedResult-network.points);

D_dist_mean = mean((mean(abs(D_C-distanceMatrix))),2);
D_dist_mean=D_dist_mean/radius;
node.patched_net_dist_error_mean=D_dist_mean;

node.differenceVector=differenceVector;
node.mappedPoints=mappedResult;

return;