%% Plot Same-Anchors Data
ccaconfig
confidence=0.05;
h=figure('Name','Different Networks around Same Anchors');%,'visible','off');
hold all
t=sprintf('%s\n%i networks, %i anchor sets',shapeLabel,numNetworks,numAnchorSets);
title(t);

% [ci]=getConfidenceInterval(confidence,maxErrors');
% mu=mean(maxErrors,2);
% errorbar(mu,ci,'x');

hMax=doPlotErrorBars(maxErrors,confidence,'c*');
hMean=doPlotErrorBars(meanErrors,confidence,'rx');

xlabel('Anchor Index');
ylabel('Location Error');
numAnchorSets
% axis( [0 size(maxErrors,1) 0 1] )
legend([hMax, hMean],{'Max','Mean'});
saveFigure(folderAll,'SameAnchors',h);
hold off
% close

