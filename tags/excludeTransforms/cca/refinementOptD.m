% RCS: $Id: refinementOptD.m,v 1.1 2002/12/20 23:41:38 yshang Exp yshang $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Refinement of the relative map based on distributed local optimization
%%
%% Input: relativeMap - the coordinates of points
%%        distMatrix - distance matrix of all points
%%        ConnectivityM - the connectivity matrix
%% Output: newP - the coordinates of points after optimization
%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [newP] = refinementOptD(relativeMap, distMatrix, ConnectivityM)

method = 2; % 1 - R; 2 - 2xR.
nIter = 5;

h = gcf;
tic;

[tmp,N] = size(distMatrix);

% STEP 1: FIND NEIGHBORS (within R or 2R), excluding itself
 
for i=1:N
    neighbors= find(ConnectivityM(:,i)>0); 
    neighbors1R{i} = neighbors;
    localD{i} = distMatrix(i,neighbors);

    if method == 2
        neighbors2R{i} = find(sum(ConnectivityM(:,neighbors),2) > 0);
        neighbors2R{i} = setdiff(neighbors2R{i}, i);
        localD2R{i} = distMatrix(i,neighbors2R{i});    
    end
end

% Step 2: Iterate through nodes to refine their positions
% 
% figure; ploti = ceil(nIter/2)+1;
% subplot(ploti,2,1); hold on; axis square;
% gplot(ConnectivityM,relativeMap);   
for iter=1:nIter
    oldP = relativeMap;
    for ii = 1:N
        if method == 1
            neighbors = neighbors1R{ii};
            D = localD{ii};
        elseif method == 2
            neighbors = neighbors2R{ii};
            D = localD2R{ii};
        end
        
        options = optimset('Display','off','LargeScale', 'off', 'MaxIter', 20, ...
            'TolFun', 1e-4,'Jacobian', 'off');
        % options = optimset('Display','iter','LargeScale', 'off');
        X0 = relativeMap(ii,:)'; X0 = X0';
        [X,resnorm] = lsqnonlin(@myObjFunD,X0, [],[],options, ...
            relativeMap(neighbors,:),D);
        % newP(ii,:) = X;
        X = reshape(X,2,[]);
        relativeMap(ii,:) = X';
        
%         Nneighbor = length(neighbors); 
%         
%         figure(10); clf;
%         gplot(ones(Nneighbor,Nneighbor), relativeMap(neighbors,:), 'y-');
%         hold on; plot(relativeMap(ii,1), relativeMap(ii,2), 'ro');
%         hold on; plot(X(1), X(2), 'g*');
%         
    end
    disp([' Difference: ' num2str(mean(sum((relativeMap-oldP).^2,2)))]);
%    relativeMap = newP;
%     
%     subplot(ploti,2,iter+1);   
%     gplot(ConnectivityM,relativeMap);  axis square;  
end

figure(h);
disp(['Distributed local optimization takes ' num2str(toc) ' sec']);

newP = relativeMap;
return;



