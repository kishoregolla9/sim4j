%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ordinal MDS solver for localization
%  
%  written by Yi Shang and modified by Ying Zhang
%  adapted by Vijay Vivekanandan to implement Ordinal MDS
%
% function t = MDSSolver (t)
% 
% additional t contains:
%   PMDS - 0: use CMDS, 1: 1 hop PMDS, 2: 2 hop PMDS
%   refinement - 0: no refinement step, 1: do refinement step
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function t = MDSSolver2 (t)

%* Copyright (C) 2004 PARC Inc.  All Rights Reserved.
%*
%* Use, reproduction, preparation of derivative works, and distribution 
%* of this software is permitted, but only for non-commercial research 
%* or educational purposes. Any copy of this software or of any derivative 
%* work must include both the above copyright notice of PARC Incorporated 
%* and this paragraph. Any distribution of this software or derivative 
%* works must comply with all applicable United States export control laws. 
%* This software is made available AS IS, and PARC INCORPORATED DISCLAIMS 
%* ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE 
%* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
%* PURPOSE, AND NOTWITHSTANDING ANY OTHER PROVISION CONTAINED HEREIN, ANY 
%* LIABILITY FOR DAMAGES RESULTING FROM THE SOFTWARE OR ITS USE IS EXPRESSLY 
%* DISCLAIMED, WHETHER ARISING IN CONTRACT, TORT (INCLUDING NEGLIGENCE) 
%* OR STRICT LIABILITY, EVEN IF PARC INCORPORATED IS ADVISED OF THE 
%* POSSIBILITY OF SUCH DAMAGES. This notice applies to all files in this 
%* release (sources, executables, libraries, demos, and documentation).
%*/


