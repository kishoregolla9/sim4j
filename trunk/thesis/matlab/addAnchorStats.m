function [ result ] = addAnchorStats( result, anchors )

numAnchorSets=size(result.errors,1);
result.anchorStats = struct();

result.anchorStats.realHeight=zeros(numAnchorSets,1);
result.anchorStats.realEdges=zeros(numAnchorSets,3);
result.anchorStats.mappedHeight=zeros(numAnchorSets,1);
result.anchorStats.mappedEdges=zeros(numAnchorSets,3);
for a=1:numAnchorSets
    
    result.anchorStats.anchorError=zeros(size(anchors,2),1);
    result.anchorStats.realTriangle=zeros(3,2);
    result.anchorStats.mappedTriangle=zeros(3,2);
    for i=1:size(anchors,2)
        result.anchorStats.anchorError(i)=...
            max(result.patchedMap(a).differenceVector(anchors(a,i),:));
        result.anchorStats.realTriangle(i,:)=result.network.points(anchors(a,i),:);
        result.anchorStats.mappedTriangle(i,:)=result.patchedMap(a).mappedPoints(anchors(a,i),:);
    end
    
    [result.anchorStats.realAreas(a),result.anchorStats.realEdges(a,:)]=...
        triangleArea(result.anchorStats.realTriangle);
    [result.anchorStats.mappedAreas(a),result.anchorStats.mappedEdges(a,:)]=...
        triangleArea(result.anchorStats.mappedTriangle);
    result.anchorStats.realHeight(a)=...
        (2*result.anchorStats.realAreas(a)) / ...
        max(result.anchorStats.realEdges(a,:));
    result.anchorStats.mappedHeight(a)=...
        (2*result.anchorStats.mappedAreas(a)) / ...
        max(result.anchorStats.mappedEdges(a,:));
    
    
    removeOutliers(x);
end

end
