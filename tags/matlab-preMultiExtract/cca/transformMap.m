function [Z,tr,dissimilarity,reflect] = transformMap(realPoints, patchedPoints, anchorNodes, ...
    operations,folder,label)
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

X=realPoints(anchorNodes,:);
Y=patchedPoints(anchorNodes,:);

d=zeros(3,1);
transform(3)=struct('T',0,'b',0.0,'c',zeros(3,1));
[d(1), a, transform(1)] = procrustes(X, Y,'reflection','best','scaling',true);
[d(2), a, transform(2)] = procrustes(X, Y,'reflection',true,'scaling',true);
[d(3), a, transform(3)] = procrustes(X, Y,'reflection',false,'scaling',true);
[d(4), a, transform(4)] = procrustes(X, Y,'reflection','best','scaling',false);
[d(5), a, transform(5)] = procrustes(X, Y,'reflection',true,'scaling',false);
[d(6), a, transform(6)] = procrustes(X, Y,'reflection',false,'scaling',false);

[a,i]=min(d);
dissimilarity = d(i);
tr = transform(i);
switch i
    case 1
        reflect='best with scaling';
    case 2
        reflect='forced reflection with scaling';
    case 3
        reflect='no reflection with scaling';
    case 4
        reflect='best with no scaling';
    case 5
        reflect='forced reflection with no scaling';
    case 6
        reflect='no reflection with no scaling';
end

clear d transform;

% plotAnchorTransform(folder,label,X,Y,Z);

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

