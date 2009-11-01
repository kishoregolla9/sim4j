function plotAnchorDistanceVsError( results,anchors,radii,folder )
% Plot distance between the anchors themselves vs error

minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
numAnchorSets=size(anchors,1);

%% Plot by Perimeter
figure('Name','Anchor Distance vs Error','visible','off');
plotTitle=sprintf('Network %s',network.shape);
title({'Sum of Distance between All Anchors vs Localization Error',...
    plotTitle});

distances=zeros(numAnchorSets,1);
for s=1:numAnchorSets
    anchorNodes=anchors(s,:);
    numAnchors=size(anchorNodes,2);
    d=zeros(numAnchors*2-1,1);
    d(1)=network.distanceMatrix(anchorNodes(1),anchorNodes(2));
    d(2)=network.distanceMatrix(anchorNodes(2),anchorNodes(3));
    d(3)=network.distanceMatrix(anchorNodes(3),anchorNodes(1));
    distances(s,1)=sum(d);
end

hold all
grid on
labels=cell(1, size(results,2));
for r=1:size(results,2)
    errorPerAnchorSet=zeros(numAnchorSets,1);
    for s=1:numAnchorSets
        % For one start node
        errorPerAnchorSet(s)=[results(r).errors(s,1).max];
    end    
    
    dataToPlot=[distances, errorPerAnchorSet];
    dataToPlot=sortrows(dataToPlot,1);    
    plot(dataToPlot(:,1),dataToPlot(:,2),'-o');
    labels{r}=sprintf('Radius=%.1f',results(r).radius);
end
legend(labels,'Location','Best');
xlabel('Sum of Distance between Anchors');
ylabel('Median Location Error');
hold off

filename=sprintf('AnchorDistanceVsError-%s-Radius%.1f-to-%.1f',...
    network.shape,minRadius,maxRadius);
saveFigure(folder,filename);

end
