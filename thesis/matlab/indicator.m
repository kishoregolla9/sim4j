
folders={...    
    '2010-11-16_14_25_47-Square-Random-20x20',...
    '2010-11-16_14_7_17-Square-Random-20x20'
};

errors=zeros(0,1);
heights=zeros(0,1);
for i=1:length(folders)
   f=sprintf('../results/%s',folders{i});
   loadFile(f,'result-*');
   loadFile(f,'anchors*');
   errors=[ errors [result.errors.mean] ];
   stats=triangleStats(result.network.points,anchors,result.network.width,result.network.height);
   heights=[ heights [stats.heights.min] ];
   clear result anchors numAnchorSets
end
radius=radii(1);
plotIndicators(errors,heights,radius);






