
simcca
x=[results(1).errors.mean];
errorsWithIndex=[1:length(x);x];
sorted=sortrows(errorsWithIndex',2);
% Take a random midpoint
anchorSet=sorted(length(sorted)/2,1);
anchorPoints=[anchors(anchorSet,:)',...
    network.points(anchors(anchorSet,:),:)];