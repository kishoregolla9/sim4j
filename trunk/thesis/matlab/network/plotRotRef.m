function plotRotRef( results,anchors,radii,folder )
% Plot rotation and reflection vs error

numAnchorSets=size(anchors,1);
result=results(1);
figName='RotRef vs Error';
dataName='Rotation (negative) and Reflection (positive) degrees';

rotref=zeros(1,numAnchorSets,1);
for s=1:numAnchorSets
    transform=result.transform(s);
    rot=(acos(transform.T(1,1)))*180/pi;
    ref=(acos(transform.T(1,1))/2)*180/pi;
    if (det(transform.T) < 0)
        rotref(s)=ref;
    else
        rotref(s)=-rot;
    end
end

if (exist('threshold','var')==0)
    threshold=100;
end

plotSingleDataSet(figName,dataName,results,anchors,radii,...
    rotref,folder,threshold,false);

end