% distMatrix = t.kd;
% distMatrix = (distMatrix+distMatrix')/2; %commented out by li for code
% walkthrough
ConnectivityM = t.connectivityMatrix;
distHopMatrix = double(t.connectivityMatrix);
points = t.xy;
knownJ = t.anchorNodes;

N=size(points); N = N(1);

%%%%% Step 1: Compute shortest paths %%%%%
disp('Computing shortest paths...'); 

%%  We use Floyd's algorithm, which produces the best performance in Matlab. 
%%  Dijkstra's algorithm is significantly more efficient for sparse graphs, 
%%  but requires for-loops that are very slow to run in Matlab.  A significantly 
%%  faster implementation of Isomap that calls a MEX file for Dijkstra's 
%%  algorithm can be found in isomap2.m (and the accompanying files
%%  dijkstra.c and dijkstra.dll). 
% 
% distMatrixOld = distMatrix;
%   
% D = distMatrix;
% for k=1:npoints
%     for i = 1:npoints
%         for j = 1:npoints
%             D(i,j) = min(D(i,j), D(i,k)+D(k,j));
%         end
%     end
% end
% distMatrix = D;
%  
t1 = cputime;
% disp(['Compute shortest path using Dijkstra algo takes ' num2str(t1-t0) ' sec']);
%  
 
% tic;
% D = distMatrix;
% J = D == -1; %no connection index
% D(J) = inf; %set to be maximum
% 
% verbose = 0;
% for k=1:N
%     D = min(D,repmat(D(:,k),[1 N])+repmat(D(k,:),[N 1])); 
%     if ((verbose == 1) & (rem(k,20) == 0)) 
%         disp([' Iteration: ' num2str(k) '     Estimated time to completion: ' num2str((N-k)*toc/k) ' sec']); 
%     end
% end
% distMatrix = D;
% disp(['Compute shortest path using Floyd algo takes ' num2str(toc) ' sec']);
%above block commented out by li
distMatrix=t.distanceMatrix; %added by li
tmp = 0.05*(randn(size(distMatrix))); %Li -added 5% error of normal distribution
for ii=1:N
    for jj=ii+1:N
        tmp_sym(ii,jj)=tmp(ii,jj);
        tmp_sym(jj,ii)=tmp_sym(ii,jj);
    end
    tmp_sym(ii,ii)=0;
end
distMatrix=distMatrix.*(1+tmp_sym);% Li added to make it symmetric

% compute the pairwise hop distance anyway
% clear D; %commented out by li
D = distHopMatrix;
J = D == 0; %no connection index
D(J) = inf; %set to be maximum
verbose = 0;
for k=1:N
    D = min(D,repmat(D(:,k),[1 N])+repmat(D(k,:),[N 1])); 
    if ((verbose == 1) & (rem(k,20) == 0)) 
        disp([' Iteration: ' num2str(k) '     Estimated time to completion: ' num2str((N-k)*toc/k) ' sec']); 
    end
end
distHopMatrix = D;
%
% Run Classical MDS based on approximate distance matrix
%

try usePMDS = t.PMDS; catch usePMDS = 0; end
if (isempty(usePMDS) || (usePMDS==0))
    
	tic;
% 	[rawResult,eigvals] = mdscale(distMatrix,2); % li change this into the
% 	next line
    [rawResult,eigvals] = mdscale(distMatrix); %added by li for code walkthrough

	%[rawResult,eigvals] = ordinalmds(distMatrix);
	disp(['Toolbox Non-metric MDS takes ' num2str(toc) ' sec']);

else
	% FIND neighbors within radius 2xR or R, including itself
	% neighbors1R contains 1-hop neighbors.
	% neighbors contains 2-hop neighbors.

	neighborhood = ConnectivityM + eye(N);
	
	for i=1:N
        neighbor = find(neighborhood(:,i)>0);
        neighbors1R{i} = neighbor;
        neighbors{i} = find(sum(neighborhood(:,neighbor),2) > 0);
	end

	% SOLVE FOR Local maps
	tStart = cputime;
	for ii=1:N
       
        % form the local matrix
        neighbor = neighbors{ii};
        
        Nneighbor = length(neighbor);  
	
        D = zeros(Nneighbor,Nneighbor);
        Dhop = D;
        for j = 1:Nneighbor
            for k = j+1:Nneighbor 
                D(j,k) = distMatrix(neighbor(j),neighbor(k));
                D(k,j) = D(j,k);
                Dhop(j,k) = distHopMatrix(neighbor(j),neighbor(k));
                Dhop(k,j) = Dhop(j,k);
            end
        end
%         [Y,e] = mdscale(D,2); %commented out by li in code walkthrough
        if t.rangeBased==1 %added by li to support range free case
         [Y,e] = mdscale(D);  %added by li to replace the previous line
        else [Y,e]=mdscale(Dhop); %added by li to support range free case
        end
	  %[Y,e] = ordinalmds(D);
        
        [n1, n2] = size(Y);
        if n2 < 2
            Y(:,2) = 0;
        end
        
        %figure; l = length(Y(:,1:2)); gplot(ones(l,l),Y(:,1:2))
        
        % local optimization to refine Y
        %warning off;
%        [Z] = refinementOptC(Y(:,1:2), D, Dhop); %commented out by li.
%        function for local map refinement
        %warning on;
	
%         map{ii} = Z; % Y(:,1:2); %commented out by li to not do the
%         refinement for now
        map{ii} = Y(:,1:2);
        index{ii} = neighbor;
        indexInclude{ii} = ii;
        
        % find the map based on 1R radius
        map1RIndex = find(ismember(neighbor, neighbors1R{ii}) > 0);
        map1R{ii} = map{ii}(map1RIndex,:);
        index1R{ii} = neighbors1R{ii};
        indexInclude1R{ii} = ii;
        
	end
	disp(['Finding local maps takes ' num2str(cputime-tStart) ' sec']);
    
	tStart = cputime;
	%
	% Step 4: go through the nodes in some order to patch their local maps
	% together
	% 1 - use map of radius 1R; 2 - use map of radius of 2R.
	
% 	curNode = ceil(rand*N); % Li changed it to the following line to select
% 	the start node
    curNode=t.startNode;
	if usePMDS == 1
        curMap = map1R{curNode};
        curindex = index1R{curNode};
        curindexInclude = indexInclude1R{curNode};
	elseif usePMDS == 2
        curMap = map{curNode};
        curindex = index{curNode};
        curindexInclude = indexInclude{curNode};
	end 

	while length(curindexInclude) ~= N
        nodeList = setdiff(curindex, curindexInclude);
        
        nxlist = zeros(length(nodeList),1);
        for i=1:length(nodeList)
            node2 = nodeList(i);
            if usePMDS == 1
                nxlist(i) = length(intersect(curindex,index1R{node2}));
            else
                nxlist(i) = length(intersect(curindex,index{node2}));
            end
        end
        [tmp, j] = max(nxlist);
        
        node2 = nodeList(j); % find the node with maximum intersection with 
        % the current (expending) map.
        
        if usePMDS == 1
            [curMap, curindex, curindexInclude] = mergeMap(...
                curMap, map1R{node2}, curindex, index1R{node2}, ...
                curindexInclude, indexInclude1R{node2},ConnectivityM);
        else
            [curMap, curindex, curindexInclude] = mergeMap(...
                curMap, map{node2}, curindex, index{node2}, ...
                curindexInclude, indexInclude{node2},ConnectivityM);
        end
        % disp(['node: '  num2str(node2), '  intersection: ' num2str(tmp) ]);
	
	end
	tEnd = cputime;
    t.patchtime=tEnd-tStart;
	disp(['Patching the local maps takes ' num2str(tEnd-tStart) ' sec']);
	%%
	rawResult = curMap;
end
%%
%% Refinement Step. Three methods 1, 2, or 3.
%% 1 - use local MDS maps
%% 2 - minimize the errors of all points (centralized)
%% 3 - iteratively minimize the error of each point (distributed)
%%
try DoRefinement = t.refinement;  catch DoRefinement = 0; end

% Using raw result as starting point
X0 = rawResult(:,1:2);
refineResult = X0;
tStart = cputime;
if DoRefinement == 1
    [refineResult] = refinement(X0, distMatrix, ConnectivityM);
elseif DoRefinement == 2
    [refineResult] = refinementOptC(X0, distMatrix, distHopMatrix);
elseif DoRefinement == 3
    [refineResult] = refinementOptD(X0, distMatrix, ConnectivityM);
end
disp(['Refinement takes ' num2str(cputime-tStart) ' sec']);

[D, Z, TRANSFORM] = procrustes(points(knownJ,:), refineResult(knownJ,1:2));
mappedResult = TRANSFORM.b * refineResult(:,1:2) * TRANSFORM.T + ...
    repmat(TRANSFORM.c(1,:),N,1);

% set output
t.xyEstimate = mappedResult;

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
    index1, index2, indexInclude1, indexInclude2, ConnectivityM, method)

