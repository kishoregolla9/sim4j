function [stats] = triangleStats(points,anchors,width,height)

numAnchorSets=size(anchors,1);    

areas=zeros(numAnchorSets,1);
distances=zeros(numAnchorSets,1);

heights=struct(...
    'max',0,...
    'median',0,...
    'mean',0,...
    'min',0,...
    'sum',0);

centroids=zeros(numAnchorSets,2);

% distanceMatrix=sqrt(disteusq(points(:,1),points(:,2),'x'));

for s=1:numAnchorSets
    anchorNodes=anchors(s,:);
    numAnchors=size(anchorNodes,2);
    d=zeros(numAnchors*2-1,1);
    anchorPoints=points(anchorNodes,:);
    d(1)=distance(anchorPoints(1,:),anchorPoints(2,:));
    d(2)=distance(anchorPoints(2,:),anchorPoints(3,:));
    d(3)=distance(anchorPoints(3,:),anchorPoints(1,:));
    areas(s,1)=heron(d(1),d(2),d(3));
    c=centroid(points(anchorNodes(:),:));
    distances(s,1)=distance([height/2 width/2],c);
    
    A=areas(s,1);
    h=zeros(3,1);
    h(1)=2*A/d(2);
    h(2)=2*A/d(3);
    h(3)=2*A/d(1);
    heights(s).max=max(h);
    heights(s).median=median(h);
    heights(s).mean=mean(h);
    heights(s).min=min(h);
    heights(s).sum=sum(h);
    centroids(s,:)=c;
end

stats=struct();
stats.heights=heights;
stats.areas=areas;
stats.distancesToCentroid=distances;
stats.centroids=centroids;

end

function [triangleArea] = heron(a,b,c)
s=(a+b+c)/2;
triangleArea=sqrt(s*(s-a)*(s-b)*(s-c));
end

function [c] = centroid(v)
c=[(v(1,1)+v(2,1)+v(3,1)) / 3 (v(1,2)+v(2,2)+v(3,2)) / 3];
end

function [d] = distance(a,b)
d=sqrt((b(1)-a(1))^2 + (b(2)-a(2))^2);
end