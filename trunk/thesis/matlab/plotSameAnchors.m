%% Plot Same-Anchors Data
function []=plotSameAnchors(folderAll,ccaconfigfile,shapeLabel,numNetworks,...
    numAnchorSets,maxErrors,meanErrors)    

networkconstants;
run(ccaconfigfile);

doPlotSameAnchors(folderAll,ccaconfigfile,shapeLabel,numNetworks,...
    numAnchorSets,maxErrors,'Max','c*',0.8);
doPlotSameAnchors(folderAll,ccaconfigfile,shapeLabel,numNetworks,...
    numAnchorSets,meanErrors,'Mean','rx',0.8);

doPlotSameAnchors(folderAll,ccaconfigfile,shapeLabel,numNetworks,...
    numAnchorSets,maxErrors,'Max','c*',100);
doPlotSameAnchors(folderAll,ccaconfigfile,shapeLabel,numNetworks,...
    numAnchorSets,meanErrors,'Mean','rx',100);

end

function [] =doPlotSameAnchors(folderAll,ccaconfigfile,shapeLabel,numNetworks,...
    numAnchorSets,errors,desc,pointSpec,threshold)

confidence=0.05;
networkconstants;
run(ccaconfigfile);
name=sprintf('Different Networks around Same Anchors - %s Error',desc);
h=figure('Name',name,'visible','off');
hold all
if (threshold ~= 100)
    x=sprintf('Excluding values < %0.2f',threshold);
else
    x='';
end
t=sprintf('%s\n%i networks, %i anchor sets\n%s Error %s',...
    shapeLabel,numNetworks,numAnchorSets,desc,x);
title(t);

% [ci]=getConfidenceInterval(confidence,maxErrors');
% mu=mean(maxErrors,2);
% errorbar(mu,ci,'x');

for i=1:size(errors,1)
  d=errors(i,:);
  d=d(d<threshold);
  doPlotErrorBars(d,confidence,pointSpec,i);
  
  m=mean(d);
  plot([0 numAnchorSets],[m,m],':');
end

xlabel('Anchor Index');
ylabel('Location Error');
numAnchorSets %#ok<NOPRT>
% axis( [0 size(maxErrors,1) 0 1] )
% legend(p,{d});
if (threshold ~= 100)
    name=sprintf('SameAnchors-%s-less%0.2f',desc,threshold);
else
    name=sprintf('SameAnchors-%s',desc);
end
saveFigure(folderAll,name,h);
hold off
end