if nargin < 8
    method = 2;
end

unionIndex = union(index1, index2);
[intersectIndex, ii1, ii2] = intersect(index1, index2);

[D, Z, TRANSFORM] = procrustes(map1(ii1,:), map2(ii2,:));

if method == 1
    % -- Method 1: scale and average
    newMap2 = TRANSFORM.b * map2 * TRANSFORM.T + ...
        repmat(TRANSFORM.c(1,:),length(index2),1);
    newMap = map1; 
    newMap(ii1,:) = 0.5 *(map1(ii1,:) + Z);
elseif method == 2
    % -- Method 2: average (do not scale)
    newMap2 = map2 * TRANSFORM.T + ...
        repmat(TRANSFORM.c(1,:),length(index2),1);
    newMap = map1; 
    newMap(ii1,:) = 0.5 *(map1(ii1,:) + newMap2(ii2,:));
end

newMap = [newMap; newMap2(setdiff(1:length(index2),ii2),:)];
newIndex = [index1; setdiff(index2,intersectIndex)];

[newIndex j] = sort(newIndex);
newMap = newMap(j,:);
newIndexInclude = union(indexInclude1, indexInclude2);

function [Y,e] = mdscale(distMatrix)

[N tmp] = size(distMatrix);
D = distMatrix.^2;
opt.disp = 0; 
[V, E] = eigs(-.5*(D - sum(D)'*ones(1,N)/N - ones(N,1)*sum(D)/N + sum(sum(D))/(N^2)), 3, 'LR', opt); 

[e i] = sort(real(diag(E))); e = flipud(e); i = flipud(i); % sort descending
keep = find(e > eps^(3/4)*max(abs(e))); % keep only positive e-vals (beyond roundoff)
if isempty(keep)
    Y = zeros(n,1);
else
    Y = V(:,i(keep)) * diag(sqrt(e(keep)));
end
  


