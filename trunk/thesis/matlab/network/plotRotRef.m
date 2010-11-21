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
c=zeros(2,numAnchorSets,1);
m=zeros(1,numAnchorSets,1);
b=zeros(1,numAnchorSets,1);
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
    c(1,s)=transform.c(1,1);
    c(2,s)=transform.c(1,2);
    b(1,s)=transform.b;
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
plotSingleDataSet(figName,'Reflection',results,anchors,radii,...
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

legend(ax1,{'Rotation','Reflection'});
% legend(ax2,{'Area Diff','Min Height Diff'});
xlabel(ax1,'Angle of Rotation or Reflection (degrees)');
xlim([0 180]);

prefix=strrep(figName,' ','_');
saveFigure(folder,prefix);


plotSingleDataSet('TransformScalar','Transformation Scale Factor (b)',results,anchors,radii,...
    b,folder,threshold,false,0,{'o'});
close all
h=plotSingleDataSet('TransformTranslate','Translation Factor (c)',results,anchors,radii,...
    c(1,:),folder,threshold,false,0,{'x'});
h=plotSingleDataSet('TransformTranslate','Translation Factor (c)',results,anchors,radii,...
    c(2,:),folder,threshold,false,h,{'v'});
legend({'X Translation Factor (c)','Y Translation Factor (c)'});
saveFigure(folder,'TransformTranslate',h);

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