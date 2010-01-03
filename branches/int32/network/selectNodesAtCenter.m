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
    degreesPerTarget=2*pi/numNodes;
    angle=0;
    for i=1:numNodes
        x=distanceFromCenter*cos(angle);
        y=distanceFromCenter*sin(angle);
        targets(i,1)=x+network.width/2;
        targets(i,2)=y+network.height/2;
        
        angle=angle+degreesPerTarget;
    end
    
end

anchors=selectNodesCloseToPoints(network,targets);
    
