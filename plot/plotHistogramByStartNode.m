function [ h ] = plotHistogramByStartNode( results,radii,folder )

network=results.network;
minRadius=radii(1);
maxRadius=radii(size(radii,2));

grid on
plotTitle=sprintf('Network %s',network.shape);
title({'Localization Error',plotTitle});
% xlabel('Normalized Index (Start Node or Anchor Set)');
% ylabel('Location Error (factor of radius)');
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
    
    hist(startNodeData(:,2));
    hold off
end
filename=sprintf('Histogram-%s-Radius%i-to-%i',...
   network.shape,minRadius,maxRadius);
saveFigure(folder,filename);
