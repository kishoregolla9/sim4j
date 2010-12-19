% For multisimcca
numNetworks=10 %#ok<NOPTS>
% folderpath='../results/multi-20101018_213558_Square-Random-12x12-100Sets-10Nets'

% For simcca
numAnchorSets=1000 %#ok<NOPTS>
numAnchorsPerSet=3 %#ok<NOPTS>
doAllStarts=false;
shape=NET.SHAPE_RECTANGLE;
placement=NET.NODE_RANDOM;
networkEdge=20 %#ok<NOPTS>
networkHeight=3;
networkWidth=25;
numNodes=200; 

% allows for console loop to set networkScale
if exist('networkScale','var') == 0 || networkScale == 0
    networkScale=1.0; % do not scale by default
end 

minRadius=2.0*networkScale;
radiusStep=1.0*networkScale;
numRadii=1;

