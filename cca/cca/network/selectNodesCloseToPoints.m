function [anchors]=selectNodesCloseToPoints(network,targets)
% Picks anchors close to the given targets
% The result is the same length as the given targets

points=network.points;
numAnchors=size(targets,1);
anchors=zeros(numAnchors,1);

for i=1:numAnchors
    fprintf('---------\n+++ Size of points: %f\n',size(points));
    anchors(i)=getNearTarget(points,targets(i,:),nonzeros(anchors));
    points=points .* ~ismember(points, points(anchors(i),:));
end

return;

function [anchor]=getNearTarget(points,target,exclude)
% Return the index in the given points minimizing euclidean distance to
% given target
anchor=0;
min=-1;
fprintf(1,'Getting anchor close to: (%.1f,%.1f)\n',target(1,1),target(1,2));
for i=1:size(points,1)
    d=pdistance(points(i,:),target');
    fprintf(1, '%.0f Point (%.2f,%.2f) %.3f\n',i,points(i,1),points(i,2),d);
    if points(i,1) < 1.5 && points(i,1) > 8.5
        fprintf(1,'----Distance %.2f (%.1f,%.1f)\n',d,points(i,1),points(i,2));
    end
    if anchor == 0 || ((points(i,1) ~= 0 && points(i,2) ~= 0) && d < min && size(nonzeros(ismember(exclude,i)),1) < 1)
        if (anchor ~= 0)
            fprintf(1, 'Closer %.3f (%.2f,%.2f) than %.3f (%.2f,%.2f)\n', d,points(i,1),points(i,2),min,points(anchor,1),points(anchor,2));
        end
        anchor=i;
        min=d;
    end
end
return;

function [dist]=pdistance(p1,p2)
dist=sqrt((p2(1)-p1(1)).^2 + (p2(2)-p1(2)).^2);
    
