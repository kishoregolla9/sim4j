function [h]=plotNetwork(network,anchors,folder,suffix)
% Plot the network, showing the anchor nodes with red circles

radius=network.radius;
radiusString=sprintf('Radio Range: %.1f',radius);
figurename=sprintf('%s %s',network.shape,radiusString);
hold off
%% Plot Network
filename=sprintf('%s\\network.fig',folder);
if (exist(filename,'file') ~= 0)
    fprintf('Loading network figure from %s\n',filename);
    h=hgload(filename);
    maximize(h);
else
    h=figure('Name',figurename);
    hold off

    gplot(network.connectivity, network.points,'-sb');
    hold all
    xData=network.points(:,1);
    yData=network.points(:,2);
    plot(xData,yData,'s',...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','g',...
        'MarkerSize',6);      
    maximize(h);
%LABEL NODES    
%     for i=1:size(network.points,1)
%         [x,y]=...
%             dsxy2figxy(gca,network.points(i,1),network.points(i,2));
%         annotation('rectangle',x,y,'g');
%         content=sprintf('%.0f',i);
%         textbox=annotation('textbox',[x y 0.1 0.1]);
%         set(textbox,'String',content,...
%             'EdgeColor','none',...
%             'FitBoxToText','off',...
%             'FitHeightToText','off',...
%             'HorizontalAlignment','left',...
%             'VerticalAlignment','bottom',...
%             'Margin',0);
%     end
    hgsave(h,filename);
end

%% Criss-Cross lines
% [xLine,yLine]=dsxy2figxy(gca,[0,network.width],[0,network.height]);
% line1=annotation('line',xLine,yLine);
% set(line1,'LineStyle','--','LineWidth',2);
% [xLine,yLine]=dsxy2figxy(gca,[0,network.width],[network.height,0]);
% line2=annotation('line',xLine,yLine);
% set(line2,'LineStyle','--','LineWidth',2);

title({network.shape;radiusString;suffix});

%% Plot Anchor Nodes
hold all
% arrow=zeros(size(anchors,1),size(anchors(1,:),1));
c=['r','c','g','k'];
for a=1:size(anchors,1)
    for g=1:size(anchors,2)
        xData=network.points(anchors(a,g),1);
        yData=network.points(anchors(a,g),2);
        plot(xData,yData,'-s',...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',c(mod(a-1,size(c,2))+1),...
            'MarkerSize',10);
%         xDataArrow=[(xData+0.3),xData];
%         yDataArrow=[(yData-0.3),yData];
%         [xFigArrow,yFigArrow]=dsxy2figxy(gca,xDataArrow,yDataArrow);
%         arrow(a,g)=annotation('textarrow',xFigArrow,yFigArrow);
%         content=sprintf('%.0f',a);
%         set(arrow(a,g),'String',content,'HeadStyle','vback1',...
%             'FontSize',10,'FontWeight','bold','Color',c(mod(a-1,size(c,2))+1));
    end
end

hold off

%% Save figure
filename=sprintf('network-%s-Radius%i-%s',network.shape,radius,suffix);
saveFigure(folder,filename);

return;