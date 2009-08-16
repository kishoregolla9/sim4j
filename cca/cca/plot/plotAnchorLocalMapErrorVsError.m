function [ h ] = plotAnchorLocalMapErrorVsError( results,anchors,radii,folder,allMaps )

network=results.network;
minRadius=radii(1);
maxRadius=radii(size(radii,2));

h=figure('Name','Anchor Node Local Map Error vs Final Error');
hold off

numAnchorSets=size(anchors,1);
labels=cell(size(results,2),1);
for r=1:size(results,2)
    hold all
    sumLocalMapError=zeros(numAnchorSets,1);
    for a=1:numAnchorSets
        sumLocalMapError(a)=sumLocalMapError(a)+...
            sum(allMaps{r}(a).local_coordinates_error_mean);
    end
    normalized=normalize(sumLocalMapError);
    errorPerAnchorSet=mean([results(r).errors(:,a).mean],1)';
    dataToPlot=[normalized errorPerAnchorSet];
    dataToPlot=sortrows(dataToPlot,1);
    plot(dataToPlot(:,1),dataToPlot(:,2),'-o');
    labels{r}=sprintf('Radius %.2f', results(r).radius);
    hold all;
end

grid on
plotTitle=sprintf('Network %s',network.shape);
title({'Anchor Node Local Map Error vs Final Location Error',plotTitle});
xlabel('Sum of Local Map Errors for each Anchor Set');
ylabel('Location Error (factor of radius)');
legend(labels);
hold off;

filename=sprintf('AnchorLocalMapError-vs-Error-%s-Radius%.1f-to-%.1f.eps',...
   network.shape,minRadius,maxRadius);
saveFigure(folder,filename);

