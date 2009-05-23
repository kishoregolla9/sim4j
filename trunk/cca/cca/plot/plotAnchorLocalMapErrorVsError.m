function [ h ] = plotAnchorLocalMapErrorVsError( results,anchors,radii,folder )

network=results.network;
minRadius=radii(1);
maxRadius=radii(size(radii,2));

h=figure('Name','The Results by Connectivity');
hold off

numAnchorSets=size(anchors,1);
labels=cell(size(results,2),1);
for r=1:size(results,2)
    hold all
    sumLocalMapError=zeros(numAnchorSets,1);
    for a=1:numAnchorSets
        sumLocalMapError(a)=sumLocalMapError(a)+...
            sum(results(r).localMaps{1}(a).local_coordinates_error_mean);
    end
    normalized=normalize(sumLocalMapError);
    plot(normalized,mean(results(r).meanErrorPerAnchorSet,2),'-o');
    labels{r}=sprintf('Radius %.2f', results(r).radius);
    hold all;
end

grid on
plotTitle=sprintf('Network %s',network.shape);
title({'Localization Error',plotTitle});
xlabel('Sum of Local Map Errors for all Anchors');
ylabel('Location Error (factor of radius)');
legend(labels);
hold off;

filename=sprintf('AnchorLocalMapError-vs-Error-%s-Radius%.1f-to-%.1f.eps',...
   network.shape,minRadius,maxRadius);
saveFigure(folder,filename);

function [ndat] = normalize(dat)
m = size(dat,2);
ndat = dat;
norms = zeros(m,1);
for i = 1:m
    theNorm=norm(ndat(:,i));
    if theNorm ~= 0
        norms(i) = theNorm;
        ndat(:,i) = ndat(:,i)/norms(i);
    else
        fprintf(1,'The norm of sample %g is 0, sample not normalized!',i);
    end
end

