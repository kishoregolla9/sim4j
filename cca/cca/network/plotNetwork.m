function [filename]=plotNetwork(network,anchors,radius,suffix)
% Plot the network, showing the anchor nodes with red circles

radiusString=sprintf('Radio Range: %.1f',radius);
%figurename=sprintf('%s %s',network.shape,radiusString);
%figure('Name',figurename);
hold off
clf
gplot(network.connectivity, network.points,'-db');

title({network.shape;radiusString});
hold all
arrow=zeros(size(anchors,1),size(anchors(1,:),1));
c=['r','b','g','k'];
for a=1:size(anchors,1)
    for g=1:size(anchors(a,:),2)
        plot(network.points(anchors(a,g),1),network.points(anchors(a,g),2),'-or');
        xArrow=[(network.points(anchors(a,g),1)+0.5),network.points(anchors(a,g),1)];
        yArrow=[(network.points(anchors(a,g),2)-0.5),network.points(anchors(a,g),2)];
        [arrowx,arrowy]=dsxy2figxy(gca,xArrow,yArrow);
        arrow(a,g)=annotation('textarrow',arrowx,arrowy);
        content = sprintf('(%4.2f,%4.2f)',xArrow(2), yArrow(2));
        annotationColor=c(mod(a-1,size(c,2))+1);
        set(arrow(a,g),'String',content,'Fontsize',8,'Color',annotationColor);
        fprintf(1,'Plotted anchor %.0f - %.0f - %s\n', a, g, content);
    end
end
hold off
filename=sprintf('results\\network_%s_%.1f.fig',network.shape,radius);
hgsave(filename);

return;