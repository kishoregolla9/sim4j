function [anchors]=selectNodesFromCorner(network,numAnchors,hopsFromCorner)
% Picks the 3 neighbors clumped together in the northeast corner
if exist('numAnchors','var') == 0
    numAnchors=3;
end

if exist('hopsFromCorner','var') == 0
    hopsFromCorner=1;
end

points=network.points;
N=size(points,1);
anchors=ones(numAnchors,1);

anchors(1)=getNextNorthEastMost(points,1:N);

% build the neigbors list, starting from the northeast most node
neighborsAtLevel=network.nodes(anchors(1)).neighbors;
closer=neighborsAtLevel;
for i=2:hopsFromCorner
    % Get the neighbors at the next hop level, blocking the previous levels
    neighbors=network.nodes(neighborsAtLevel).neighbors;
    neighborsAtLevel=nonzeros(neighbors .* ~ismember(neighbors, closer))';
    closer=[closer,neighborsAtLevel];
end

for i=2:numAnchors
    % block the anchors used so far from being an anchor again
    neighbors=nonzeros(neighborsAtLevel .* ~ismember(neighborsAtLevel, anchors));
    anchors(i)=getNextNorthEastMost(points,neighbors);
end

return;

function [neMost]=getNextNorthEastMost(points,neighbors)
% Return the index in the given points of the north-easterly-most point.
% This is defined as the largest sum of x and y coordinates
neMost=0;
for i=1:size(neighbors')
    n=neighbors(i);
    if (neMost == 0 || (points(n,1)+points(n,2) > points(neMost,1)+points(neMost,2)) )
        neMost=n;
    end
end
    
