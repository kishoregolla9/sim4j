function [h]=plotNetworkDiff(network,mappedPoints,anchors,filename)
% Plot the network, showing the anchor nodes with red circles

figurename=sprintf('%s',network.shape);
h=figure('Name',figurename);
hold off
clf
hold all
for i=1:size(network.points,1)
    plot([network.points(i,1),mappedPoints(i,1)],...
        [network.points(i,2),mappedPoints(i,2)],'-dr');
end
plot(network.points(:,1),network.points(:,2),'db');
title({network.shape});

for a=1:size(anchors,2)
    plot(network.points(anchors(:,a),1),network.points(anchors(:,a),2),'-s',...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','g',...
        'MarkerSize',5);
end

hold off
print('-depsc',filename);

return;