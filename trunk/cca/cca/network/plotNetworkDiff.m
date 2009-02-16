function [h]=plotNetworkDiff(result,folder)
% Plot the network difference, showing the anchor nodes with green squares
% Blue points are real point locations
% Red points are mapped point locations

r=result.radius;
plottitle=sprintf('%s Radius %.1f',result.network.shape,r);
h=figure('Name',['Network Difference' plottitle]);
numAnchorSets=size(result.network.anchors,1);

for j=1:numAnchorSets
    mappedPoints=result.localMaps(j).mappedPoints;
    realPoints=result.network.points;
    anchors=result.network.anchors(j,:);
    
    subplot(2,numAnchorSets,j,'align');
    subplotTitle=sprintf('Anchor Set %i',j);
    title(subplotTitle);
    hold all
    for i=1:size(realPoints,1)
        plot([realPoints(i,1),mappedPoints(i,1)],...
            [realPoints(i,2),mappedPoints(i,2)],'-or','MarkerSize',3);
    end
    plot(realPoints(:,1),realPoints(:,2),'db','MarkerSize',3);

    for a=1:size(anchors,2)
        x=realPoints(anchors(:,a),1);
        y=realPoints(anchors(:,a),2);
        plot(x,y,'-d',...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor','g',...
            'MarkerSize',3);
        rectangle('Position',[x-r,y-r,r*2,r*2],'Curvature',[1 1]);
    end
    axis([0 ceil(max(realPoints(:,1))) 0 ceil(max(realPoints(:,2)))]);
    axis square
    hold off    
end

suptitle(plottitle);

subplot(2,numAnchorSets,numAnchorSets+1:2*numAnchorSets);
dataToPlot=[result.maxErrorPerAnchorSet;result.meanErrorPerAnchorSet;result.medianErrorPerAnchorSet;result.minErrorPerAnchorSet];
bar(dataToPlot);
legend(gca,['Anchor Set 1';'Anchor Set 2';'Anchor Set 3']);
set(gca,'XTickLabel','Max|Mean|Median|Min')
title('Location Error Statistics');
grid on;

filename=sprintf('%s\\NetworkDifference-%s-Radius%.1f',folder,result.network.shape,r);
foo=sprintf('%s.eps',filename);
print('-depsc',foo);
foo=sprintf('%s.png',filename);
print('-dpng',foo);
return;