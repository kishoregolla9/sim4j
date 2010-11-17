function plotRotRef( results,anchors,radii,folder )
% Plot rotation and reflection vs error

numAnchorSets=size(anchors,1);
result=results(1);
figName='RotRef vs Error';

% width=result.network.width;
% height=result.network.height;
% realstats=triangleStats(result.network.points,anchors,width,height);

rot=zeros(1,numAnchorSets,1);
ref=zeros(1,numAnchorSets,1);
t1=zeros(1,numAnchorSets,1);
t2=zeros(1,numAnchorSets,1);
m=zeros(1,numAnchorSets,1);
% areaDiff=zeros(1,numAnchorSets,1);
% heightDiff=zeros(1,numAnchorSets,1);

for s=1:numAnchorSets
    transform=result.transform(s);
    % +1==rotation, -1==reflection
    if (det(transform.T) < 0)
        ref(1,s)=(acosd(transform.T(1,1))/2);
        rot(1,s)=NaN;
    else
        ref(1,s)=NaN;
        rot(1,s)=(acosd(transform.T(1,1)));
    end
    t1(1,s)=transform.c(1,1);
    t2(1,s)=transform.c(1,2);

    slopes=zeros(1,size(anchors,2));
    anchorNodes=anchors(s,:);
    anchorPoints=result.network.points(anchorNodes,:);
    for i=1:size(anchors,2)
        slopes(i)=(anchorPoints(i,2) - anchorPoints(mod(i+1,size(anchors,2))+1,2)) / ...
            (anchorPoints(i,1) - anchorPoints(mod(i+1,size(anchors,2))+1,1));
    end
    m(1,s)=atand(mean(slopes));
    
%     mappedstats=triangleStats(result.patchedMap(s).mappedPoints,anchors(s,:),width,height);
%     areaDiff(1,s)=percentDiff(realstats.areas(s),mappedstats.areas);
%     heightDiff(1,s)=percentDiff([realstats.heights(s).min],[mappedstats.heights.min]);
end

if (exist('threshold','var')==0)
    threshold=100;
end

h=plotSingleDataSet(figName,'Rotation',results,anchors,radii,...
    rot,folder,threshold,false,0,{'o'});
h=plotSingleDataSet(figName,'Reflection',results,anchors,radii,...
    ref,folder,threshold,false,h,{'x'});

ax1=gca;
% ax2 = axes('Position',get(ax1,'Position'),...
%            'XAxisLocation','top',...
%            'YAxisLocation','left',...
%            'Color','none',...
%            'XColor','r','YColor','r');

% h=plotSingleDataSet(figName,'Area Diff',results,anchors,radii,...
%     areaDiff,folder,threshold,false,h,{'s'});
% plotSingleDataSet(figName,'Min Height Diff',results,anchors,radii,...
%     heightDiff,folder,threshold,false,h,{'^'});

% ylim(ax2,ylim(ax1));
% alignGrids(ax1,6);
% alignGrids(ax2,6);

legend(ax1,{'Rotation','Reflection','Area Diff'});
% legend(ax2,{'Area Diff','Min Height Diff'});
xlabel(ax1,'Angle of Rotation or Reflection (degrees)');
minRadius=radii(1);
maxRadius=radii(size(radii,2));
prefix=strrep(figName,' ','_');
filename=sprintf('%s-%s-Radius%.1f-to-%.1f',...
    prefix,result.network.shape,minRadius,maxRadius);
if (threshold < 100)
    filename=sprintf('%s-Excluding%0.1f',filename,threshold);
end
saveFigure(folder,filename);

end

function alignGrids(ax, ticks)
xlimits = get(ax,'XLim');
% ylimits = get(ax,'YLim');
xinc = (xlimits(2)-xlimits(1))/ticks;
% yinc = (ylimits(2)-ylimits(1))/5;
set(ax,'XTick',xlimits(1):xinc:xlimits(2)); %,...
%         'YTick',ylimits(1):yinc:ylimits(2))
end

function [d]=percentDiff(x,y)
    d=100*(y-x)/x;
end