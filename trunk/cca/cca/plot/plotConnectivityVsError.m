function [ h ] = plotConnectivityVsError( result,radii,folder )
%PLOTCONNECTIVITYVSERROR Plot network connectivity vs localization error
%   

network=result.network;
minRadius=radii(1);
maxRadius=radii(size(radii,2));

h=figure('Name','The Results by Connectivity');
hold off
plot([result.connectivity],[result.meanError],'-o');
grid on
plotTitle=sprintf('Network %s',network.shape);
title({'Localization Error',plotTitle});
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
filename=sprintf('%s\\Connectivity-vs-Error-%s-Radius%.1f-to-%.1f.png',...
   folder,network.shape,minRadius,maxRadius);
print('-dpng',filename);

