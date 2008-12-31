function [anchors]=selectAnchorNodesBad(network,numAnchors)
% Picks the 3 neighbors clumped together in the northeast corner
if exist('numAnchors','var') == 0
    numAnchors=3;
end
points=network.points;
N=size(points,1);
anchors=ones(3,1);

% Get Node at southeastern-most corner
anchors(1)=getNextNorthEastMost(points,1:N);
for i=2:numAnchors
    neighbors=network.nodes(anchors(i-1)).neighbors .* ~ismember(network.nodes(anchors(i-1)).neighbors, anchors);
    anchors(i)=getNextNorthEastMost(points,neighbors);
end

return;

function [neMost]=getNextNorthEastMost(points,neighbors)
% Return the index in the given points of the north-easterly-most point.
% This is defined as the largest sum of x and y coordinates
neMost=0;
for i=1:size(neighbors')
    n=neighbors(i);
    if (neMost == 0 || (n ~= 0 && points(n,1)+points(n,2) > points(neMost,1)+points(neMost,2)) )
        neMost=n;
    end
end
    
