function [ minHopCount, meanHopCount ] = getHopCounts( anchors, points, shortestHopMatrix )
%GETHOPCOUNTS Summary of this function goes here
%   Detailed explanation goes here

meanHopCount=zeros(size(points,1),1);
minHopCount=zeros(size(points,1),1);

for p=1:size(points,1)
    numAnchors=size(anchors,2);
    hopsToAnchor=zeros(numAnchors,1);
    for a=1:numAnchors
        hopsToAnchor(a)=shortestHopMatrix(anchors(a),p);
    end
    meanHopCount(p)=mean(hopsToAnchor);
    minHopCount(p)=min(hopsToAnchor);
end


end

