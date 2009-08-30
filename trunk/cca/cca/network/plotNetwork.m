function [h]=plotNetwork(network,anchors,folder,suffix,result,anchorIndex)
% Plot the network, showing the anchor nodes with red circles

radius=network.radius;
radiusString=sprintf('Radio Range: %.1f',radius);
figurename=sprintf('%s %s',network.shape,radiusString);
hold off
%% Plot Network
filename=sprintf('%s/network-radius%.1f.fig',folder,radius);
if (exist(filename,'file') ~= 0)
    h=hgload(filename);
    maximize(h);
    set(h,'visible','off');    
else
    hold off
    h=figure('Name',figurename,'visible','off');
    gplot(network.connectivity, network.points,'-sb');
    hold all
    xData=network.points(:,1);
    yData=network.points(:,2);
    plot(xData,yData,'s',...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','g',...
        'MarkerSize',6);      
    maximize(h);
    hgsave(h,filename);
    set(h,'visible','off');    
end

stats=sprintf('Max: %.2f Mean: %.2f Min: %.2f',...
    mean([result.errors(anchorIndex,:).max]),...
    mean([result.errors(anchorIndex,:).mean]),...
    mean([result.errors(anchorIndex,:).min]));

title({network.shape;radiusString;suffix;stats});

%% Plot Anchor Nodes
hold all
% arrow=zeros(size(anchors,1),size(anchors(1,:),1));
c=['r','c','g','k'];
for s=1:size(anchors,1)
    for a=1:size(anchors,2)
        xData=network.points(anchors(s,a),1);
        yData=network.points(anchors(s,a),2);
        plot(xData,yData,'o',...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',c(mod(s-1,size(c,2))+1),...
            'MarkerSize',10);
        [xFig,yFig]=dsxy2figxy(gca,xData-radius,yData-radius);
        [rFig]=dsxy2figxy(gca,radius,radius);
        xFig=max([0 xFig]);
        yFig=max([0 yFig]);
        rFig=min([1 rFig]);
        [xFig yFig rFig rFig]
        annotation('ellipse',[xFig,yFig,rFig,rFig]);
    end
end

hold off

return;