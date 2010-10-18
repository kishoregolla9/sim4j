function plotNumAnchorNeighborsVsError( results,anchors,radii,folder,threshold)
% Plot number of unique anchor neighbors (unique among all anchors in the
% set) vs location error

if (exist('threshold','var')==0)
    threshold=100;
end

minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
numAnchorSets=size(anchors,1);

%% Plot By Number Covered Nodes
figure('Name','Num Anchor Neighbors vs Error','visible','off');
plotTitle=sprintf('Network %s',strrep(network.shape,'-',' '));
if (threshold < 100)
    plotTitle=sprintf('%s\nExcluding errors >%0.1f',plotTitle,threshold);
end
title(plotTitle);
hold all
grid on
labels=cell(1, size(results,2));
for r=1:size(results,2)
    errorPerAnchorSet=zeros(numAnchorSets,1);
    numNeighbors=zeros(numAnchorSets,1);
    for s=1:numAnchorSets
        % For one start node
        errorPerAnchorSet(s)=[results(r).errors(s,1).mean];
        anchorNodes=anchors(s,:);
        n=getNumUnique(network,anchorNodes);
        numNeighbors(s,1)=numNeighbors(s,1) + n;
    end
    
    % Remove outliers greater than threshold
    outliers=find(errorPerAnchorSet>threshold);
    errorPerAnchorSet(outliers)=[];
    numNeighbors(outliers)=[];
    
    dataToPlot=[numNeighbors, errorPerAnchorSet];
    dataToPlot=sortrows(dataToPlot,1);
    plot(dataToPlot(:,1),dataToPlot(:,2),'ok');
    
    p = polyfit(numNeighbors, errorPerAnchorSet, 2);
    Output = polyval(p,numNeighbors);
    correlation = corrcoef(errorPerAnchorSet, Output);
    
    if (size(results,2) > 1)
        labels{r}=sprintf('Radius=%.1f,Correlation=%.2f',...
            results(r).radius,correlation(1,2));
    end
end
%legend(labels,'Location','NorthEast');
bottom=sprintf('Number of Anchors Unique Neighbors');
if (size(results,2) == 1)
    bottom=sprintf('%s\nCorrelation Coefficient=%.2f',...
        bottom,correlation(1,2));
end
xlabel(bottom);
ylabel('Mean Location Error');
hold off

filename=sprintf('AnchorNeighborsVsError-%s-Radius%.1f-to-%.1f',...
    network.shape,minRadius,maxRadius);
if (threshold < 100)
    filename=sprintf('%s-Excluding%0.1f',filename,threshold);
end
saveFigure(folder,filename);

end

function [num] = getNumUnique(network,anchorSet)
n=[];
for i=1:size(anchorSet,2)
    n=[n network.nodes(anchorSet(1,i)).neighbors];
end
num=size(unique(n),2);
end
