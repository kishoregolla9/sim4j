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
    startNodeData=zeros(numStartNodes,3);
    for s=1:numStartNodes
        startNodeData(s,1)=mean([results(r).errors(:,s).max],2);
        startNodeData(s,2)=mean([results(r).errors(:,s).mean],2);
        startNodeData(s,3)=mean([results(r).errors(:,s).min],2);
    end
    
    numAnchorSets=size(results(r).errors,1);
    anchorSetData=zeros(numAnchorSets,3);
    for a=1:numAnchorSets
        anchorSetData(a,1)=mean([results(r).errors(a,:).max],2);
        anchorSetData(a,2)=mean([results(r).errors(a,:).mean],2);
        anchorSetData(a,3)=mean([results(r).errors(a,:).min],2);
    end
    
    sortable=[(1:numAnchorSets)' anchorSetData(:,1)];
    sorted=sortrows(sortable,2);
    fprintf(1,'Worst\n');
    sorted(size(sorted,1)-5:size(sorted,1),:)
    fprintf(1,'Best\n');
    sorted(1:5,:)
    
    % errors=[results.errors];
    x=(1:numStartNodes)./numStartNodes;
    plots(1)=plot(x,startNodeData(:,1),'-d');
    plots(2)=plot(x,startNodeData(:,2),'-d');
    plots(3)=plot(x,startNodeData(:,3),'-d');
    x=(1:numAnchorSets)./numAnchorSets;
    plots(4)=plot(x,anchorSetData(:,1),'-d');
    plots(5)=plot(x,anchorSetData(:,2),'-d');
    plots(6)=plot(x,anchorSetData(:,3),'-d');
    startNodeLegend=sprintf('Start Node (avg over all %i anchor sets)',numAnchorSets);
    anchorSetLegend=sprintf('Anchor Sets (avg over all %i start nodes)',numStartNodes);
    a=sprintf('%s (Max)',startNodeLegend);
    b=sprintf('%s (Mean)',startNodeLegend);
    c=sprintf('%s (Min)',startNodeLegend);
    d=sprintf('%s (Max)',anchorSetLegend);
    e=sprintf('%s (Mean)',anchorSetLegend);
    f=sprintf('%s (Min)',anchorSetLegend);    
    legend(plots,a,b,c,d,e,f);
    hold off
end
filename=sprintf('StartNode-vs-Error-%s-Radius%i-to-%i',...
   network.shape,minRadius,maxRadius);
saveFigure(folder,filename);
