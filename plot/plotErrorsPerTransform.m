function plotErrorsPerTransform( resultsByOperation, folder, filename )
% Plot Errors by transforms

numAnchorSets=size(resultsByOperation(1).errors,1);

hold off
close all
figure1=figure('Name','Errors by Transform','visible','off');
hold all
% grid on
labels=cell(1,4);
d=zeros(5,numAnchorSets);
for operations=1:1:4 
    errors=resultsByOperation(operations).errorsPerAnchorSet;
    d(operations,:)=[errors(:).mean];
end
d(5,:)=1:numAnchorSets; % set the 5th column to the index
% sort descending by 4th column: all transforms error
dataToPlot=fliplr(sortrows(d',4)'); 
for operations=1:4
    prefix=getPrefix(operations);
    labels{operations}=sprintf('Error %s',prefix);
    plot(dataToPlot(operations,:),'-o');
end
legend(labels,'Location','Best');
xlabel({'Anchor Sets Sorted by Total Error','Logarthmic to show worst errors clearly'});
ylabel('Mean Error');

% Label the worst nodes with their Anchor Set Index
for i=1:10
    t=sprintf('#%i',dataToPlot(5,i));
    th=text(i,0.1,t);
    set(th,'FontSize',8);
end

axes1=get(figure1,'CurrentAxes');
set(axes1,'XScale','log');
grid on;
title('Error per Anchor Set for each Transform Operation Skipped');
saveFigure(folder,filename,figure1);
hold off


end
