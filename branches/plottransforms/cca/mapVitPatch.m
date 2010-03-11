function [localMaps,rawResult]=mapVitPatch(network,localMaps,startNode)
%function mapVitPatch takes the input of local maps and patch them together
%into a global map and compare the results with the original 'Network'
%taking the map of startNode as the starting map.
% The input 'localMaps' should be generated from the function of
% localMapLocalization.m or equivalent
%option - Use the greedy patch taking the node that has the most number of
%common nodes for patch when 'option' is given as '1'. When 'option' is
%'0', patch the map as fast as we can by taking the node that has most
%number of different nodes.

N=size(network.points,1);

map=cell(N,1);
index=cell(N,1);
indexInclude=cell(N,1);
for i=1:N
    map{i}=localMaps(i).local_network_c; %added by li as cca directly generates the network
    index{i} = (localMaps(i).neighbors_merge)'; %grab all the nodes in the local map
    indexInclude{i} = i;
end %for i

tStart=tic;

% 	curNode = ceil(rand*N); %randomly select the starting node
curNode=startNode;
curMap = map{curNode};
curindex = index{curNode};
curindexInclude = indexInclude{curNode};

while length(curindexInclude) ~= N
    nodeList = setdiff(curindex, curindexInclude);

    nxlist = zeros(length(nodeList),1);
    for i=1:length(nodeList)
        node2 = nodeList(i);
        nxlist(i) = length(intersect(curindex,index{node2}));
    end
    [tmp, j] = max(nxlist);

    node2 = nodeList(j); % find the node with maximum intersection
    [curMap, curindex, curindexInclude] = mergeMap(...
        curMap, map{node2}, curindex, index{node2},...
        curindexInclude, indexInclude{node2});
end %while

tElapsed=toc(tStart);
localMaps(startNode).map_patchTime=tElapsed;

rawResult = curMap;
localMaps(startNode).patched_network=rawResult;

return;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Merge two local maps of two nodes
%%
%% function [newMap, newIndex, newIndexInclude] = mergeMap(map1, map2, ...
%%    index1, index2, indexInclude1, indexInclude2)
%%
%% Input:
%%      map1 - local map of n1
%%      map2 - local map of n2
%%      index1 - indices of the nodes in n1' map
%%      index2 - indices of the nodes in n2' map
%%      indexInclude1 - indices of the nodes whose maps are contained
%           in n1' map
%%      indexInclude2 - indices of the nodes whose maps are contained
%           in n2' map
%% Output:
%%      newMap - the merged map
%%      newIndex - indices of the nodes in the new map (sorted ascending)
%%      newIndexInclude - indices of the nodes whose maps have been contained
%           in the new map (sorted ascending)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [newMap, newIndex, newIndexInclude] = mergeMap(map1, map2, ...
    index1, index2, indexInclude1, indexInclude2)

[intersectIndex, ii1, ii2] = intersect(index1, index2);

[D, Z, TRANSFORM] = procrustes(map1(ii1,:), map2(ii2,:));

newMap2 = map2 * TRANSFORM.T + ...
    repmat(TRANSFORM.c(1,:),length(index2),1);
newMap = map1;
newMap(ii1,:) = 0.5 *(map1(ii1,:) + newMap2(ii2,:));

newMap = [newMap; newMap2(setdiff(1:length(index2),ii2),:)];
newIndex = [index1; setdiff(index2,intersectIndex)];
% x=setdiff(index2,intersectIndex);
% size(index1)
% size(x)
% newIndex = [index1; x];

[newIndex j] = sort(newIndex);
newMap = newMap(j,:);
newIndexInclude = union(indexInclude1, indexInclude2);

