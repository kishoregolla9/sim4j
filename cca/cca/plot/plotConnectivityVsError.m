function [ h ] = plotConnectivityVsError( results,radii,folder )
%PLOTCONNECTIVITYVSERROR Plot network connectivity vs localization error

network=results.network;
minRadius=radii(1);
maxRadius=radii(size(radii,2));

h=figure('Name','The Results by Connectivity');
hold off

sigma=zeros(size(results,2),2);
for i=1:size(results,2)
    sigma(i,:)=std(results(i).patchedMap(1).differenceVector);
end

plot([results.connectivity],[results.meanError],'-o');
grid on
plotTitle=sprintf('Network %s',network.shape);
title({'Localization Error',plotTitle});
xlabel('Network Connectivity');
ylabel('Location Error (factor of radius)');
hold all
plot([results.connectivity],[results.medianError],'-x');
plot([results.connectivity],[results.maxError],'-d');
plot([results.connectivity],[results.minError],'-s');
plot([results.connectivity],sigma);
legend('Mean Error','Median Error','Max Error','Min Error','StdDev');
hold off

filename=sprintf('%s\\Connectivity-vs-Error-%s-Radius%.1f-to-%.1f.eps',...
   folder,network.shape,minRadius,maxRadius);
print('-depsc',filename);
filename=sprintf('%s\\Connectivity-vs-Error-%s-Radius%.1f-to-%.1f.png',...
   folder,network.shape,minRadius,maxRadius);
print('-dpng',filename);

