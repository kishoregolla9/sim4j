function [h]=plotNetworkDiff(network,mappedPoints,anchors,plottitle,filename)
% Plot the network, showing the anchor nodes with red circles

h=figure('Name',plottitle);
hold all
for i=1:size(network.points,1)
    plot([network.points(i,1),mappedPoints(i,1)],...
        [network.points(i,2),mappedPoints(i,2)],'-dr');
end
plot(network.points(:,1),network.points(:,2),'db');
title(plottitle);

for a=1:size(anchors,2)
    plot(network.points(anchors(:,a),1),network.points(anchors(:,a),2),'-s',...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','g',...
        'MarkerSize',5);
end

hold off
foo=sprintf('%s.eps',filename);
print('-depsc',foo);
foo=sprintf('%s.png',filename);
print('-dpng',foo);
return;