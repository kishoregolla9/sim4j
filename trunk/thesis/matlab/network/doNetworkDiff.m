function [h]=doNetworkDiff(j,s,NUM_MAX_TO_SHOW,plottitle,patchedMaps,realPoints,...
    network,result,allAnchors,folder,prefix,showStats)

set(0,'DefaultAxesColorOrder',[0 0 0]);
set(gca,'box','on');

r=result.radius;
if showStats
    foldersuffix='withstats';
else
    foldersuffix='nostats';
end
filename=sprintf('networkdiffs-%s/NetDiff-R%.1f-Rank%i-AnchorSet%i%s',...
    foldersuffix,r,j,s,prefix);
if figureExists(folder,filename) ~= 0
    fprintf('Plot for Network Difference for Anchor Set #%i %s already exists\n',s,prefix);
    return;
end

startPlotting=tic;

h=figure('Name',['Network Difference' plottitle],'visible','off');
fprintf('Plotting Network Difference for Anchor Set #%i %s',s,prefix);
mappedPoints=patchedMaps(s).mappedPoints;
anchors=allAnchors(s,:);

hold all

% Include connectivity in plots
%     dataToPlot=[realPoints(:,1) realPoints(:,2)];
%     gplot(network.connectivity, dataToPlot,':db');
%     foo=findobj('type','line');
%     set(foo,'MarkerSize',3);
%
%     dataToPlot=[mappedPoints(:,1) mappedPoints(:,2)];
%     gplot(network.connectivity, dataToPlot,':oc');
%     foo=findobj('type','line');
%     set(foo,'MarkerSize',3);

% Show a line from each real to each mapped point (red circles)
for i=1:size(realPoints,1)
    pa=plot([realPoints(i,1),mappedPoints(i,1)],...
        [realPoints(i,2),mappedPoints(i,2)],'-','MarkerSize',3);
end
labels={'Difference'};

% Overlay the real points with blue diamonds
% to distinguish them from the mapped points
pb=plot(realPoints(:,1),realPoints(:,2),'d','MarkerSize',4);
labels{end+1} = 'Real Points';

% Overlay the mapped points with cyan circles
% to distinguish them from the mapped points
pc=plot(mappedPoints(:,1),mappedPoints(:,2),'o','MarkerSize',4);
labels{end+1} = 'Mapped Points';

if (showStats)
    % Show the worst (max error) points with stars
    distanceVector=patchedMaps(s).distanceVector;
    m=getMaxErrorPoints(distanceVector,NUM_MAX_TO_SHOW);
    for i=1:size(m,1)
        %p=pentagram(star),k=black
        pd=plot(realPoints(m(i),1),realPoints(m(i),2),'p','MarkerSize',12);
    end
    labels{end+1} = 'Max Error';
    m=getMinErrorPoints(distanceVector,NUM_MAX_TO_SHOW);
    for i=1:size(m,1)
        %p=pentagram(star),g=green
        pe=plot(realPoints(m(i),1),realPoints(m(i),2),'p','MarkerSize',12);
    end
    labels{end+1} = 'Min Error';
end
% Show a circle of the radius around each anchor point
% and Draw the Anchor Triangle
pf=plotAnchorTriangle(anchors,realPoints,r,'','d','--','--');
labels{end+1} = 'Anchor Node (real)';
pg=plotAnchorTriangle(anchors,mappedPoints,r,'','o',':',':');
labels{end+1} = 'Anchor Node (mapped)';

% Draw a rectangle around the "real" area
width=ceil(max(realPoints(:,1)));
height=ceil(max(realPoints(:,2)));
if (width == 0); width = 1; end
if (height == 0); height = 1; end
% rectangle('Position',[0,0,width,height],'Curvature',[0,0],...
%     'LineWidth',2,'LineStyle','--');
xlim([0,width]);
ylim([0,height]);


% minX=floor(min(min(realPoints(:,1),min(mappedPoints(:,1)))));
% minY=floor(min(min(realPoints(:,1),min(mappedPoints(:,1)))));
% maxX=ceil(max(max(realPoints(:,1),max(mappedPoints(:,1)))));
% maxY=ceil(max(max(realPoints(:,2),max(mappedPoints(:,2)))));
% minAll=min(minX,minY);
% maxAll=max(maxX,maxY);
% axis([minAll maxAll minAll maxAll]);
grid on

% if showStats
%     legend([pa pb pc pd pe pf pg],labels,'Location','BestOutside');
% else
%     legend([pa pb pc pf pg],labels,'Location','BestOutside');
% end

textLeft=0.75;

