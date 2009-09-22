function plotAnchorAreaVsError( results,anchors,folder )
% Plot distance between the anchors themselves vs error

minRadius=results(1).radius;
maxRadius=results(end).radius;

network=results(1).network;
numAnchorSets=size(anchors,1);

%% Plot by Area
areas=zeros(numAnchorSets,1);
distances=zeros(numAnchorSets,1);
heights=zeros(numAnchorSets,3);
for s=1:numAnchorSets
    anchorNodes=anchors(s,:);
    numAnchors=size(anchorNodes,2);
    d=zeros(numAnchors*2-1,1);
    d(1)=network.distanceMatrix(anchorNodes(1),anchorNodes(2));
    d(2)=network.distanceMatrix(anchorNodes(2),anchorNodes(3));
    d(3)=network.distanceMatrix(anchorNodes(3),anchorNodes(1));
    areas(s,1)=heron(d(1),d(2),d(3));
    c=centroid(network.points(anchorNodes(:),:));
    distances(s,1)=distance([network.height/2 network.height/2],c);
    
    A=areas(s,1);
    h=zeros(3,1);
    h(1)=2*A/d(2);
    h(2)=2*A/d(3);
    h(3)=2*A/d(1);
    heights(s,1)=max(h);
    heights(s,2)=median(h);
    heights(s,3)=min(h);
end

hold off
figure('Name','Anchor Triangle Area vs Error');
plotTitle=sprintf('Network %s',network.shape);
title({'Area of Triangle made by Anchors vs Localization Error',...
    plotTitle});
grid on
labels=cell(1, size(results,2));
for r=1:size(results,2)
    errorPerAnchorSet=zeros(numAnchorSets,1);
    for s=1:numAnchorSets
        % For one start node
        errorPerAnchorSet(s)=[results(r).errors(s,1).median];
    end    
    
    dataToPlot=[areas, distances, errorPerAnchorSet];
    dataToPlot=sortrows(dataToPlot,1);    
    scatter(dataToPlot(:,1),dataToPlot(:,3),dataToPlot(:,2).*10,dataToPlot(:,2));
    grid on
    labels{r}=sprintf('Radius=%.1f',results(r).radius);
end
legend(labels,'Location','NorthEast');
xlabel('Area of Triangle Anchors');
ylabel('Median Location Error');
hold off

filename=sprintf('AnchorTriangleAreaVsError-%s-Radius%.1f-to-%.1f',...
    network.shape,minRadius,maxRadius);
saveFigure(folder,filename);

end

%% Heron's Area of a Triangle formula
function [triangleArea] = heron(a,b,c)
s=(a+b+c)/2;
triangleArea=sqrt(s*(s-a)*(s-b)*(s-c));
end

function [c] = centroid(v)
c=[(v(1,1)+v(2,1)+v(3,1)) / 3 (v(1,2)+v(2,2)+v(3,2)) / 3];
end

function [d] = distance(a,b)
d=sqrt((b(1)-a(1))^2 + (b(2)-a(2))^2);
end