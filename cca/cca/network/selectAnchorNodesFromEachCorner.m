function [anchors]=selectAnchorNodesFromEachCorner(network)
% Picks 4 anchors, one from each corner

anchors=selectAnchorNodesCloseToPoints(network,[0,0;0,network.height;network.width,0;network.width,network.height]);

% points=network.points;
% N=size(points,1);
% anchors=ones(4,1);
% 
% anchors(1)=getNextNorthEastMost(points,1:N,'xy');
% anchors(2)=getNextNorthEastMost(points,1:N,'x');
% anchors(3)=getNextNorthEastMost(points,1:N,'y');
% anchors(4)=getNextNorthEastMost(points,1:N,'');

return;

function [anchor]=getNextNorthEastMost(points,neighbors,maximize)
% Return the index in the given points maximizing x,y, or xy
anchor=0;
for i=1:size(neighbors')
    n=neighbors(i);
    if anchor == 0
        anchor=n;
    elseif strcmp(maximize,'xy') && points(n,1)+points(n,2) > points(anchor,1)+points(anchor,2)
        anchor = n;
    elseif strcmp(maximize,'x') && points(n,1)-points(n,2) > points(anchor,1)-points(anchor,2)
        anchor = n;
    elseif strcmp(maximize,'y') && points(n,2)-points(n,1) > points(anchor,2)-points(anchor,1)
        anchor = n;
    elseif strcmp(maximize,'') && points(n,1)+points(n,2) < points(anchor,1)+points(anchor,2)
        anchor = n;        
    end
end
    
