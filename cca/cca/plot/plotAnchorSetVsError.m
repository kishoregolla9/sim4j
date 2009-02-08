function [ h ] = plotAnchorSetVsError( result,radii,folder )
%PLOTANCHORSETVSERROR plot the error of each anchor set

network=result.network;
minRadius=radii(1);
maxRadius=radii(size(radii,2));
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
        fprintf(1,'Result %.0f has a low connectivity (%f)\n',i,result.connectivity);
    end
end

bar3([median(maxs);median(medians);median(mins)],'detached');
grid on
legend('Median Error','Max Error','Min Error');
plotTitle=sprintf('Network %s',network.shape);
title({'Median Error for Connectivities > 10',plotTitle});
ylabel('Anchor Set');
zlabel('Location Error (factor of radius)');
% hold off

filename=sprintf('%s\\AnchorSetsVsError-%s-Radius%.1f-to-%.1f.eps',...
   folder,network.shape,minRadius,maxRadius);
print('-depsc',filename);
filename=sprintf('%s\\AnchorSetsVsError-%s-Radius%.1f-to-%.1f.png',...
   folder,network.shape,minRadius,maxRadius);
print('-dpng',filename);