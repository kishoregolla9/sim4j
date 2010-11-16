function plotRotRef( results,anchors,radii,folder )
% Plot rotation and reflection vs error

numAnchorSets=size(anchors,1);
result=results(1);
figName='RotRef vs Error';

rot=zeros(1,numAnchorSets,1);
ref=zeros(1,numAnchorSets,1);
t1=zeros(1,numAnchorSets,1);
t2=zeros(1,numAnchorSets,1);
b=zeros(1,numAnchorSets,1);
for s=1:numAnchorSets
    transform=result.transform(s);
    % +1==rotation, -1==reflection
    if (det(transform.T) < 0)
        ref(1,s)=(acos(transform.T(1,1))/2)*180/pi;
        rot(1,s)=NaN;
    else
        ref(1,s)=NaN;
        rot(1,s)=(acos(transform.T(1,1)))*180/pi;
    end
    t1(1,s)=transform.c(1,1);
    t2(1,s)=transform.c(1,2);
    b(1,s)=transform.b;
end

if (exist('threshold','var')==0)
    threshold=100;
end

h=plotSingleDataSet(figName,'Rotation',results,anchors,radii,...
    rot,folder,threshold,false,0,{'o'});
plotSingleDataSet(figName,'Reflection',results,anchors,radii,...
    ref,folder,threshold,false,h,{'x'});


legend({'Rotation','Reflection','s'});
xlabel('Angle of Rotation or Reflection (degrees)');
minRadius=radii(1);
maxRadius=radii(size(radii,2));
prefix=strrep(figName,' ','_');
filename=sprintf('%s-%s-Radius%.1f-to-%.1f',...
    prefix,result.network.shape,minRadius,maxRadius);
if (threshold < 100)
    filename=sprintf('%s-Excluding%0.1f',filename,threshold);
end
saveFigure(folder,filename);

end
