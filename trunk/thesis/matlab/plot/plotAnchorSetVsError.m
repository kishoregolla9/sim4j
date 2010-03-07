function plotAnchorSetVsError( results,anchors,radii,folder )
%PLOTANCHORSETVSERROR plot the error of each anchor set

network=results.network;
minRadius=radii(1);
maxRadius=radii(size(radii,2));
figure('Name','Anchor Set By Anchor','visible','off');

numAnchorSets=size(anchors,1);
numConnectivityPoints=size(results,2);
medianErrors=zeros(numConnectivityPoints,numAnchorSets);
meanErrors=zeros(numConnectivityPoints,numAnchorSets);
maxErrors=zeros(numConnectivityPoints,numAnchorSets);
minErrors=zeros(numConnectivityPoints,numAnchorSets);
stdErrors=zeros(numConnectivityPoints,numAnchorSets);
for i=1:size(results,2)
    if results(i).connectivity > 10
        maxErrors=[results(i,:).errorsPerAnchorSet.max];
        medianErrors=[results(i,:).errorsPerAnchorSet.median];
        meanErrors=[results(i,:).errorsPerAnchorSet.mean];
        minErrors=[results(i,:).errorsPerAnchorSet.min];
        stdErrors=[results(i,:).errorsPerAnchorSet.std];
    else
        fprintf(1,'Result %.0f has a low connectivity (%f)\n',i,results.connectivity);
    end
end

dataToPlot=[mean(maxErrors);mean(meanErrors);mean(medianErrors);mean(minErrors);mean(stdErrors)];
bar3(dataToPlot,'detached');

for i=1:size(dataToPlot)
    t=sprintf('%.2f',dataToPlot(i));
    th=text(1,i,dataToPlot(i)+.2,t);
    set(th,'FontSize',15,'Color','cyan');
end

grid on
plotTitle=sprintf('Network %s',network.shape);
title({plotTitle,'Mean of Error Statistic','for radii making network with connectivity > 10'});
zlabel({'Location Error','(factor of radius)'});
xlabel('Anchor Set');
ylabel('Error Statistic');
set(gca,'YTickLabel','Max|Mean|Median|Min|Std');

filename=sprintf('AnchorSetsVsError-%s-Radius%.1f-to-%.1f',...
  network.shape,minRadius,maxRadius);
saveFigure(folder, filename);
