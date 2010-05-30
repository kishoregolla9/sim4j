function [ folders ] = runCCA( folders, folderpath,...
    anchorSetIndex, anchorPoints,numNetworks)
%runCCA Perform CCA on the input network
%
f=folders;
parfor networkIndex=2:numNetworks
    [folder] = doCcaForNetwork(folderpath,...
        anchorSetIndex,anchorPoints,...
        numNetworks,networkIndex);
    f{anchorSetIndex,networkIndex}=folder;
end
folders=f;
end

function [folder] = doCcaForNetwork(folderpath,...
    anchorSetIndex,theAnchorPoints,...
    numNetworks,networkIndex) 

% dst=sprintf('%s/anchorPoints.mat',folderpath);
% save(dst,'anchorPoints','folders',...
%   'networkIndex','anchorSetIndex','numNetworks','numAnchorSets',...
%   'folderpath','multiStart','originalAnchors','points');
% save('folderpath.mat','folderpath');
% clear
% load('folderpath.mat');
% dst=sprintf('%s/anchorPoints.mat',folderpath);
% load(dst);
% networkIndex=networkIndex; %#ok
% anchorSetIndex=anchorSetIndex; %#ok

f=sprintf('%s/AnchorSet%i/Network%i',folderpath,...
    anchorSetIndex,networkIndex);
fprintf(1,'%i Folder %s\n',networkIndex,f);

if ~exist(f,'dir')
    fprintf(1,'**** Running simcca for network #%i of %i\n',...
        networkIndex,numNetworks)
%     load('folderpath.mat');
%     dst=sprintf('%s/anchorPoints.mat',folderpath);
%     load(dst);
    anchorPoints=theAnchorPoints; %#ok<NASGU> used in simcca
    folder=f;
    ccaconfigfile=sprintf('%s/ccaconfig.m',folderpath); %#ok<NASGU> used in simcca
    simcca
else
    fprintf(1,'**** Run simcca for network #%i already done\n',...
        networkIndex)
    folder=f;
end

end




