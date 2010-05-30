function [node] = compareMaps(network, node, mappedResult, radius)

% set output
% t.xyEstimate = mappedResult;
distanceMatrix=network.distanceMatrix;
node.patched_network_transform=mappedResult;
D_C = sqrt(disteusq(mappedResult,mappedResult,'x'));

differenceVector=abs(mappedResult-network.points);
distanceVector=distance(mappedResult,network.points);

D_dist_mean = mean((mean(abs(D_C-distanceMatrix))),2);
D_dist_mean=D_dist_mean/radius;
node.patched_net_dist_error_mean=D_dist_mean;

node.differenceVector=differenceVector;
node.distanceVector=distanceVector;
node.mappedPoints=mappedResult;

end

function [d] = distance(a, b)
if (size(a,1) ~= size(b,1))
    error('A and B should be of same dimensionality');
end
d=sqrt( sum((a-b).^2,2) );
end