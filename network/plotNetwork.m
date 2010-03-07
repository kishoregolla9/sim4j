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
    if (size(anchors,1) > 0)
        zData=mean(result.patchedMap(anchorIndex).differenceVector,2);
    else
        zData=zeros(size(network.points(:,1),1));
    end
    dataToPlot=[network.points(:,1) network.points(:,2) zData];
    gplot(network.connectivity, dataToPlot,'-sb');
    hold all
    xData=network.points(:,1);
    yData=network.points(:,2);
    
    %     fprintf(1,'x: %i %i y: %i %i z: %i %i\n',size(xData),size(yData),size(zData));
    plot3(xData,yData,zData);
    %     ,'o',...
    %         'MarkerEdgeColor','k',...
    %         'MarkerFaceColor','g');%,...
    %'MarkerSize',ms);
    %     maximize(h);
    %     hgsave(h,filename);
    %     set(h,'visible','off');
end

hold all
if (size(anchors,1)>0)
    stats=sprintf('Max: %.2f Mean: %.2f Min: %.2f',...
        mean([result.errors(anchorIndex,:).max]),...
        mean([result.errors(anchorIndex,:).mean]),...
        mean([result.errors(anchorIndex,:).min]));
else
    stats='';
end
title({network.shape;radiusString;suffix;stats});

%% Plot Anchor Nodes
hold all
c=['r','c','g','k'];
for s=1:size(anchors,1)
    for a=1:size(anchors,2)
        xData=network.points(anchors(s,a),1);
        yData=network.points(anchors(s,a),2);
        zData=mean(result.patchedMap(anchorIndex).differenceVector(anchors(s,a)),2);
        %         fprintf(1,'Anchors: x: %i %i y: %i %i z: %i %i\n',size(xData),size(yData),size(zData));
        plot3(xData,yData,zData,'^',...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',c(mod(s-1,size(c,2))+1),...
            'MarkerSize',10);
        [rFigX,rFigY]=dsxy2figxy(gca,radius,radius);
        [xFig,yFig]=dsxy2figxy(gca,xData-radius,yData-radius);
        xFig=max([0 xFig]);
        yFig=max([0 yFig]);
        rFigX=min([1 rFigX]);
        rFigY=min([1 rFigY]);
        annotation('ellipse',[xFig,yFig,rFigX,rFigY]);
    end
end

hold off

return;