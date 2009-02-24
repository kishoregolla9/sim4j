function plotAnchorNeighborsVsError( results, radii, folder )
%PLOTANCHORNEIGHBORSVSERROR Summary of this function goes here
%   Detailed explanation goes here
minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
points=network.points;
distances=network.distanceMatrix;
numAnchorSets=size(network.anchors,1);
labels=cell(1, size(radii,2));
hold all
for r=1:size(radii,2)
    numAnchorNeighbors=zeros(numAnchorSets,1);
    for s=1:numAnchorSets
        anchors=network.anchors(s,:);
        numAnchors=size(anchors,2);
        for a=1:numAnchors
            for p=1:size(points,1)
                if a ~= p && distances(a,p) < radii(r)
                    numAnchorNeighbors(s)=numAnchorNeighbors(s)+1;
                end
            end
        end
    end
    plot(numAnchorNeighbors,results(r).medianErrorPerAnchorSet);
    labels{r}=sprintf('Radius=%.1f',results(r).radius);
end
legend(labels,'Location','NorthWest');
xlabel('Number of Neighbors to Anchors');
ylabel('Median Location Error');
hold off


filename=sprintf('AnchorNeighborsVsError-%s-Radius%.1f-to-%.1f-AnchorSet%i',...
    network.shape,minRadius,maxRadius,i);
saveFigure(folder,filename);

end
