function plotVsError( results,r,theTitle,theData,folder )
% Plot the given data vs anchor error

network=results(1).network;

hold off
fig=figure('Name','vs Error','visible','off');
plotTitle=sprintf('Network %s',network.shape);
grid on
labels=cell(1, size(results,2));
title({theTitle,plotTitle});

dataToPlot=[theData, [results(r).errorsPerAnchorSet.median]'];
dataToPlot=sortrows(dataToPlot,1);
plot(dataToPlot(:,1),dataToPlot(:,2),'-o');
labels{r}=sprintf('Radius=%.1f',results(r).radius);

legend(labels,'Location','Best');
xlabel(theTitle);
ylabel('Median location error per anchor set');
axes1=get(fig,'CurrentAxes');
set(axes1,'XScale','log');
hold off

filename=sprintf('%sVsError-r%.1',...
    theTitle,results(r).radius);
saveFigure(folder,filename);

end
