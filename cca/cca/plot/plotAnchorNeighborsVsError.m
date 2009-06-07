function plotAnchorNeighborsVsError( results, anchors,radii, folder )
%PLOTANCHORNEIGHBORSVSERROR Summary of this function goes here
%   Detailed explanation goes here
minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
points=network.points;
distances=network.distanceMatrix;
numAnchorSets=size(anchors,1);
labels=cell(1, size(radii,2));
hold all
numAnchorNeighbors=zeros(size(radii,2),1);
for r=1:size(radii,2)
    for s=1:numAnchorSets
        anchors=anchors(s,:);
        numAnchors=size(anchors,2);
        for a=1:numAnchors
            for p=1:size(points,1)
                if a ~= p && distances(a,p) < radii(r)
                    numAnchorNeighbors(r)=numAnchorNeighbors(r)+1;
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


filename=sprintf('AnchorNeighborsVsError-%s-Radius%.1f-to-%.1f',...
    network.shape,minRadius,maxRadius);
saveFigure(folder,filename);

end