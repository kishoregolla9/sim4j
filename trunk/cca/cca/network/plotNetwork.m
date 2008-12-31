function [filename]=plotNetwork(network,anchors,radius)
% Plot the network, showing the anchor nodes with red circles
anchorCoordinates=sprintf('(%.3f,%.3f) ',network.points(anchors,:)');
figurename=sprintf('The Network\nradius=%.1f\nAnchors=%s',radius,anchorCoordinates);
figure('Name',figurename);
hold off
gplot(network.connectivity, network.points,'-db');
hold all
for g=1:size(anchors')
    plot(network.points(anchors(g),1),network.points(anchors(g),2),'-or');
    xArrow=[(network.points(anchors(g),1)+0.5),network.points(anchors(g),1)];
    yArrow=[(network.points(anchors(g),2)-0.5),network.points(anchors(g),2)];
    [arrowx,arrowy]=dsxy2figxy(gca,xArrow,yArrow);
    arrow=annotation('textarrow',arrowx,arrowy);
    content = sprintf('(%4.2f,%4.2f)',xArrow(2), yArrow(2));
    set(arrow,'String',content,'Fontsize',8,'Color','r');

end
hold off
filename=sprintf('results\\network_%s_%.1f.fig',network.shape,radius);
hgsave(filename);

return;