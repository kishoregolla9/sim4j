function plotAnchorSetVsError( results,radii,folder )
%PLOTANCHORSETVSERROR plot the error of each anchor set

network=results.network;
minRadius=radii(1);
maxRadius=radii(size(radii,2));
figure('Name','Anchor Set By Anchor');

numAnchorSets=size(results(1).anchors,1);
numConnectivityPoints=size(results,2);
medianErrors=zeros(numConnectivityPoints,numAnchorSets);
meanErrors=zeros(numConnectivityPoints,numAnchorSets);
minErrors=zeros(numConnectivityPoints,numAnchorSets);
maxErrors=zeros(numConnectivityPoints,numAnchorSets);
for i=1:size(results,2)
    if results(i).connectivity > 10
        maxErrors(i,:)=results(i).maxErrorPerAnchorSet;
        medianErrors(i,:)=results(i).medianErrorPerAnchorSet;
        meanErrors(i,:)=results(i).meanErrorPerAnchorSet;
        minErrors(i,:)=results(i).minErrorPerAnchorSet;
    else
        fprintf(1,'Result %.0f has a low connectivity (%f)\n',i,results.connectivity);
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