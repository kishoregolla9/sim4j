function [nodes]=localMapConnectivityOnly(network,epochs,radius)
% localMapLocalization computes the local 2 hop map for all its nodes
% coordinates for each node in the 'network'using range free method.
%
% network - input deployed network
% epochs - required number of training cycles
% radius - radio range

% Obtain the merged local distance matrix
% [node_index_merge,local_d_merge,local_distance_deployed,local_network]=localDisMatrix_merge(network,node_k,radius);

THRESHOLD=1.5; %the max distance error average to be tolerated or we'd fail
N=size(network.points,1);
shortestHopMatrix=network.shortestHopMatrix;
nodes=network.nodes;

% nodes(i).neighbors has been calculated in neighborMap.m

% t_level=30; %common used
t_level=1000;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if (networkConnectivityLevel>5.9)&(networkConnectivityLevel<8.2)
%     t_level=11 % for cshape_grid_79 nodes
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% t_level=0;
% t_level=40;
% t_level=70; %used in the loop random network

for node_k = 1:N
    if (size(nodes(node_k).neighbors,2) == 1) %node_k has no connectivity
        continue;
    end
    
    tStart=tic;
    h=2;  % number of hops in local map
    nodes(node_k).t_level=t_level;
    if (size(nodes(node_k).neighbors,2)>t_level) % if more than 1000 neighbors!
        h=1;
    end
    
    %compute node_k's h-hop (2-hop) distance matrix
    [localShortestHopMatrix,node_index]=createLocalShortestHopMatrix(shortestHopMatrix,node_k,h);
    local_size=size(node_index,2);
    
    % get the merged network real value from the deployed network
    local_network=network.points(node_index,:);
    
    %compute the real distance from the deployed network nodes values
    local_distance_deployed=sqrt(disteusq(local_network,local_network,'x'));
    delta_distance=localShortestHopMatrix-local_distance_deployed;
    nodes(node_k).Dmatrix_error_orig_mean = mean((mean(abs(delta_distance)))')/radius;
    
    nodes(node_k).local_d_merge=localShortestHopMatrix;
    nodes(node_k).local_distance_deployed=local_distance_deployed;
    nodes(node_k).local_network=local_network;
    nodes(node_k).neighbors_merge=node_index;
    nodes(node_k).node_id=node_k;
    nodes(node_k).radius=radius;
    nodes(node_k).node_index=node_index;
    
    %calculate the proximity of the matrix using SVD
    %[u,s,v]=svd(local_d_merge);
    %local_d_merge=u(:,1)*s(1,1)*v(:,1)'+u(:,2)*s(2,2)*v(:,2)'+u(:,3)*s(3,3)*v(:,3)'+u(:,4)*s(4,4)*v(:,4)';
    
    %calculate the local network value using cca
    pass=0;
    %nodes(node_k).D_error_mean_orig=THRESHOLD; %set the threshold
    nodes(node_k).D_error_mean_compute=THRESHOLD; %set the threshold
    epochs_adjust=epochs;
    %use simply epochs_max=250 for all local_size and step=50 can perform
    %better. However, it takes more time to compute. So to save time, we
    %often used different epochs_max for different local_size.
    %     epochs_max=100;
    % %    epochs_max=250;
    %     if (local_size<10)
    % %             epochs_max=250;
    %         retry = 3;
    %     end
    %     if (local_size>=10)&(local_size<15)
    % %             epochs_max=200;
    %             retry=2;
    %     end
    %     if (local_size>=15)&(local_size<20)
    % %             epochs_max=150;
    %             retry=1;
    %     end
    %     if (local_size>=20)&(diff>11)
    % %             epochs_max=150;
    %             retry=1;
    %     else if (local_size>=20)
    % %             epochs_max=100;
    %             retry=0;
    %         end
    %     end     %block commented out if to use epoch_max=250;
    %     if (local_size>60)
    %         epochs_max=70;
    %         epochs_adjust=40;
    %         step=10;
    %     else step=50;
    
    %     end %these were used to improve time. they're O.K.
    step=50;
    
    cycle_count=100;
    nodes(node_k).cycles=cycle_count; %record the algorithm cycles
    nodes(node_k).totalRounds=0;
    if (local_size>=20)
        prime_cycle=5;
    else prime_cycle=5; %may use a bigger prome_cycle here. Didn't seem to make a difference
    end
    
    for j=1:prime_cycle  % running cycles of 100 for several times to pick up the best one
        local_network_c=cca(localShortestHopMatrix,2,epochs_adjust,localShortestHopMatrix);%computed local_network of node_k
        nodes(node_k).totalRounds=nodes(node_k).totalRounds+1;
        D_C = sqrt(disteusq(local_network_c,local_network_c,'x'));
        % D_dist_mean = mean((mean(abs(D_C-local_distance_deployed)))');
        D_dist_mean = mean((mean(abs(D_C-localShortestHopMatrix)))');
        D_dist_mean=D_dist_mean/radius; %this is a bad measurement to determine the goodness of the results.
        %Have problem with this. Should change it.
        if ( D_dist_mean<nodes(node_k).D_error_mean_compute )
            nodes(node_k).usefulRounds=j;
            nodes(node_k).local_network_c=local_network_c;
            % nodes(node_k).local_map_compuTime=T;
            nodes(node_k).D_error_mean_compute=D_dist_mean;
        end
        if ((D_dist_mean<0.03)&&(local_size>8)) %for connectivity only case, this may be good enough
            %this threshold of 0.02 or 0.04 should be adjusted. We used 0.04 for
            %other cases. 0.02 is good for network where the hop count
            %approximation is not too much inaccurate.
            pass=1;
            T=toc(tStart);
            break;
        end %if
    end% for j
    nodes(node_k).local_map_compuTime=toc(tStart);
    %     nodes(node_k).totalCycles=500;
    epochs_adjust=step; %reset it for possible incremental further trainning cycles
    if (pass==0) && (D_dist_mean>0.03) %&(retry>0) %further incremental training cycles
        %         nodes(node_k).totalRounds=retry*3;
        if ( local_size > 19 )
            mini_cycle=3;
        else mini_cycle=3; %tried 5 and other numbers here. Cut it short to 3 to save time.
            % May not make big difference between "5" and "3" here.
        end
        
        for jj=1:mini_cycle %run 50 more cycles each time to see if we get any better
            
            %
            %             cycle_count=cycle_count+epochs_adjust; %update cycle count
            %             for ii=1:mini_cycle
            net=cca(localShortestHopMatrix,nodes(node_k).local_network_c,epochs_adjust,localShortestHopMatrix);
            nodes(node_k).totalRounds=nodes(node_k).totalRounds+1;
            local_network_c=net;
            D_C = sqrt(disteusq(local_network_c,local_network_c,'x'));
            %                  D_dist_mean = mean((mean(abs(D_C-local_distance_deployed)))');
            D_dist_mean = mean((mean(abs(D_C-localShortestHopMatrix)))');
            D_dist_mean=D_dist_mean/radius;
            %             epochs_adjust=epochs_adjust+step;
            nodes(node_k).cycles=nodes(node_k).cycles+step;
            step=0;
            if((D_dist_mean<nodes(node_k).D_error_mean_compute))
                nodes(node_k).usefulRounds=5+jj;
                nodes(node_k).local_network_c=local_network_c;
                %nodes(node_k).local_map_compuTime=T;
                nodes(node_k).D_error_mean_compute=D_dist_mean;
                step=50;
            end
            if (D_dist_mean<0.03)&&(local_size>8)
                pass=1;
                T=toc(tStart);
                break; %break out of 'jj'
            end
            %             end % for ii
            %                    if (pass==1)
            %                     break; %break out of 'jj'
            %                    end
        end %for jj
    end %if (pass==0)
    
    if ((pass==0)&&(nodes(node_k).D_error_mean_compute<THRESHOLD))
        T=toc(tStart);
        nodes(node_k).local_map_compuTime=T;
        T=0;
    end %we run all the epochs values.
    
    if (pass==1)%D_dist_mean<0.02
        %         nodes(node_k).epochs=epochs_adjust;
        %         nodes(node_k).local_network_c=local_network_c;
        nodes(node_k).local_map_compuTime=T;
        T=0;
    end
    
    if ((pass==0)&&(nodes(node_k).D_error_mean_compute==THRESHOLD))
        fprintf(2,'nodes %d failed to compute the cca\n', node_k);
    end %we can't get it for this nodes
    
    %debug
    %     if((D_dist_mean>=0.02)&(epochs_adjust<250))
    %         fprintf(2,'early quit of cca sycles\n');
    %     end
    
    %check the accuracy of our results
    N_local=size(local_network,1);
    N1=1;
    N2=int16(N_local/3);
    N3=int16(N_local*2/3+1);
    Y(1,:)=nodes(node_k).local_network_c(N1,:);
    Y(2,:)=nodes(node_k).local_network_c(N2,:);
    Y(3,:)=nodes(node_k).local_network_c(N3,:);
    X(1,:)=local_network(N1,:);
    X(2,:)=local_network(N2,:);
    X(3,:)=local_network(N3,:);
    [d, Z, transform] = procrustes(X, Y);
    Cx=transform.c;
    for i=1:(N_local-size(transform.c,1))
        Cx=[Cx;transform.c(1,:)];
    end
    C_transform=transform.b*nodes(node_k).local_network_c * transform.T+Cx;
    
    % [Z,Cx]= mapTrans(X1,X2,X3,Y1,Y2,Y3,N);
    % C_transform=(Z*local_network_c'+Cx)';
    nodes(node_k).local_network_transform=C_transform;
    D_C = sqrt(disteusq(C_transform,C_transform,'x'));
    D_dist_mean = mean((mean(abs(D_C-local_distance_deployed)))');
    D_dist_mean=D_dist_mean/radius;
    nodes(node_k).D_dist_mean_true=D_dist_mean;
    D_coordinates_mean=mean(abs(C_transform-local_network));
    D_coordinates_mean=D_coordinates_mean/radius;
    D_coordinates_median=median(abs(C_transform-local_network));
    D_coordinates_median=D_coordinates_median/radius;
    %C_delta=C_transform - local_network;
    nodes(node_k).local_coordinates_error_mean=D_coordinates_mean;
    nodes(node_k).local_coordinates_error_median=D_coordinates_median;
    
    fprintf(1,'Calculated local map for node #%.0f of %.0f for radius %.2f in %.2f sec\n',node_k,N,radius,toc(tStart));
end %for node_k

%%%%%%%%%%%%%%%%subfunctions%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ldist,node_index]=createLocalShortestHopMatrix(shortestHopMatrix,node_i,hop)
%createLocalShortestHopMatrix(distanceMatrix,radius)
% Input:
%   distanceMatrix and
%   range radius
% to generate for
%  nodes 'i' 0<i<size(distanceMatrix) a local distance matrix ldist that includes the
%  nodes j such that distanceMatrix(i,j)<=hop*radius. All the unknown entries in ldist would be
%  marked as 'NaN'. "node_index" is an array that holds the nodes index
%  'j' of the nodes j in distanceMatrix that are selected and included in the ldist, in
%  the ascending order. Nodes in ldist also have their index in the
%  ascending order of the original index in distanceMatrix.

numberOfNodes=size(shortestHopMatrix,1);
node_count=0;

%get all the nodes within the hop range.
numNodesInHopCount=sum(shortestHopMatrix(node_i,:)<=hop);
node_index=zeros(numNodesInHopCount,1);
% build the node_index
for j=1:numberOfNodes
    if shortestHopMatrix(node_i,j)<=hop % look for all the nodes that is within hop
        node_count=node_count+1; %count the number of selected nodes
        node_index(node_count)=j; %save the original index of the selected nodes
    end
end
% node_count should equal numNodesInHopCount

ldist=zeros(node_count,node_count);
for i=1:node_count
    for j=i+1:node_count
        ldist(i,j)=shortestHopMatrix(node_index(i),node_index(j));
        ldist(j,i)=ldist(i,j);
    end
end  % build the distance matrix for the neighborhood within
%tmp = 0.05*(randn(size(ldist))); %added 5% error of normal distribution
%ldist=ldist.*(1+tmp);
