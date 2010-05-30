function [ h ] = plotConnectivityForEachVsError( results,radii,folder )
%PLOTCONNECTIVITYVSERROR Plot network connectivity vs localization error

network=results.network;
minRadius=radii(1);
maxRadius=radii(size(radii,2));

h=figure('Name','The Results by Connectivity','visible','off');
hold off

sigma=zeros(size(results,2),1);
for i=1:size(results,2)
    sigma(i,:)=std(results(i).patchedMap(1).distanceVector);
end

% labels=cell(1, size(results,2));
% for r=1:size(results,2)
x=[results.connectivity];
y=mean([results.meanError]);
plot(x,y,'-d');
errorbar(x,y,std(y)*ones(size(x)));
    
%     labels{r}=sprintf('%i Radius=%.1f',r,results(r).radius);
%     hold all
% end
grid on
plotTitle=sprintf('Network %s',network.shape);
title({'Localization Error',plotTitle});
xlabel('Network Connectivity');
ylabel('Location Error (factor of radius)');
% legend(labels,'Location','NorthWest');
hold off

filename=sprintf('ConnectivityForEach-vs-Error-%s-Radius%.1f-to-%.1f',...
   network.shape,minRadius,maxRadius);
saveFigure(folder,filename);
