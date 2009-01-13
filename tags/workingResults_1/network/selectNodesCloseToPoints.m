function [anchors]=selectNodesCloseToPoints(network,targets)
% Picks anchors close to the given targets
% The result is the same length as the given targets

points=network.points;
numAnchors=size(targets,1);
anchors=zeros(numAnchors,1);

for i=1:numAnchors
    anchors(i)=getNearTarget(points,targets(i,:),nonzeros(anchors));
    points=points .* ~ismember(points, points(anchors(i),:));
end

return;

function [anchor]=getNearTarget(points,target,exclude)
% Return the index in the given points minimizing euclidean distance to
% given target
anchor=0;
min=-1;
for i=1:size(points,1)
    d=pdistance(points(i,:),target');
    if anchor == 0 || ((points(i,1) ~= 0 && points(i,2) ~= 0) && d < min && size(nonzeros(ismember(exclude,i)),1) < 1)
        anchor=i;
        min=d;
    end
end
return;

function [dist]=pdistance(p1,p2)
dist=sqrt((p2(1)-p1(1)).^2 + (p2(2)-p1(2)).^2);
    
