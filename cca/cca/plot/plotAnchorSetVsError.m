function [ h ] = plotAnchorSetVsError( result,folder )
%PLOTANCHORSETVSERROR plot the error of each anchor set

network=result.network;
h=figure('Name','The Results By Anchor');

numAnchorSets=size(result(1).anchors,1);
numConnectivityPoints=size(result,2);
medians=zeros(numConnectivityPoints,numAnchorSets);
mins=zeros(numConnectivityPoints,numAnchorSets);
maxs=zeros(numConnectivityPoints,numAnchorSets);
for i=1:size(result,2)
    if result(i).connectivity > 10
        medians(i,:)=result(i).medianErrorPerAnchorSet;
        mins(i,:)=result(i).minErrorPerAnchorSet;
        maxs(i,:)=result(i).maxErrorPerAnchorSet;
    else
        fprintf(1,'Result %.0f has a low connectivity\n',i);
    end
end

hold off
plot(1:numAnchorSets,median(medians),'-o');
grid on
plotTitle=sprintf('Network %s',network.shape);
title(plotTitle);
xlabel('Anchor Set');
ylabel('Location Error (factor of radius)');
hold all
plot(1:numAnchorSets,median(maxs),'-d');
plot(1:numAnchorSets,median(mins),'-s');
legend('Median Error','Max Error','Min Error');
hold off

filename=sprintf('%s\\AnchorSetsVsError-%s-Radius%.1f-to-%.1f',...
   folder,network.shape,minRadius,maxRadius);
print('-depsc',filename);
print('-dpng',filename);