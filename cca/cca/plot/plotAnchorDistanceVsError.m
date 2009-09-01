function plotAnchorDistanceVsError( results,anchors,radii,folder )
% Plot distance between the anchors themselves vs error

minRadius=radii(1);
maxRadius=radii(size(radii,2));

network=results(1).network;
numAnchorSets=size(anchors,1);

%% Plot by Perimeter
figure('Name','Anchor Distance vs Error');
plotTitle=sprintf('Network %s',network.shape);
title({'Sum of Distance between All Anchors vs Localization Error',...
    plotTitle});

distances=zeros(numAnchorSets,1);
areas=zeros(numAnchorSets,1);
for s=1:numAnchorSets
    anchorNodes=anchors(s,:);
    numAnchors=size(anchorNodes,2);
    d=zeros(numAnchors*2-1,1);
    d(1)=network.distanceMatrix(anchorNodes(1),anchorNodes(2));
    d(2)=network.distanceMatrix(anchorNodes(2),anchorNodes(3));
    d(3)=network.distanceMatrix(anchorNodes(3),anchorNodes(1));
    areas(s,1)=areaOfTriangle(d(1),d(2),d(3));
	distances(s,1)=sum(d);
    
end

hold all
grid on
labels=cell(1, size(results,2));
for r=1:size(results,2)
    errorPerAnchorSet=zeros(numAnchorSets,1);
    for s=1:numAnchorSets
        % For one start node
        errorPerAnchorSet(s)=[results(r).errors(s,1).max];
    end    
    
    dataToPlot=[distances, errorPerAnchorSet];
    dataToPlot=sortrows(dataToPlot,1);    
    plot(dataToPlot(:,1),dataToPlot(:,2),'-o');
    labels{r}=sprintf('Radius=%.1f',results(r).radius);
end
legend(labels,'Location','NorthEast');
xlabel('Sum of Distance between Anchors');
ylabel('Median Location Error');
hold off

filename=sprintf('AnchorDistanceVsError-%s-Radius%.1f-to-%.1f',...
    network.shape,minRadius,maxRadius);
saveFigure(folder,filename);

%% Plot By Area
figure('Name','Anchor Triange Area vs Error');
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


%% Plot By Number Covered Nodes
figure('Name','Num Anchor Neighbors vs Error');
plotTitle=sprintf('Network %s',network.shape);
title({'Number of Anchor Neighbors vs Localization Error',...
    plotTitle});
hold all
grid on
labels=cell(1, size(results,2));
for r=1:size(results,2)

    numNeighbors=zeros(numAnchorSets,1);
    for s=1:numAnchorSets
        % For one start node
        errorPerAnchorSet(s)=[results(r).errors(s,1).median];
        anchorNodes=anchors(s,:);
        n=getNumUnique(network,anchorNodes);
        numNeighbors(s,1)=numNeighbors(s,1) + n;
    end    
    
    dataToPlot=[numNeighbors, errorPerAnchorSet];
    dataToPlot=sortrows(dataToPlot,1);    
    plot(dataToPlot(:,1),dataToPlot(:,2),'-o');
    labels{r}=sprintf('Radius=%.1f',results(r).radius);
end
legend(labels,'Location','NorthEast');
xlabel('Area of Triangle Anchors');
ylabel('Median Location Error');
hold off

filename=sprintf('AnchorNeighborsVsError-%s-Radius%.1f-to-%.1f',...
    network.shape,minRadius,maxRadius);
saveFigure(folder,filename);

end

function [num] = getNumUnique(network,anchorSet)
    n=[];
    for i=1:size(anchorSet,2)
        n=[n network.nodes(anchorSet(1,i)).neighbors];
    end
    num=size(unique(n),2);
end

function [triangleArea] = areaOfTriangle(a,b,c)
s=(a+b+c)/2;
triangleArea=sqrt(s*(s-a)*(s-b)*(s-c));
end