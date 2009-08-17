function [ h ] = plotStartNodeVsError( results,radii,folder )

network=results.network;
minRadius=radii(1);
maxRadius=radii(size(radii,2));

h=figure('Name','The Results by Start Node');
hold off

grid on
plotTitle=sprintf('Network %s',network.shape);
title({'Localization Error',plotTitle});
xlabel('Normalized Index (Start Node or Anchor Set)');
ylabel('Location Error (factor of radius)');
hold all

for r=1:size(results,2)
    numStartNodes=size(results(r).errors,2);
    startNodeData=zeros(numStartNodes,1);
    for s=1:numStartNodes
        startNodeData(s,1)=mean([results(r).errors(:,s).mean],2);
    end
    
    numAnchorSets=size(results(r).errors,1);
    anchorSetData=zeros(numAnchorSets,1);
    for a=1:numAnchorSets
        anchorSetData(a,1)=mean([results(r).errors(a,:).mean],2);
    end
    
    sortable=[(1:numAnchorSets)' anchorSetData];
    sorted=sortrows(sortable,2);
    sorted(size(sorted,1)-10:size(sorted,1),:)
%     for i=1:10
%         sortable(i,:)
%     end
    
    % errors=[results.errors];
    x=(1:numStartNodes); %./numStartNodes;
    plots(1)=plot(x,startNodeData,'-d');
    x=(1:numAnchorSets); %./numAnchorSets;
    plots(2)=plot(x,anchorSetData,'-d');
    startNodeLegend=sprintf('Start Node (avg over all %i anchor sets)',numAnchorSets);
    anchorSetLegend=sprintf('Anchor Sets (avg over all %i start nodes)',numStartNodes);
    legend(plots,startNodeLegend,anchorSetLegend);
    hold off
end
filename=sprintf('StartNode-vs-Error-%s-Radius%.1f-to-%.1f',...
   network.shape,minRadius,maxRadius);
saveFigure(folder,filename);
