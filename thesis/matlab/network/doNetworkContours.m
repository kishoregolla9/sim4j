function [h]=doNetworkContours(rank,s,plottitle,patchedMaps,realPoints,...
    network,result,allAnchors,folder,prefix)

set(0,'DefaultAxesColorOrder',[0 0 0]);
set(gca,'box','on');

radius=result.radius;
filename=sprintf('networkcontours/NetContours-R%.1f-Rank%i-AnchorSet%i%s',...
    radius,rank,s,prefix);
if figureExists(folder,filename) ~= 0
    fprintf('Plot for Network Contours for Anchor Set #%i %s already exists\n',s,prefix);
    if rank~=1
        return;
    end
end

startPlotting=tic;
hold off
fprintf('Plotting Network Contours for Anchor Set #%i %s',s,prefix);

h=figure('Name',['Network Contours' plottitle],'visible','off');
hold all
distanceVector=patchedMaps(s).distanceVector;
x=network.points(:,1);
y=network.points(:,2);
z=sum(distanceVector,2);

density=zeros(size(x,1),1);
for i=1:size(z,1)
    density(i,1)=size(network.nodes(i).neighbors,2);
end
% z=z/norm(z)-density/norm(density);

plotContours(x,y,z,summer(128),false);
plotAnchorTriangles(realPoints,patchedMaps(s).mappedPoints,allAnchors(s,:),radius);

% ax1=gca;
% ax2 = axes('Position',get(ax1,'Position'),...
%     'XAxisLocation','top',...
%     'YAxisLocation','left',...
%     'Color','none',...
%     'XColor','k','YColor','k');

% plotContours(x,y,density,hsv,true);

% alignGrids(ax1,10);
% alignGrids(ax2,10);
% xlim(ax2,xlim(ax1));
% ylim(ax2,ylim(ax1));
title('Interpolated Mean Error');
% saveFigure(folder,filename,h);
% z=zeros(size(x,1),1);
% for i=1:size(z,1)
%     z(i,1)=size(network.nodes(i).neighbors,2);
% end
% plotContours(x,y,z,summer(128),0.5);
% hold off
saveFigure(folder,filename,h);
hold off
fprintf(' - done in %.2f seconds\n',toc(startPlotting));
close
end

function[]=plotAnchorTriangles(realPoints,mappedPoints,anchors,radius)

% Show a line from each real to each mapped point (red circles)
% for i=1:size(realPoints,1)
%     pa=plot([realPoints(i,1),mappedPoints(i,1)],...
%         [realPoints(i,2),mappedPoints(i,2)],'-','MarkerSize',3);
% end
% labels={'Difference'};

% Overlay the real points with blue diamonds
% to distinguish them from the mapped points
% pb=plot(realPoints(:,1),realPoints(:,2),'d','MarkerSize',4);
% labels{end+1} = 'Real Points';

% Overlay the mapped points with cyan circles
% to distinguish them from the mapped points
% pm=plot(mappedPoints(:,1),mappedPoints(:,2),'o','MarkerSize',4);

% Show a circle of the radius around each anchor point
% and Draw the Anchor Triangle

plotAnchorTriangle(anchors,realPoints,radius,'','d','--','--');
% labels{end+1} = 'Anchor Node (real)';
plotAnchorTriangle(anchors,mappedPoints,radius,'','o',':',':');
% labels{end+1} = 'Anchor Node (mapped)';

% Draw a rectangle around the "real" area
width=ceil(max(realPoints(:,1)));
height=ceil(max(realPoints(:,2)));
if (width == 0); width = 1; end
if (height == 0); height = 1; end
% rectangle('Position',[0,0,width,height],'Curvature',[0,0],...
%     'LineWidth',2,'LineStyle','--');
xlim([0,width]);
ylim([0,height]);

% legend(labels);

% minX=floor(min(min(realPoints(:,1),min(mappedPoints(:,1)))));
% minY=floor(min(min(realPoints(:,1),min(mappedPoints(:,1)))));
% maxX=ceil(max(max(realPoints(:,1),max(mappedPoints(:,1)))));
% maxY=ceil(max(max(realPoints(:,2),max(mappedPoints(:,2)))));
% minAll=min(minX,minY);
% maxAll=max(maxX,maxY);
% axis([minAll maxAll minAll maxAll]);
grid on
end

function [h]=plotAnchorTriangle(anchors,points,radius,color,markerStyle,lineStyle,circleStyle)
for a=1:size(anchors,2)
    xa=points(anchors(:,a),1);
    ya=points(anchors(:,a),2);
    plotLineSpec=sprintf('%s%s',markerStyle,lineStyle);
    h=plot(xa,ya,plotLineSpec,...
        'MarkerEdgeColor','black',...
        'MarkerSize',5);
    theCircle=rectangle('Position',[xa-radius,ya-radius,radius*2,radius*2],'Curvature',[1,1],...
        'LineStyle',circleStyle);

    % A line of the triangle
    triLine=mod(a,size(anchors,2))+1;
    xb=points(anchors(:,triLine),1);
    yb=points(anchors(:,triLine),2);
    l=line([xa,xb],[ya,yb],'LineStyle',lineStyle,'LineWidth',1);
    
    if ~isempty(color)
        set(h,'MarkerFaceColor',color);
        set(theCircle,'EdgeColor',color);
        set(l,'Color',color);
    end
end
end


function alignGrids(ax, ticks)
xlimits = get(ax,'XLim');
ylimits = get(ax,'YLim');
xinc = (xlimits(2)-xlimits(1))/ticks;
yinc = (ylimits(2)-ylimits(1))/ticks;
set(ax,'XTick',[xlimits(1):xinc:xlimits(2)],...
        'YTick',[ylimits(1):yinc:ylimits(2)]);
end
