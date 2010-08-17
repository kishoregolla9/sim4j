function plotAnchorTriangleHeightVsError( results,anchors,folder )
% Plot distance between the anchors themselves vs error

minRadius=results(1).radius;
maxRadius=results(end).radius;

network=results(1).network;
numAnchorSets=size(anchors,1);

heights=zeros(numAnchorSets,4);
for s=1:numAnchorSets
    anchorNodes=anchors(s,:);
    d=zeros(3,1);
    d(1)=network.distanceMatrix(anchorNodes(1),anchorNodes(2));
    d(2)=network.distanceMatrix(anchorNodes(2),anchorNodes(3));
    d(3)=network.distanceMatrix(anchorNodes(3),anchorNodes(1));
    A=heron(d(1),d(2),d(3));
    h=zeros(3,1);
    h(1)=2*A/d(2);
    h(2)=2*A/d(3);
    h(3)=2*A/d(1);
    heights(s,1)=max(h);
    heights(s,2)=median(h);
    heights(s,3)=min(h);
    heights(s,4)=sum(h);
end


figure('Name','Anchor Triangle Height vs Error'); %,'visible','off');
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
        plot(dataToPlot(:,1),dataToPlot(:,2),'-^');
        plot(dataToPlot(:,1),dataToPlot(:,3),'-o');
        li=li+1;
    end
end
legend({'Max error','Mean error'},'Location','NorthEast');
xlabel('Height of triangle formed by anchor nodes (factor of radius)');
ylabel('Location Error (factor of radius)');
hold off

filename=sprintf('AnchorTriangleHeightVsError-%s-Radius%.1f-to-%.1f',...
    network.shape,minRadius,maxRadius);
saveFigure(folder,filename);

end

%% Heron's Area of a Triangle formula
function [triangleArea] = heron(a,b,c)
s=(a+b+c)/2;
triangleArea=sqrt(s*(s-a)*(s-b)*(s-c));
end