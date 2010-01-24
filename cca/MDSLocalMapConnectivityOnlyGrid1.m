function [node]=MDSLocalMapConnectivityOnlyGrid1(Network,epochs,r)
%localMapLocalization computes the local 2 hop map for all its nodes
%coordinates for each node in the 'Network'. 
%(use this to replace 'network_neighborMap' and 'ccaLocation_hop')
% Network - input deployed network
% epochs - required number of training cycles
% r -radius
% node_k - integer of the node number
% T - elapsed time for CCA computation
% C_delta - difference of C_tranform from real coordinates. C_tranform is the 
% the resulting node coordinates in 2D
% D_dist_mean - the sum of the mean error between the orginal distance matrix of the input
% 'Network' and the distance matrix computed from the resulted node
% coordinates
% D_coordinates_mean - the mean error between the coordinates of the input
% 'Network' and the resulted node coordinates
% D_coordinates_median - the median error between the coordinates of the
% input
% 'Network' and the resulted node coordinates

%Obtain the merged local distance matrix
%[node_index_merge,local_d_merge,local_distance_deployed,local_network]=localDisMatrix_merge(Network,node_k,r);

THRESHOLD=1.5; %the max distance error average to be tolerated or we'd fail
N=size(Network,1);
D=sqrt(disteusq(Network,Network,'x'));
cl_count=0;
for i=1:N %compute all the local maps
%get node_i's neighbor nodes within r;
[node(i).neighbors]=find_neighbors(D,r,i,1);
cl_count=cl_count+size(node(i).neighbors,2)-1; %trying to get network connectivity level
end
%D=sqrt(disteusq(Network,Network,'x')); 
%N=size(Network,1);
r
cl_count=cl_count/N; %network connectivity level

% t_level=30; %common used
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if (cl_count>5.9)&(cl_count<8.2) 
%     t_level=11 %for cshape_grid_79 nodes
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% t_level=0;
% t_level=40;
% t_level=70; %used in the loop random network

% for i=1:N
%     for j=1:N
%         if D(i,j)<r
%             D_hopDist(i,j)=D(i,j);
%         else
%             D_hopDist(i,j)=2*N*r;
%         end
%     end
% end %get prepared to compute the shortest distance matrix for D
% 
% for k=1:N
%     D_hopDist = min(D_hopDist,repmat(D_hopDist(:,k),[1 N])+repmat(D_hopDist(k,:),[N 1])); 
% end %compute the shortest distance matrix using Floyed algorithm

% for k=1:63
%     for i = 1:63
%         for j = 1:63
%             D_hopDist2(i,j) = min(D_hopDist2(i,j), D_hopDist2(i,k)+D_hopDist2(k,j));
%         end
%     end
% end %compute the shortest distance matrix using Dijkas. Performance is bad in matlab

for i=1:N
    for j=1:N
        if D(i,j)<r
            D_hopCount_current(i,j)=1;
        else
            D_hopCount_current(i,j)=2*N;
        end
        if(i==j) D_hopCount_current(i,j)=0;
        end
    end
end %get prepared to compute the shortest hop matrix for D under radius r

for k=1:N
    D_hopCount_current = min(D_hopCount_current,repmat(D_hopCount_current(:,k),[1 N])+repmat(D_hopCount_current(k,:),[N 1])); 
end %compute the shortest hop matrix using Floyed algorithm

r1=1.45;  %deployment unit radius disk setup
for i=1:N
    for j=1:N
        if D(i,j)<r1
            D_hopCount(i,j)=1;
        else
            D_hopCount(i,j)=2*N;
        end
        if(i==j) 
            D_hopCount(i,j)=0;
        end
    end
end %get prepared to compute the shortest hop matrix for D

% r2=1.75;  %deployment unit diagonal radius disk setup
% for i=1:N
%     for j=1:N
%         if D(i,j)<r2
%             D_hopCount2(i,j)=1;
%         else
%             D_hopCount2(i,j)=2*N;
%         end
%         if (i==j) 
%             D_hopCount2(i,j)=0;
%         end
%     end
% end %get prepared to compute the shortest distance matrix for D
% 
% for ii=1:N  %establish the local hop count matrix including diagonal disk coverage
%     for jj=1:N
%         if (D_hopCount1(ii,jj)==1)
%             D_hopCount(ii,jj)=1;
%         end
%         if((D_hopCount1(ii,jj)~=1)&(D_hopCount2(ii,jj)==1))
%             D_hopCount(ii,jj)=1.5;
%         end
%         if((D_hopCount1(ii,jj)~=1)&(D_hopCount2(ii,jj)~=1))
%             D_hopCount(ii,jj)=2*N;
%         end
%         if(ii==jj) 
%             D_hopCount(ii,jj)=0;
%         end
%     end
% end

