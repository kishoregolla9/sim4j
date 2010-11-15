function [h]=doNetworkContours(j,s,plottitle,patchedMaps,realPoints,...
    network,result,allAnchors,folder,prefix)

set(0,'DefaultAxesColorOrder',[0 0 0]);
set(gca,'box','on');

r=result.radius;
filename=sprintf('networkcontours/NetDiff-R%.1f-Rank%i-AnchorSet%i%s',...
    r,j,s,prefix);
if figureExists(folder,filename) ~= 0
    fprintf('Plot for Network Difference for Anchor Set #%i %s already exists\n',s,prefix);
    return;
end

startPlotting=tic;
h=figure('Name',['Network Difference' plottitle],'visible','off');
fprintf('Plotting Network Difference for Anchor Set #%i %s',s,prefix);
mappedPoints=patchedMaps(s).mappedPoints;
anchors=allAnchors(s,:);
hold off
hold all
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

distanceVector=patchedMaps(s).distanceVector;

% Show a circle of the radius around each anchor point
% and Draw the Anchor Triangle

plotAnchorTriangle(anchors,realPoints,r,'','d','--','--');
% labels{end+1} = 'Anchor Node (real)';
plotAnchorTriangle(anchors,mappedPoints,r,'','o',':',':');
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

x=network.points(:,1);
y=network.points(:,2);
z=sum(distanceVector,2);
% Determine the minimum and the maximum x and y values:
xmin = min(x); ymin = min(y);
xmax = max(x); ymax = max(y); 
% Define the resolution of the grid:
res=80;
% Define the range and spacing of the x- and y-coordinates,
% and then fit them into X and Y
xv = linspace(xmin, xmax, res);
yv = linspace(ymin, ymax, res);
[Xinterp,Yinterp] = meshgrid(xv,yv); 
% Calculate Z in the X-Y interpolation space, which is an 
% evenly spaced grid:
Zinterp = griddata(x,y,z,Xinterp,Yinterp); 
% Generate the mesh plot (CONTOUR can also be used):
[C,ch]=contour(Xinterp,Yinterp,Zinterp,'k-');
% clabel(C,ch);
% colormap(summer(128))
% colorbar('location','southoutside')
xlabel X; ylabel Y; zlabel Z;

% xa=zeros(size(anchors,2),1);
% ya=zeros(size(anchors,2),1);
% za=zeros(size(anchors,2),1);
% for a=1:size(anchors,2)
%     xa(a)=network.points(anchors(:,a),1);
%     ya(a)=network.points(anchors(:,a),2);
%     za(a)=z(anchors(:,a),1);
% end
% plot3(xa,ya,za,'ok');

transform=result.transform(s);
rot=(acos(transform.T(1,1)));
ref=(acos(transform.T(1,1))/2);

if (det(transform.T) < 0)
    rotref=sprintf('Reflection: %.2f\\pi',ref);
else
    rotref=sprintf('Rotation: %.2f\\pi',rot);
end
    
temp=sprintf('Max error: %.3fr Mean error: %.3fr, %s',...
    result.errorsPerAnchorSet(s).max,...
    result.errorsPerAnchorSet(s).mean,...
    rotref);
% xlabel(temp,'fontsize',15);

%% FINISH
hold off
saveFigure(folder,filename,h);

fprintf(' - done in %.2f seconds\n',toc(startPlotting));
close
end

function [h]=plotAnchorTriangle(anchors,points,r,color,markerStyle,lineStyle,circleStyle)
for a=1:size(anchors,2)
    xa=points(anchors(:,a),1);
    ya=points(anchors(:,a),2);
    plotLineSpec=sprintf('%s%s',markerStyle,lineStyle);
    h=plot(xa,ya,plotLineSpec,...
        'MarkerEdgeColor','black',...
        'MarkerSize',5);
    theCircle=rectangle('Position',[xa-r,ya-r,r*2,r*2],'Curvature',[1,1],...
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
