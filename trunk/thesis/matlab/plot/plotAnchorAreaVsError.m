function plotAnchorAreaVsError( results,anchors,folder )
% Plot distance between the anchors themselves vs error

minRadius=results(1).radius;
maxRadius=results(end).radius;

network=results(1).network;
numAnchorSets=size(anchors,1);

%% Plot by Area

stats=triangleStats(network,anchors);

hold off
fig=figure('Name','Anchor Triangle Area vs Error','visible','off');
plotTitle=sprintf('Network %s',network.shape);
grid on
labels=cell(1, size(results,2));
title({'Area of Triangle made by Anchors vs Localization Error',...
    plotTitle});
for r=1:size(results,2)
    errorPerAnchorSet=zeros(numAnchorSets,1);
    for s=1:numAnchorSets
        % For one start node
        errorPerAnchorSet(s)=[results(r).errors(s,1).mean];
    end    
    
    dataToPlot=[stats.areas, stats.distancesToCentroid, errorPerAnchorSet];
    dataToPlot=sortrows(dataToPlot,1);    
    scatter(dataToPlot(:,1),dataToPlot(:,3),... % X,Y of circles
         5,...              % size of circles
         dataToPlot(:,2));  % color of circles
    grid on
    labels{r}=sprintf('Radius=%.1f',results(r).radius);
end
legend(labels,'Location','Best');
xlabel({'Area of Triangle Anchors',...
    'Color corresponds to distance of centroid to centre of networks'});
ylabel('Mean Location Error');
axes1=get(fig,'CurrentAxes');
set(axes1,'XScale','log');
hold off

filename=sprintf('AnchorTriangleAreaVsError-%s-Radius%.1f-to-%.1f',...
    network.shape,minRadius,maxRadius);
saveFigure(folder,filename);

end