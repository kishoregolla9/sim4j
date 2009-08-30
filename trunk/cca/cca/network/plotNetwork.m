function [h]=plotNetwork(network,anchors,folder,suffix,results,anchorIndex)
% Plot the network, showing the anchor nodes with red circles

radius=network.radius;
radiusString=sprintf('Radio Range: %.1f',radius);
figurename=sprintf('%s %s',network.shape,radiusString);
hold off
%% Plot Network
filename=sprintf('%s/network.fig',folder);
if (exist(filename,'file') ~= 0)
    h=hgload(filename);
    maximize(h);
else
    h=figure('Name',figurename,'visible','off');
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
    hgsave(h,filename);
end

stats=sprintf('Max: %.2f Mean: %.2f Min: %.2f',...
    mean([results(1).errors(anchorIndex,:).max]),...
    mean([results(1).errors(anchorIndex,:).mean]),...
    mean([results(1).errors(anchorIndex,:).min]));

title({network.shape;radiusString;suffix;stats});

%% Plot Anchor Nodes
hold all
% arrow=zeros(size(anchors,1),size(anchors(1,:),1));
c=['r','c','g','k'];
for a=1:size(anchors,1)
    for g=1:size(anchors,2)
        xData=network.points(anchors(a,g),1);
        yData=network.points(anchors(a,g),2);
        plot(xData,yData,'-o',...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',c(mod(a-1,size(c,2))+1),...
            'MarkerSize',10);
    end
end

hold off

%% Save figure
filename=sprintf('network-%s-Radius%i-%s',network.shape,radius,suffix);
saveFigure(folder,filename);

return;