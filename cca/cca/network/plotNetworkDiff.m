function [h]=plotNetworkDiff(result,plottitle,filename)
% Plot the network difference, showing the anchor nodes with green squares
% Blue points are real point locations
% Red points are mapped point locations

h=figure('Name',plottitle);
suptitle(plottitle);
numPlots=size(result.network.anchors,1);
for j=1:numPlots
    mappedPoints=result.localMaps(j).mappedPoints;
    realPoints=result.network.points;
    anchors=result.network.anchors(j,:);
    
    p=subplot(numPlots/3,min(3,numPlots),j,'align');
    subplotTitle=sprintf('Anchor Set %i',j);
    title(p,subplotTitle);
    hold all
    for i=1:size(realPoints,1)
        plot([realPoints(i,1),mappedPoints(i,1)],...
            [realPoints(i,2),mappedPoints(i,2)],'-dr','MarkerSize',3);
    end
    plot(realPoints(:,1),realPoints(:,2),'db','MarkerSize',3);


    for a=1:size(anchors,2)
        plot(realPoints(anchors(:,a),1),realPoints(anchors(:,a),2),'-d',...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor','g',...
            'MarkerSize',3);
    end
    axis equal square
    hold off
end
foo=sprintf('%s.eps',filename);
print('-depsc',foo);
foo=sprintf('%s.png',filename);
print('-dpng',foo);
return;