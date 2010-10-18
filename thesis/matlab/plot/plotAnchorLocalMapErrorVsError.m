function [ h ] = plotAnchorLocalMapErrorVsError( results,anchors,radii,folder,allMaps )

network=results.network;
minRadius=radii(1);
maxRadius=radii(size(radii,2));

h=figure('Name','Anchor Set Local Map Error vs Final Error','visible','off');
hold off

numAnchorSets=size(anchors,1);
anchorsPerSet=size(anchors,2);
labels=cell(size(results,2),1);
for r=1:size(results,2)
    hold all
    sumLocalMapError=zeros(numAnchorSets,1);
    errorPerAnchorSet=zeros(numAnchorSets,1);
    for s=1:numAnchorSets
        anchorSet=anchors(s,:);
        for a=1:size(anchorSet,2)
            sumLocalMapError(s)=sumLocalMapError(s)+...
                sum(allMaps(r,anchorSet(a)).local_coordinates_error_mean);
        end
        errorPerAnchorSet(s)=mean([results(r).errors(s,:).mean],2);
    end
    dataToPlot=[sumLocalMapError./anchorsPerSet errorPerAnchorSet];
    dataToPlot=sortrows(dataToPlot,1);
    plot(dataToPlot(:,1),dataToPlot(:,2),'-o');
    labels{r}=sprintf('Radius %.2f', results(r).radius);
    hold all;
end

grid on
plotTitle=sprintf('Network %s',network.shape);
title({'Anchor Node Local Map Error vs Final Location Error',plotTitle});
xlabel('Mean Local Map Errors for each Anchor Set');
ylabel('Mean Location Error (factor of radius)');
legend(labels);
hold off;

filename=sprintf('AnchorLocalMapError-vs-Error-%s-Radius%.1f-to-%.1f.eps',...
   network.shape,minRadius,maxRadius);
saveFigure(folder,filename);
