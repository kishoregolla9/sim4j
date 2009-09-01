function plotAnchorAreaVsError( results,anchors,radii,folder )
% Plot distance between the anchors themselves vs error

minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
numAnchorSets=size(anchors,1);

%% Plot by Area
areas=zeros(numAnchorSets,1);
for s=1:numAnchorSets
    anchorNodes=anchors(s,:);
    numAnchors=size(anchorNodes,2);
    d=zeros(numAnchors*2-1,1);
    d(1)=network.distanceMatrix(anchorNodes(1),anchorNodes(2));
    d(2)=network.distanceMatrix(anchorNodes(2),anchorNodes(3));
    d(3)=network.distanceMatrix(anchorNodes(3),anchorNodes(1));
    areas(s,1)=heron(d(1),d(2),d(3));
end

%% Plot By Area
figure('Name','Anchor Triangle Area vs Error');
plotTitle=sprintf('Network %s',network.shape);
title({'Area of Triangle made by Anchors vs Localization Error',...
    plotTitle});
hold all
grid on
labels=cell(1, size(results,2));
for r=1:size(results,2)
    errorPerAnchorSet=zeros(numAnchorSets,1);
    for s=1:numAnchorSets
        % For one start node
        errorPerAnchorSet(s)=[results(r).errors(s,1).median];
    end    
    
    dataToPlot=[areas, errorPerAnchorSet];
    dataToPlot=sortrows(dataToPlot,1);    
    plot(dataToPlot(:,1),dataToPlot(:,2),'-o');
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