function [anchors]=selectNodesAtCenter(network,numNodes,distanceFromCenter)
% Picks nodes, clustered at the center of the network
% if distanceFromCenter is set, will choose nodes getting further and
% further away from the center, unclustered (must be 4 nodes)

if exist('distanceFromCenter','var') == 0
    distanceFromCenter=0;
end

targets=zeros(numNodes,2);
x=network.width/2;
y=network.height/2;
if (distanceFromCenter ==0)
    for i=1:numNodes
        targets(i,1)=x;
        targets(i,2)=y;
    end
else
    if (numNodes ~= 4)
        fprintf(2,'Must have 4 nodes for getting distances away from center');
    end
    targets(1,1)=x-distanceFromCenter;
    targets(1,2)=y+distanceFromCenter;
    
    targets(2,1)=x+distanceFromCenter;
    targets(2,2)=y+distanceFromCenter;

    targets(3,1)=x+distanceFromCenter;
    targets(3,2)=y-distanceFromCenter;
    
    targets(4,1)=x-distanceFromCenter;
    targets(4,2)=y-distanceFromCenter;
end

anchors=selectNodesCloseToPoints(network,targets);
    
