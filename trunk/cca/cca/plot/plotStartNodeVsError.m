function [ h ] = plotStartNodeVsError( results,radii,folder )

network=results.network;
minRadius=radii(1);
maxRadius=radii(size(radii,2));

h=figure('Name','The Results by Start Node');
hold off

grid on
plotTitle=sprintf('Network %s',network.shape);
title({'The Results by Start Node','Localization Error',plotTitle});
xlabel('Start Node');
ylabel('Location Error (factor of radius)');
hold all

for r=1:size(results,2)
    numStartNodes=size(results(r).errors,2);
    startNodeData=zeros(numStartNodes,1);
    for s=1:numStartNodes
        startNodeData(s,1)=mean([results(r).errors(:,s).mean],2);
    end
    size(startNodeData)
    % errors=[results.errors];
    % plots(5)=plot([results.connectivity],mean([errors(:,1).min]),'-s');
    plots(1)=plot(1:numStartNodes,startNodeData,'-d');
    % plots(2)=plot([results.connectivity],mean([errors(:,1).median]),'-x');
    % plots(3)=plot([results.connectivity],mean([errors(:,1).mean]),'-*');
    % plots(4)=plot([results.connectivity],mean([errors(:,1).std]),'-o');
    legend(plots,'Max Error','Median Error','Mean Error','StdDev','Min Error');
    hold off
end
filename=sprintf('Connectivity-vs-Error-%s-Radius%.1f-to-%.1f',...
   network.shape,minRadius,maxRadius);
saveFigure(folder,filename);
