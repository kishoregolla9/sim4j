%% Plot Same-Anchors Data
h=figure('Name','Different Networks around Same Anchors','visible','off');
% plot(maxErrors,'-^b');
hold all
% plot(meanErrors,'-og');

confidence=0.05;

% [ci]=getConfidenceInterval(confidence,maxErrors');
% mu=mean(maxErrors,2);
% errorbar(mu,ci,'x');

[ci]=getConfidenceInterval(confidence,meanErrors');
mu=mean(meanErrors,2);
errorbar(mu,ci,'o');

for i=1:size(meanErrors,1)
   plot(repmat(i,size(meanErrors,2)),meanErrors(i,:),'rx')'
end

xlabel('Anchor Index');
ylabel('Location Error');
numAnchorSets
%axis( [0 size(maxErrors,1) 0 1] )
legend({'Mean'});
saveFigure(folderAll,'SameAnchors',h);
hold off
% close
