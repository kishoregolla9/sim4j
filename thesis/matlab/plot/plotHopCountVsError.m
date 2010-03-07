function plotHopCountVsError( results,anchors,radii,folder )
% Plot hop count distance of each node to its nearest anchor vs error

minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
numAnchorSets=size(anchors,1);

figure('Name','Hop Count to Anchor vs Error','visible','off');

for i=1:numAnchorSets
    hold off
    subplot(numAnchorSets/2,numAnchorSets/2,i);
    hold all
    t=sprintf('Anchor Set %i',i);
    title(t);
    
    [minHopCount,meanHopCount]=getHopCounts(anchors,...
        network.points,...
        network.shortestHopMatrix);
    
    diffVector=results.patchedMap(i).differenceVector;
    radius=results.radius;
    
    subPlotHopCountVsError( results, radius, ...
        diffVector, minHopCount )
    
    maximize(gcf);
    
    filename=sprintf('%s/HopCountVsError-%s-Radius%.1f-to-%.1f.eps',...
        folder,network.shape,minRadius,maxRadius);
    print('-depsc',filename);
    filename=sprintf('%s/HopCountVsError-%s-Radius%.1f-to-%.1f.png',...
        folder,network.shape,minRadius,maxRadius);
    print('-dpng',filename);
end

hold off

end

