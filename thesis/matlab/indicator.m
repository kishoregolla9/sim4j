
folders={...    
    '2010-11-16_14_25_47-Square-Random-20x20',...
    '2010-11-16_14_7_17-Square-Random-20x20'
};

errors=zeros(1,1);
heights=zeros(1,1);
for i=1:size(folders)
   f=sprintf('../results/%s',folders{i});
   loadFile(f,'result-*');
   loadFile(f,'anchors*');
   errors=[ errors [result.errors.mean] ];
   stats=triangleStats(result.network.points,anchors);
   heights=[ heights [stats.heights.min] ];
end

dataToPlot=[heights, errors];
dataToPlot=sortrows(dataToPlot,1);
figure
plot(dataToPlot(:,1),dataToPlot(:,2),'.');





