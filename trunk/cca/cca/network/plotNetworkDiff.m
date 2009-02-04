function [h]=plotNetworkDiff(network,mappedPoints,folder)
% Plot the network, showing the anchor nodes with red circles

radius=network.radius;
anchors=network.anchors;

radiusString=sprintf('Radio Range: %.1f',radius);
figurename=sprintf('%s %s',network.shape,radiusString);
h=figure('Name',figurename);
hold off
clf
hold all
for i=1:size(network.points,1)
    plot([network.points(i,1),mappedPoints(i,1)],...
        [network.points(i,2),mappedPoints(i,2)],'-dr');
end
plot(network.points(:,1),network.points(:,2),'db');


% [xLine,yLine]=dsxy2figxy(gca,[0,network.width],[0,network.height]);
% line1=annotation('line',xLine,yLine);
% set(line1,'LineStyle','--','LineWidth',2);
% [xLine,yLine]=dsxy2figxy(gca,[0,network.width],[network.height,0]);
% line2=annotation('line',xLine,yLine);
% set(line2,'LineStyle','--','LineWidth',2);

title({network.shape;radiusString});
% hold all
% arrow=zeros(size(anchors,1),size(anchors(1,:),1));
% c=['r','c','g','k'];
% for a=1:size(anchors,1)
%     for g=1:size(anchors(a,:),2)
%         plot(network.points(anchors(a,g),1),network.points(anchors(a,g),2),'-s',...
%                 'MarkerEdgeColor','k',...
%                 'MarkerFaceColor',c(mod(a-1,size(c,2))+1),...
%                 'MarkerSize',10);
%         xArrow=[(network.points(anchors(a,g),1)+0.3),network.points(anchors(a,g),1)];
%         yArrow=[(network.points(anchors(a,g),2)-0.3),network.points(anchors(a,g),2)];
%         [arrowx,arrowy]=dsxy2figxy(gca,xArrow,yArrow);
%         arrow(a,g)=annotation('textarrow',arrowx,arrowy);
%         %content = sprintf('(%4.2f,%4.2f)',xArrow(2), yArrow(2));
%         content=sprintf('%.0f',a);
%         set(arrow(a,g),'String',content,'HeadStyle','vback1',...
%             'FontSize',10,'FontWeight','bold','Color',c(mod(a-1,size(c,2))+1));
%     end
% end
% 
% 
% hold off
% filename=sprintf('%s\\network-%s-Radius%.1f.eps',folder,network.shape,radius);
% print('-depsc',filename);

return;