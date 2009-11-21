function [Z,tr] = transformMap(realPoints, patchedPoints, anchorNodes, ...
    operations,folder,label)
% Transform the map using the procrustes algorithm
% realPoints: the input points (only anchor nodes are used)
% patchedPoints: the local map points, so far
% anchor Nodes:
% operations: 4 - all
%             3 - no translation
%             2 - no scaling
%             1 - no rotation/reflection

if nargin < 4
    operations=4;
end


n=size(realPoints,1);
%      c:  the translation component (a n x 2 matrix, where each row is
%      identical)
%      T:  the orthogonal rotation and reflection component (2x2 matrix)
%      b:  the scale component (a scalar)
%   That is, Z = tr.b * Y * tr.T + tr.c.
X=realPoints(anchorNodes,:);
Y=patchedPoints(anchorNodes,1:2);

YComplete=patchedPoints(:,1:2);
[d, Z, tr] = procrustes(X, Y);

plotAnchorTransform(folder,label,X,Y,Z);

tr.c=repmat(tr.c(1,:),n,1); % expand tr.c for all points
switch operations
    case 4
        % All operations
        Z = tr.b * YComplete * tr.T + tr.c;
    case 3
        %NO TRANSLATION
        tr.c = ones(size(tr.c));
        Z = tr.b * YComplete * tr.T;
    case 2
        %NO SCALING
        tr.b = 1;
        tr.c = mean(X) - mean(Y) * tr.T;
        tr.c = repmat(tr.c(1,:),n,1); % expand tr.c for all points
        Z = YComplete * tr.T + tr.c;
    case 1
        %NO ROTATION/REFLECTION
        tr.T = eye(size(tr.T));
        Z = tr.b * YComplete * tr.T + tr.c;
end
end 

function [h] =plotAnchorTransform(folder,label,X,Y,Z)
    filename=sprintf('transforms/anchorTransformMap-%s',label);
    h=figure('Name','Anchor Transform Map','visible','off');
    hold all;
    px=plot(X(:,1),X(:,2),'-db','MarkerSize',3);
    py=plot(Y(:,1),Y(:,2),'-dg','MarkerSize',3);
    pz=plot(Z(:,1),Z(:,2),'-dr','MarkerSize',3);
    legend([px py pz],{'Real Points','Local','Global (transformed)'},'Location','bestOUTSIDE');
    grid on;
    saveFigure(folder, filename);
    hold off;
end

