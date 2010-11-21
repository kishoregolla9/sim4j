% For multisimcca
numNetworks=10 %#ok<NOPTS>
% folderpath='../results/multi-20101018_213558_Square-Random-12x12-100Sets-10Nets'

% For simcca
numAnchorSets=5000 %#ok<NOPTS>
numAnchorsPerSet=3 %#ok<NOPTS>
doAllStarts=false;
shape=NET.SHAPE_RECTANGLE;
placement=NET.NODE_RANDOM;
networkEdge=20 %#ok<NOPTS>
networkHeight=networkEdge;
networkWidth=networkEdge;
numNodes=networkHeight*networkWidth; 
