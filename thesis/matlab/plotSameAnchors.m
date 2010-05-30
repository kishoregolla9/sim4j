%% Plot Same-Anchors Data
function []=plotSameAnchors(folderAll,ccaconfigfile,shapeLabel,numNetworks,...
    numAnchorSets,maxErrors,meanErrors)    

networkconstants;
run(ccaconfigfile);

doPlotSameAnchors(folderAll,ccaconfigfile,shapeLabel,numNetworks,...
    numAnchorSets,maxErrors,'Max','c*');
doPlotSameAnchors(folderAll,ccaconfigfile,shapeLabel,numNetworks,...
    numAnchorSets,meanErrors,'Mean','rx');

end

function [] =doPlotSameAnchors(folderAll,ccaconfigfile,shapeLabel,numNetworks,...
    numAnchorSets,errors,d,pointSpec)

confidence=0.05;
networkconstants;
run(ccaconfigfile);
name=sprintf('Different Networks around Same Anchors - %s Error',d);
h=figure('Name',name);%,'visible','off');
hold all
t=sprintf('%s\n%i networks, %i anchor sets\n%s Error',...
    shapeLabel,numNetworks,numAnchorSets,d);
title(t);

% [ci]=getConfidenceInterval(confidence,maxErrors');
% mu=mean(maxErrors,2);
% errorbar(mu,ci,'x');

for i=1:size(errors,1)
  d=errors(i,:);
  d=d(d<0.8);
  doPlotErrorBars(d,confidence,pointSpec);
end

hold on;
for i=1:size(errors,1)
   m=mean(errors(i,:));
   plot([0 size(errors,2)],[m,m],':');
end

xlabel('Anchor Index');
ylabel('Location Error');
numAnchorSets %#ok<NOPRT>
% axis( [0 size(maxErrors,1) 0 1] )
% legend(p,{d});
name=sprintf('SameAnchors-%s',d);
saveFigure(folderAll,name,h);
hold off
end