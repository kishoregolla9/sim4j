function [ h ] = plotConnectivityVsError( results,radii,folder )
%plotConnectivityVsError Plot network connectivity vs localization error

network=results.network;
minRadius=radii(1);
maxRadius=radii(size(radii,2));

h=figure('Name','The Results by Connectivity');
hold off

sigma=zeros(size(results,2),2);
for i=1:size(results,2)
    sigma(i,:)=std(results(i).patchedMap(1).differenceVector);
end
sigma=mean(sigma,2);
%plot([results.connectivity],mean([results.meanError]),'-o');

grid on
plotTitle=sprintf('Network %s',network.shape);
title({'The Results by Connectivity','Localization Error',plotTitle});
xlabel('Network Connectivity');
ylabel('Location Error (factor of radius)');
hold all
errorsPerStart=[results.errorsPerStart];
plots(1)=plot([results.connectivity],[errorsPerStart.max],'-d');
plots(2)=plot([results.connectivity],[errorsPerStart.median],'-x');
plots(3)=plot([results.connectivity],[errorsPerStart.mean],'-*');
plots(4)=plot([results.connectivity],[errorsPerStart.std],'-o');
plots(5)=plot([results.connectivity],[errorsPerStart.min],'-s');
plots(5)=plot([results.connectivity],sigma,'-^');
legend(plots,'Max Error','Median Error','Mean Error','Min Error','StdDev');
hold off

filename=sprintf('Connectivity-vs-Error-%s-Radius%.1f-to-%.1f',...
   network.shape,minRadius,maxRadius);
saveFigure(folder,filename);
