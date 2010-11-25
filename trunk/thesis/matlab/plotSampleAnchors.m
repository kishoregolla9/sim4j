
load ../results/chapter5b/anchors3per1000sets.mat
load ../results/chapter5b/networks.mat
load ../results/chapter5b/result-r2.5-3per1000sets.mat

s=428;

anchorNodes=anchors(s,:);
network=result.network;
patchedMaps=result.patchedMap;
transformedPoints=patchedMaps(s).mappedPoints;
realPoints=network.points;

temp=sprintf('%s/patchedMaps',folder);
vars=loadFile(temp,'patchedMap');
patchedPoints=vars.rawResult;
clear vars

realAnchors=realPoints(anchorNodes,:);
transformedAnchors=transformedPoints(anchorNodes,:);
patchedAnchors=patchedPoints(anchorNodes,:);

h=figure('Name','Sample Anchor Transformation');
grid on
hold all;
% for i=1:size(realAnchors,1)
%     pa=plot([realAnchors(i,1),transformedAnchors(i,1)],...
%         [realAnchors(i,2),transformedAnchors(i,2)],'-k','MarkerSize',3);
% end
% labels{1} = '';

% Overlay the real points with diamonds
% to distinguish them from the transformed points
% pb=plot(realAnchors(:,1),realAnchors(:,2),'dk','MarkerSize',6);
% labels{1} = 'Real Points';

% Overlay the transformed points with circles
% to distinguish them from the transformed points
% pc=plot(transformedAnchors(:,1),transformedAnchors(:,2),'ok','MarkerSize',6);
% labels{end+1} = 'transformed Points';

% Show a circle of the radius around each anchor point
% and Draw the Anchor Triangle
plotAnchorTriangle(anchorNodes,patchedPoints,0,'','^','--',':');
labels{1} = 'Patched Anchors';
plotAnchorTriangle(anchorNodes,realPoints,0,'','d','-','-');
labels{2} = 'Real Anchors';
plotAnchorTriangle(anchorNodes,transformedPoints,0,'','o',':',':');
labels{3} = 'Transformed Anchors';

% xlim([0 network.width]);
% ylim([0 network.height]);
legend(labels);
clear labels


[d, a, transform]=procrustes(realPoints, transformedPoints);
transform.T;

% filename=sprintf('SampleAnchors_%04i%02i%02i_%02i%02i%02i',fix(clock));
saveFigure('..','SampleAnchors',h);