for k=1:N
    D_hopCount = min(D_hopCount,repmat(D_hopCount(:,k),[1 N])+repmat(D_hopCount(k,:),[N 1])); 
end %compute the shortest hop matrix using Floyed algorithm

for node_k=1:N
    node_k
    while(size(node(node_k).neighbors,2)==1)%node_k has no connectivity
        node_k=node_k+1;
    end
    %tic;
    tStart = cputime;
    h=2;
% h=3 %used to test gridLoop. 
    [local_d,node_index]=localDist(D_hopCount,D_hopCount_current,node_k,h); %compute node_k's two hop distance matrix
    local_size=size(node_index,2);
    diff=local_size-size(node(node_k).neighbors,2);

    %node_index_merge=node_index;
    %local_d_merge=local_d;
    %local_size_merge = size(node_index_merge,2);
    %get the merged network real value from the deployed network
    local_network=Network(node_index,:); %use this line to replace the following three lines
%     local_network=Network(node_index(1),:);
%     for i=2:local_size
%         local_network=[local_network;Network(node_index(i),:)];
%     end %loop not needed. simplify it. 
    %compute the real distance from the deployed network node values
    local_distance_deployed=sqrt(disteusq(local_network,local_network,'x'));
    delta_distance=local_d-local_distance_deployed;
    node(node_k).Dmatrix_error_orig_mean = mean((mean(abs(delta_distance)))')/r;

    node(node_k).local_d_merge=local_d;
    node(node_k).local_distance_deployed=local_distance_deployed;
    node(node_k).local_network=local_network;
    node(node_k).neighbors_merge=node_index;
    node(node_k).node_id=node_k;
    node(node_k).radius=r;

%     %calculate the proximity of the matrix using SVD
%     %[u,s,v]=svd(local_d_merge);
%     %local_d_merge=u(:,1)*s(1,1)*v(:,1)'+u(:,2)*s(2,2)*v(:,2)'+u(:,3)*s(3,3)*v(:,3)'+u(:,4)*s(4,4)*v(:,4)';
% 
%     %calculate the local network value using cca
%         local_network_c=cca(local_d,2,epochs_adjust,local_d);%computed local_network of node_k
%         
        [P,e]=mdscale(local_d);
        [n1, n2] = size(P);
        if n2 < 2
            P(:,2) = 0;
        end
        local_network_c = P(:,1:2);
     
        D_C = sqrt(disteusq(local_network_c,local_network_c,'x'));
       % D_dist_mean = mean((mean(abs(D_C-local_distance_deployed)))');
        D_dist_mean = mean((mean(abs(D_C-local_d)))');
        D_dist_mean=D_dist_mean/r; %this is a bad measurement to determine the goodness of the results. 
        %Have problem with this. Should change it. 
           node(node_k).local_network_c=local_network_c;
           %node(node_k).local_map_compuTime=T;
           node(node_k).D_error_mean_compute=D_dist_mean;
  
     
        
%   
        T=cputime-tStart;
        node(node_k).local_map_compuTime=T;
        T=0;
   
    %debug
%     if((D_dist_mean>=0.02)&(epochs_adjust<250))
%         fprintf(2,'early quit of cca sycles\n');
%     end

    %check the accuracy of our results
    N_local=size(local_network,1);
    N1=1;
    N2=int16(N_local/3);
    N3=int16(N_local*2/3+1);
    Y(1,:)=node(node_k).local_network_c(N1,:);
    Y(2,:)=node(node_k).local_network_c(N2,:);
    Y(3,:)=node(node_k).local_network_c(N3,:);
    X(1,:)=local_network(N1,:);
    X(2,:)=local_network(N2,:);
    X(3,:)=local_network(N3,:);
    [d, Z, transform] = procrustes(X, Y);
    Cx=transform.c;
    for i=1:(N_local-size(transform.c,1))
          Cx=[Cx;transform.c(1,:)];
    end
    C_transform=transform.b*node(node_k).local_network_c * transform.T+Cx;

    % [Z,Cx]= mapTrans(X1,X2,X3,Y1,Y2,Y3,N);
    % C_transform=(Z*local_network_c'+Cx)';
    node(node_k).local_network_transform=C_transform;
    D_C = sqrt(disteusq(C_transform,C_transform,'x'));
    D_dist_mean = mean((mean(abs(D_C-local_distance_deployed)))');
    D_dist_mean=D_dist_mean/r;
    node(node_k).D_dist_mean_true=D_dist_mean;
    D_coordinates_mean=mean(abs(C_transform-local_network));
    D_coordinates_mean=D_coordinates_mean/r;
    D_coordinates_median=median(abs(C_transform-local_network));
    D_coordinates_median=D_coordinates_median/r;
    C_delta=C_transform - local_network;
    node(node_k).local_coordinates_error_mean=D_coordinates_mean;
    node(node_k).local_coordinates_error_median=D_coordinates_median;
end %for node_k

%%%%%%%%%%%%%%%%subfunctions%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ldist,node_index]=localDist(D_hopCount,D_hopCount_current,node_i,hop)
%localDist(D,r) takes a distance matrix D and range r to generate for  
%node 'i' 0<i<size(D) a local distance matrix ldist that includes the
%nodes j such that D(i,j)<=hop*r. All the unknown entries in ldist would be
%marked as 'NaN'. "node_index" is an array that holds the node index
%'j' of the node j in D that are selected and included in the ldist, in 
% the ascending order. Nodes in ldist also have their index in the 
% ascending order of the original index in D. 

% N=size(D,1);
% for i=1:N
%     for j=1:N
%         if D(i,j)<r
%             D_hopDist(i,j)=D(i,j);
%         else
%             D_hopDist(i,j)=2*N*r;
%         end
%     end
% end %get prepared to compute the shortest distance matrix for D
% 
% for k=1:N
%     D_hopDist = min(D_hopDist,repmat(D_hopDist(:,k),[1 N])+repmat(D_hopDist(k,:),[N 1])); 
% end %compute the shortest distance matrix using Floyed algorithm
% 
% % for k=1:63
% %     for i = 1:63
% %         for j = 1:63
% %             D_hopDist2(i,j) = min(D_hopDist2(i,j), D_hopDist2(i,k)+D_hopDist2(k,j));
% %         end
% %     end
% % end %compute the shortest distance matrix using Dijkas. Performance is bad in matlab
% 
% for i=1:N
%     for j=1:N
%         if D(i,j)<r
%             D_hopCount(i,j)=1;
%         else
%             D_hopCount(i,j)=2*N;
%         end
%         if(i==j) D_hopCount(i,j)=0;
%         end
%     end
% end %get prepared to compute the shortest hop matrix for D
% 
% for k=1:N
%     D_hopCount = min(D_hopCount,repmat(D_hopCount(:,k),[1 N])+repmat(D_hopCount(k,:),[N 1])); 
% end %compute the shortest hop matrix using Floyed algorithm
% 
% tic;
N=size(D_hopCount,1);
node_count=0;
for j=1:N
    if D_hopCount_current(node_i,j)<=hop %look for all the nodes that is within hop 
        node_count=node_count+1; %count the number of selected nodes
        node_index(node_count)=j; %save the original index of the selected node
    end 
end %get all the nodes within the hop range.  
%node_index=sort(node_index);
ldist=zeros(node_count,node_count);
for i=1:node_count
    for j=i+1:node_count
        ldist(i,j)=D_hopCount(node_index(i),node_index(j));
        ldist(j,i)=ldist(i,j);
    end
end %build the distance matrix for the neighborhood within 
%tmp = 0.05*(randn(size(ldist))); %added 5% error of normal distribution
%ldist=ldist.*(1+tmp);


function [node_index]=find_neighbors(D,r,i,k)
%localDist(D,r) takes a distance matrix D and range r to generate for  
%node 'i' 0<i<size(D) a list that includes the nodes j such that D(i,j)<=kr. 
 
node_count=0;
for j=1:size(D)
    if D(i,j)<=k*r %look for all the nodes that is within distance k*r 
        node_count=node_count+1; %count the number of selected nodes
        node_index(node_count)=j; %save the original index of the selected node
    end
    %The saved node_index is in ascending order
end

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
  