if (showStats)
    
    %% Error Stats
    stats=sprintf('Max:  x=%.3f y=%.3f (%.3f)\n',...
        result.coordinateErrors(s,:).max,...
        result.errorsPerAnchorSet(s).max);
    stats=sprintf('%sMean: x=%.3f y=%.3f (%.3f)\n',stats,...
        result.coordinateErrors(s,:).mean,...
        result.errorsPerAnchorSet(s).mean);
    stats=sprintf('%sMin:  x=%.3f y=%.3f (%.3f)\n',stats,...
        result.coordinateErrors(s,:).min,...
        result.errorsPerAnchorSet(s).min);
    text(textLeft,0.7,stats,...
        'Units','normalized ','VerticalAlignment','Top');
    
    %% Triangle Stats
    realTriangle=zeros(3,2);
    mappedTriangle=zeros(3,2);
    for i=1:size(anchors,2)
        realTriangle(i,:)=network.points(anchors(1,i),:);
        mappedTriangle(i,:)=result.patchedMap(s).mappedPoints(anchors(1,i),:);
    end
    [d,slopes]=deviationOfSlopes(realTriangle);
    [realArea,realEdges]=triangleArea(realTriangle);
    [mapArea,mapEdges]=triangleArea(mappedTriangle);
    realHeight=2*realArea/max(realEdges);
    mapHeight=2*realArea/max(mapEdges);
    stats=sprintf('Area: r%.2f m%.2f\nHeight:%.2f %.2f\nSlopes: %.2f %.2f %.2f\nDevSlopes: %.2f',...
        realArea,mapArea,realHeight,mapHeight,...
        slopes,d);
    text(textLeft,0.6,'Triangle Stats',...
        'Units','normalized ','VerticalAlignment','Top','FontWeight','bold');
    text(textLeft,0.56,stats,...
        'Units','normalized ','VerticalAlignment','Top');
    
    %% Transform Stats
    transform=result.transform(s);
    rot=(acos(transform.T(1,1)))*180/pi;
    ref=(acos(transform.T(1,1))/2)*180/pi;
    scalarString=sprintf('Scalar: %.2f ',transform.b);
    if (size(transform,1) == 2)
        rotateString=sprintf('Rotate/Reflect:\n[ %.4f %.4f ] \n[ %.4f %.4f ]\ndet=%.2f ref=%.2f rot=%.2f\ndissimiliariy=%.2f',...
            transform.T(1,1),transform.T(1,2),...
            transform.T(2,1),transform.T(2,2),...
            det(transform.T),rot,ref,...
            result.dissimilarity(s));
    else
        rotateString=sprintf('Rotate/Reflect:\n[ %.4f ]\ndet=%.2f ref=%.2f rot=%.2f\ndissimiliariy=%.2f',...
            transform.T(1,1),det(transform.T),rot,ref,result.dissimilarity(s));
    end
    translateString=sprintf(' %.2f ',transform.c(1,:));
    transformString=sprintf('%s\nTranslate:\n[%s]\n%s',scalarString,translateString,rotateString);
    text(textLeft,0.4,'Transform',...
        'Units','normalized ','VerticalAlignment','Top','FontWeight','bold');
    text(textLeft,0.36,transformString,...
        'Units','normalized ','VerticalAlignment','Top');
    
    %% Anchor Stats
%     anchorString='';
%     for a=1:size(anchors,2)
%         xDiff=realPoints(anchors(a),1)-mappedPoints(anchors(a),1);
%         yDiff=realPoints(anchors(a),2)-mappedPoints(anchors(a),2);
%         anchorString=sprintf('%sR:%.2f,%.2f M:%.2f,%.2f diff:%.2f,%.2f\n',...
%             anchorString,...
%             realPoints(anchors(a),:)',...
%             mappedPoints(anchors(a),:)',...
%             xDiff,yDiff);
%     end
%     text(textLeft,0.1,'Anchors (R=real, M=mapped)',...
%         'Units','normalized ','VerticalAlignment','Top','FontWeight','bold');
%     text(textLeft,0.06,anchorString,...
%         'Units','normalized ','VerticalAlignment','Top');
    
end

transform=result.transform(s);
Td=transform.T*pi/180;
rot=acosd(transform.T(1,1));
ref=(acosd(transform.T(1,1)));
% ref=(acos(transform.T(1,1))/2) * pi/180;

if (det(transform.T) < 0)
    rotref=sprintf('Reflection: %.2f%c',ref,char(176));
else
    rotref=sprintf('Rotation: %.2f%c',rot,char(176));
end

anchorPoints=realPoints(anchors,:);
d=20;
theta=ref;
mid=[ mean(anchorPoints(:,1)) ; mean(anchorPoints(:,2))];
X=[mid(1)-(d*cosd(theta)) ; mid(1)+(d*cosd(theta)) ];
Y=[mid(2)-(d*sind(theta)) ; mid(2)+(d*sind(theta)) ];
line(X,Y,'LineStyle','--','LineWidth',5);
plot(mid(1),mid(2),'gs','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','g');

temp=sprintf('Max error: %.3fr Mean error: %.3fr, %s',...
    result.errorsPerAnchorSet(s).max,...
    result.errorsPerAnchorSet(s).mean,...
    rotref);
xlabel(temp,'fontsize',15);

%% FINISH
hold off
saveFigure(folder,filename,h);

fprintf(' - done in %.2f seconds\n',toc(startPlotting));
close
end

function [m]=getMaxErrorPoints(distanceVector,num)
m=zeros(num,1);
errors=zeros(num,1);
for i=1:size(distanceVector,1)
    thisError=sum(distanceVector(i,:));
    [c,minIndex]=min(errors);
    if thisError > c
        m(minIndex)=i;
        errors(minIndex)=thisError;
    end
end
end

function [m]=getMinErrorPoints(distanceVector,num)
m=ones(num,1);
errors=ones(num,1);
errors=errors.*1000000;
for i=1:size(distanceVector,1)
    thisError=sum(distanceVector(i,:));
    [c,maxIndex]=max(errors);
    if thisError < c
        m(maxIndex)=i;
        errors(maxIndex)=thisError;
    end
end

end


end

