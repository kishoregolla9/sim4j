function plotAnchorTriangleHeightVsError( results,anchors,folder )
% Plot distance between the anchors themselves vs error

minRadius=results(1).radius;
maxRadius=results(end).radius;

network=results(1).network;
numAnchorSets=size(anchors,1);

stats=triangleStats(network,anchors);
heights=zeros(numAnchorSets,4);
for s=1:numAnchorSets
    heights(s,1)=stats.heights(s).max;
    heights(s,2)=stats.heights(s).median;
    heights(s,3)=stats.heights(s).min;
    heights(s,4)=stats.heights(s).sum;
end

figure('Name','Anchor Triangle Height vs Error','visible','off');
plotTitle=sprintf('Network %s',strrep(network.shape,'-',' '));
title({'Height of Triangle made by Anchors vs Localization Error',...
    plotTitle});
hold all
grid on
li=1;
for r=1:size(results,2)
    errorPerAnchorSet=zeros(numAnchorSets,2);
    for s=1:numAnchorSets
        % For one start node
        errorPerAnchorSet(s,1)=[results(r).errors(s,1).max];
        errorPerAnchorSet(s,2)=[results(r).errors(s,1).mean];
    end
    
    stats={'Max','Median','Min','Sum'};
    
    hStddev=zeros(4,1);
    hRanges=zeros(4,1);
    
    for i=1:4
        hStddev(i)=std(heights(:,i));
        hRanges(i)=range(heights(:,i));
        fprintf(1,'Std Dev of %s: %.2f; Range:%.2f\n',stats{i},hStddev(i),hRanges(i));
    end
    
    [m,index]=min(hStddev./hRanges);
    for i=index:index
        heights=heights./network.radius;
        dataToPlot=[heights(:,i), errorPerAnchorSet(:,1), errorPerAnchorSet(:,2)];
        dataToPlot=sortrows(dataToPlot,1);
        
        correlation1=getCorrelation(dataToPlot(:,1),dataToPlot(:,2));
        correlation2=getCorrelation(dataToPlot(:,1),dataToPlot(:,3));
        
        plot(dataToPlot(:,1),dataToPlot(:,2),'^');
        plot(dataToPlot(:,1),dataToPlot(:,3),'o');
        li=li+1;
    end
end

l1=sprintf('Max error, correlation coefficient=%.2f',correlation1(1,2));
l2=sprintf('Mean error, correlation coefficient=%.2f',correlation2(1,2));

legend({l1,l2},'Location','NorthEast');
xlabel('Height of triangle formed by anchor nodes (factor of radius)');
ylabel('Location Error (factor of radius)');
hold off

filename=sprintf('AnchorTriangleHeightVsError-%s-Radius%.1f-to-%.1f',...
    network.shape,minRadius,maxRadius);
saveFigure(folder,filename);

end

function [correlation] = getCorrelation(x,y)
        poly = polyfit(x, y, 2);
        Output = polyval(poly,x);
        correlation = corrcoef(y, Output);
end
