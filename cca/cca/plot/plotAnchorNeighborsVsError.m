function plotAnchorNeighborsVsError(results,anchors,radii,folder)
%PLOTANCHORNEIGHBORSVSERROR Summary of this function goes here
%   Detailed explanation goes here
minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
% points=network.points;
% distances=network.distanceMatrix;
numAnchorSets=size(anchors,1);

figure('Name','Anchor Neighbors vs Error');
plotTitle=sprintf('Network %s',network.shape);
title({'Number of Neighbors per Anchor vs Localization Error',plotTitle});

labels=cell(1, size(radii,2));
hold all
numAnchorNeighbors=zeros(numAnchorSets,size(radii,2));
for r=1:size(radii,2)
    for s=1:numAnchorSets
        numAnchorsPerSet=size(anchors,2);
        for a=1:numAnchorsPerSet
            numAnchorNeighbors(s,r)=numAnchorNeighbors(s,r)+size(results(r).network.nodes(anchors(s,a)).neighbors,2);
%             for p=1:size(points,1)
%                 if a ~= p && distances(a,p) < radii(r)
%                     numAnchorNeighbors(r,s)=numAnchorNeighbors(r)+1;
%                 end
%             end
        end
    end
    dataToPlot=[numAnchorNeighbors(:,r) results(r).errorsPerAnchorSet.median];
    dataToPlot=sortrows(dataToPlot,1);
    plot(dataToPlot(:,1),dataToPlot(:,2),'-x');
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
