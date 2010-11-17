function plotDirections( results,anchors,radii,folder )
% Plot rotation and reflection vs error

result=results(1);
figName='Directions vs Error';

if (exist('threshold','var')==0)
    threshold=100;
end

realPoints=result.network.points;
numAnchorSets=size(anchors,1);
dirs=zeros(1,numAnchorSets,1);
angle=zeros(1,numAnchorSets,1); 
for s=1:numAnchorSets
    anchorNodes=anchors(s,:);
    mappedPoints=result.patchedMap(s).mappedPoints;
    v=zeros(size(anchors,2),2);
    for i=1:size(anchors,2)
        % Calculate unit vectors of each anchor difference
        x=mappedPoints(anchorNodes(i),1)-realPoints(anchorNodes(i),1);
        y=mappedPoints(anchorNodes(i),2)-realPoints(anchorNodes(i),2);
        d=sqrt(x^2+y^2);
        v(i,1)=x/d;
        v(i,2)=y/d;
        angle(i,s)=atand(y/x);
    end
    
    for i=1:size(anchors,2)
        dirs(1,s)=(angle(1,s)+angle(2,s)+angle(3,s))/3;
%         if (dirs(1,s) < 0) 
%             dirs(1,s)=-1;
%         else
%             dirs(1,s)=+1;
%         end
    end
end

plotSingleDataSet(figName,'Angle',results,anchors,radii,...
    dirs,folder,threshold,false,0,{'o'});
% h=plotSingleDataSet(figName,'Dissimilarity measure',results,anchors,radii,...
%     dirs(2,:),folder,threshold,false,h,{'.'});
% plotSingleDataSet(figName,'Dissimilarity measure',results,anchors,radii,...
%     dirs(3,:),folder,threshold,false,h,{'v'});
end
