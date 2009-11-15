function plotNumAnchorNeighborsVsError( results,anchors,radii,folder )
% Plot number of unique anchor neighbors (unique among all anchors in the
% set) vs location error

minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
numAnchorSets=size(anchors,1);

%% Plot By Number Covered Nodes
figure('Name','Num Anchor Neighbors vs Error','visible','off');
plotTitle=sprintf('Network %s',network.shape);
title({'Number of Anchor Neighbors vs Localization Error',...
    plotTitle});
hold all
grid on
labels=cell(1, size(results,2));
for r=1:size(results,2)
    errorPerAnchorSet=zeros(numAnchorSets,1);
    numNeighbors=zeros(numAnchorSets,1);
    for s=1:numAnchorSets
        % For one start node
        errorPerAnchorSet(s)=[results(r).errors(s,1).median];
        anchorNodes=anchors(s,:);
        n=getNumUnique(network,anchorNodes);
        numNeighbors(s,1)=numNeighbors(s,1) + n;
    end    
    
    dataToPlot=[numNeighbors, errorPerAnchorSet];
    dataToPlot=sortrows(dataToPlot,1);    
    plot(dataToPlot(:,1),dataToPlot(:,2),'-o');
    labels{r}=sprintf('Radius=%.1f',results(r).radius);
end
legend(labels,'Location','Best');
xlabel('Number of Anchors Unique Neighbors');
ylabel('Median Location Error');
hold off

filename=sprintf('AnchorNeighborsVsError-%s-Radius%.1f-to-%.1f',...
    network.shape,minRadius,maxRadius);
saveFigure(folder,filename);

end

function [num] = getNumUnique(network,anchorSet)
n=[];
for i=1:size(anchorSet,2)
    n=[n network.nodes(anchorSet(1,i)).neighbors];
end
num=size(unique(n),2);
end
