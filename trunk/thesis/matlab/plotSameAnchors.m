%% Plot Same-Anchors Data
h=figure('Name','Different Networks around Same Anchors','visible','off');
% plot(maxErrors,'-^b');
hold all
% plot(meanErrors,'-og');

confidence=0.05;

[ci]=getConfidenceInterval(confidence,maxErrors');
mu=mean(maxErrors,2);
errorbar(mu,ci,'x');

[ci]=getConfidenceInterval(confidence,meanErrors');
mu=mean(meanErrors,2');
errorbar(mu,ci,'o');

xlabel('Network Index');
ylabel('Location Error');
axis( [0 100 0 1] )
legend({'Max','Mean'});
saveFigure(folderAll,'SameAnchors',h);
hold off
close
