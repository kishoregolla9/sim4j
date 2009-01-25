function [h1]=plotResult(result,minRadius,maxRadius,folder)

network=result.network;
h1=figure('Name','The Results by Connectivity');
hold off
plot([result.connectivity],[result.meanError],'-o');
grid on
plotTitle=sprintf('Network %s',network.shape);
title(plotTitle);
xlabel('Network Connectivity');
ylabel('Location Error (factor of radius)');
hold all
plot([result.connectivity],[result.maxError],'-d');
plot([result.connectivity],[result.minError],'-s');
legend('Mean Error','Max Error','Min Error');
hold off

filename=sprintf('%s\\Connectivity-vs-Error-%s-Radius%.1f-to-%.1f.eps',...
   folder,network.shape,minRadius,maxRadius);
print('-depsc',filename);

figure('Name','The Results By Anchor');

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

filename=sprintf('%s\\AnchorSetsVsError-%s-Radius%.1f-to-%.1f.eps',...
   folder,network.shape,minRadius,maxRadius);
print('-depsc',filename);


