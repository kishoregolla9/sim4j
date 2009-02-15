function [ h ] = plotAnchorSetVsError( result,radii,folder )
%PLOTANCHORSETVSERROR plot the error of each anchor set

network=result.network;
minRadius=radii(1);
maxRadius=radii(size(radii,2));
h=figure('Name','The Results By Anchor');

numAnchorSets=size(result(1).anchors,1);
numConnectivityPoints=size(result,2);
medianErrors=zeros(numConnectivityPoints,numAnchorSets);
meanErrors=zeros(numConnectivityPoints,numAnchorSets);
minErrors=zeros(numConnectivityPoints,numAnchorSets);
maxErrors=zeros(numConnectivityPoints,numAnchorSets);
for i=1:size(result,2)
    if result(i).connectivity > 10
        maxErrors(i,:)=result(i).maxErrorPerAnchorSet;
        medianErrors(i,:)=result(i).medianErrorPerAnchorSet;
        meanErrors(i,:)=result(i).meanErrorPerAnchorSet;
        minErrors(i,:)=result(i).minErrorPerAnchorSet;
    else
        fprintf(1,'Result %.0f has a low connectivity (%f)\n',i,result.connectivity);
    end
end

dataToPlot=[mean(maxErrors);mean(meanErrors);mean(medianErrors);mean(minErrors)];
bar3(dataToPlot,'detached');
grid on
plotTitle=sprintf('Network %s',network.shape);
title({plotTitle,'Median of Error Statistic','for radii making network with connectivity > 10'});
zlabel({'Location Error','(factor of radius)'});
xlabel('Anchor Set');
ylabel('Error Statistic');
set(gca,'YTickLabel','Max|Mean|Median|Min');

filename=sprintf('%s\\AnchorSetsVsError-%s-Radius%.1f-to-%.1f.eps',...
    folder,network.shape,minRadius,maxRadius);
print('-depsc',filename);
filename=sprintf('%s\\AnchorSetsVsError-%s-Radius%.1f-to-%.1f.png',...
    folder,network.shape,minRadius,maxRadius);
print('-dpng',filename);