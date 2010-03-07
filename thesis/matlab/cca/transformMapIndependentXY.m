function [Z,tr,dissimilarity] = transformMap(realPoints, patchedPoints, anchorNodes, ...
    operations,doReflection, folder,label)
% Transform the map using the procrustes algorithm
% realPoints: the input points (only anchor nodes are used)
% patchedPoints: the local map points, so far
% anchor Nodes:
% operations: 4 - all
%             3 - no translation
%             2 - no scaling
%             1 - no rotation/reflection
% dissimilarity measure see
% http://www.mathworks.com/access/helpdesk/help/toolbox/stats/br3txrn-1.html

if nargin < 4
    operations=4;
end

n=size(realPoints,1);
%      c:  the translation component (a n x 2 matrix, where each row is
%      identical)
%      T:  the orthogonal rotation and reflection component (2x2 matrix)
%      b:  the scale component (a scalar)
%   That is, Z = tr.b * Y * tr.T + tr.c.

YComplete=patchedPoints(:,1:2);
dissimilarity=zeros(2,1);
tr(2)=struct('T',0,'b',0.0,'c',zeros(3,1));
for dimension=1:2
    X=realPoints(anchorNodes,dimension);
    Y=patchedPoints(anchorNodes,dimension);

    d=zeros(3,1);
    transform(3)=struct('T',0,'b',0.0,'c',zeros(3,1));
    [d(1), ~, transform(1)] = procrustes(X, Y,'reflection','best','scaling',true);
    [d(2), ~, transform(2)] = procrustes(X, Y,'reflection',true,'scaling',true);
    [d(3), ~, transform(3)] = procrustes(X, Y,'reflection',false,'scaling',true);
    [d(4), ~, transform(4)] = procrustes(X, Y,'reflection','best','scaling',false);
    [d(5), ~, transform(5)] = procrustes(X, Y,'reflection',true,'scaling',false);
    [d(6), ~, transform(6)] = procrustes(X, Y,'reflection',false,'scaling',false);

    [~,i]=min(d);
    dissimilarity(dimension) = d(i);
    tr(dimension) = transform(i);
   
    clear d transform;

end

% plotAnchorTransform(folder,label,X,Y,Z);

tr(1).c=repmat(tr(1).c(1,:),n,1); % expand tr.c for all points
tr(2).c=repmat(tr(2).c(1,:),n,1); % expand tr.c for all points
switch operations
    case 4
        % All operations
        Z(:,1) = tr(1).b * YComplete(:,1) * tr(1).T + tr(1).c;
        Z(:,2) = tr(2).b * YComplete(:,2) * tr(2).T + tr(2).c;
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
    if figureExists(folder,filename) == 0
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
end

