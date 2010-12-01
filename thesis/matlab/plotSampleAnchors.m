
folder='../results/chapter5b';
% load ../results/chapter5b/anchors3per1000sets.mat
% load ../results/chapter5b/networks.mat
% load ../results/chapter5b/result-r2.5-3per1000sets.mat

s=428;

anchorNodes=anchors(s,:);
network=result.network;
patchedMaps=result.patchedMap;
transformedPoints=patchedMaps(s).mappedPoints;
actualPoints=network.points;

temp=sprintf('%s/patchedMaps',folder);
vars=loadFile(temp,'patchedMap');
localPoints=vars.rawResult;
clear vars

actualAnchors=actualPoints(anchorNodes,:);
localAnchors=localPoints(anchorNodes,:);
transformedAnchors=transformedPoints(anchorNodes,:);

h=figure('Name','Sample Anchor Transformation');
grid on
hold all;
% for i=1:size(actualAnchors,1)
%     pa=plot([actualAnchors(i,1),transformedAnchors(i,1)],...
%         [actualAnchors(i,2),transformedAnchors(i,2)],'-k','MarkerSize',3);
% end
% labels{1} = '';

% Overlay the real points with diamonds
% to distinguish them from the transformed points
% pb=plot(actualAnchors(:,1),actualAnchors(:,2),'dk','MarkerSize',6);
% labels{1} = 'Real Points';

% Overlay the transformed points with circles
% to distinguish them from the transformed points
% pc=plot(transformedAnchors(:,1),transformedAnchors(:,2),'ok','MarkerSize',6);
% labels{end+1} = 'transformed Points';

% Show a circle of the radius around each anchor point
% and Draw the Anchor Triangle
plotAnchorTriangle(anchorNodes,localPoints,0,'','^','--',':');
labels{1} = 'Local Anchor Coordinates';

X=actualAnchors;
Y=localAnchors;
[d, Z, transform]=procrustes(X,Y);
Z=transform.b*Y*transform.T;
plotAnchorTriangle(1:3,Z,0,'','x','-.','-.');
labels{2} = 'Scaled and Rotated';

plotAnchorTriangle(anchorNodes,transformedPoints,0,'','o',':',':');
labels{3} = 'Calculated Global Anchor Coordinates';
plotAnchorTriangle(anchorNodes,actualPoints,0,'','d','-','-');
labels{4} = 'Actual Global Anchor Coordinates';

% xlim([0 network.width]);
% ylim([0 network.height]);
legend(labels,'Location','NorthWest');
clear labels

% filename=sprintf('SampleAnchors_%04i%02i%02i_%02i%02i%02i',fix(clock));
saveFigure('..','SampleAnchors',h);
