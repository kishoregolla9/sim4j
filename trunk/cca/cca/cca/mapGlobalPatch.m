function [node]=mapGlobalPatch(Network,node,node_k,anchorNodes,option,r)
%function takes the input of local maps and patch them together
%into a global map and compare the results with the original 'Network' 
%taking the map of node_k as the starting map. The
%input 'node' should be generated from the function of
%localMapLocalization.m or equivalent
%option - Use the greedy patch taking the node that has the most number of
%commone nodes for patch when 'option' is given as '1'. When 'option' is
%'0', patch the map as fast as we can by taking the node that has most
%number of different nodes. 

N=size(Network,1);
D=sqrt(disteusq(Network,Network,'x'));
for i=1:N %mark all the nodes as not patched into the global map yet
    node(i).patch=0;
end

tic;
patchedSet=[];
patchCandi=node(node_k).nh_merge;
P_N=size(patchCandi,2);
M=3; %minimum number of common nodes needed for patch
newNodes=0; %no new nodes for patch
patchNode=node_k; %no node selected for patch
node(node_k).patched_network=node(node_k).local_network_c;%prepare for patch
node(node_k).patched_nh=node(node_k).nh_merge;%all the nodes in the pacthed map
while(P_N~=0)
    %adjust node_k's local network first (note: found this isn't useful)
%     local_network=Network(node(node_k).patched_nh(1),:); %get the deployed network values
%     for i=2:size(node(node_k).patched_nh,2)
%         local_network=[local_network;Network(node(node_k).patched_nh(1),:)];
%     end
%    N=size(local_network,1);
%    %N1=1;
%    %N2=int16(N/3);
%    %N3=int16(N*2/3+1);
%    for i=1:size(node(node_k).patched_nh,2)
%        if (node(node_k).patched_nh(i)==4)
%            N1=i;
%        end
%        if (node(node_k).patched_nh(i)==25)
%            N2=i;
%        end
%        if(node(node_k).patched_nh(i)==48)
%            N3=i;
%        end
%    end %find the three anchor nodes in the patched map
%    
%    X1=node(node_k).patched_network(N1,:)';
%    X2=node(node_k).patched_network(N2,:)';
%    X3=node(node_k).patched_network(N3,:)';
%    N1=4;
%    N2=25;
%    N3=48;
%    Y1=Network(N1,:)';
%    Y2=Network(N2,:)';
%    Y3=Network(N3,:)';
%    [Z,Cx]= mapTrans(X1,X2,X3,Y1,Y2,Y3,N);
%    C_transform=(Z*node(node_k).patched_network'+Cx)';
%    node(node_k).patched_network=C_transform;
%    D_C = sqrt(disteusq(node(node_k).patched_network,node(node_k).patched_network,'x'));
%    D_D=sqrt(disteusq(local_network,local_network,'x'));
%    D_dist_mean = mean((mean(abs(D_C-D_D)))');
%    D_coordinates_mean=mean(abs(C_transform-local_network));
%    D_coordinates_median=median(abs(C_transform-local_network));
%    C_delta=C_transform - local_network;
if(option==1) %greedy algorithm
    for i=1:P_N %select the node that has most number of common nodes for patch
        if ((node(patchCandi(i)).patch~=1)&(patchCandi(i)~=node_k)) 
            %check to see if we'd patch this node's map into the global map
            numberOfNodes =size(intersect(node(node_k).patched_nh,node(patchCandi(i)).nh_merge),2);
            if (numberOfNodes>=M)%if have more common nodes for patch
                patchNode=patchCandi(i); %select i as the patch node
                M=numberOfNodes;
            end
        end
    end
else %thrifty algorithm
    for i=1:P_N %select the node that has most number of different nodes for patch
        if ((node(patchCandi(i)).patch~=1)&(patchCandi(i)~=node_k)) 
            %check to see if we'd patch this node's map into the global map
            numberOfNodes =size(intersect(node(node_k).patched_nh,node(patchCandi(i)).nh_merge),2);
            if (numberOfNodes>=M)%if have enough common nodes for patch
                numberOfNewNodes=size(setdiff(node(patchCandi(i)).nh_merge,node(node_k).patched_nh),2);
                if (numberOfNewNodes>newNodes)
                    patchNode=patchCandi(i); %select i as the patch node
                    newNodes=numberOfNewNodes;
                end
            end
        end
    end
end
    if (patchNode ==node_k)
        fprintf(2,'failed to find a patch node\n');
        return;
    end
    [commonNodes,ia,ib]=intersect(node(node_k).patched_nh,node(patchNode).nh_merge);
      %find the common nodes and their index in the different maps
    M=size(commonNodes,2);
    for i=1:M
        cNodes(i).NetId=commonNodes(i); %node ID 
        cNodes(i).kId=ia(i);%node index in node_k's local map
        cNodes(i).pId=ib(i);%node index in patch node's local map
    end
    for i=1:M
        Y(i,:)=(node(patchNode).local_network_c(cNodes(i).pId,:))';
        X(i,:)=(node(node_k).patched_network(cNodes(i).kId,:))';
    end
    
%     N1=1;
%     N2=int16(M/3)+1;
%     N3=int16(M*2/3+1);%select three nodes from the common nodes for map transform
%     N2=2;
%     N3=3;
    M1=size(node(patchNode).nh_merge,2);
%     for i=1:M1 %find X1, X2, X3 in patch node's local map for transform
%         if(node(patchNode).nh_merge(i)==commonNodes(N1))
%             X1=(node(patchNode).local_network_c(i,:))';
%         end
%         if(node(patchNode).nh_merge(i)==commonNodes(N2))
%             X2=(node(patchNode).local_network_c(i,:))';
%         end
%         if (node(patchNode).nh_merge(i)==commonNodes(N3))
%             X3=(node(patchNode).local_network_c(i,:))';
%         end
%     end
%     M2=size(node(node_k).patched_nh,2);
%     for i=1:M2 %find Y1, Y2, Y3 in node_k's local map for transform
%         if(node(node_k).patched_nh(i)==commonNodes(N1))
%             Y1=(node(node_k).patched_network(i,:))';
%         end
%         if(node(node_k).patched_nh(i)==commonNodes(N2))
%             Y2=(node(node_k).patched_network(i,:))';
%         end
%         if (node(node_k).patched_nh(i)==commonNodes(N3))
%             Y3=(node(node_k).patched_network(i,:))';
%         end
%     end
%   [Z,C]=mapTransMax(X,Y,M1);
    [d, Z, transform] = procrustes(X, Y);
    C=transform.c;
    for i=1:(M1-size(transform.c,1))
        C=[C;transform.c(1,:)];
    end
    node(patchNode).local_network_patch=transform.b * node(patchNode).local_network_c * transform.T+C;
    X=[];
    Y=[];
    %node(patchNode).local_network_patch=(Z*node(patchNode).local_network_c'+C)';
    %up to now, we've rotated and translated the patchNode's local map to
    %the position of node_k's local map using all the common nodes in these
    %two local maps. Below we need to form a single expanded map/matrix of
    %the patched bigger map
    
    %obtain all the nodes in the resulting patched map
    newPatched_nh=union(node(node_k).patched_nh, node(patchNode).nh_merge);
    for i=1:size(newPatched_nh,2)%build the patched map for node_k
        if(ismember(newPatched_nh(i),commonNodes)) %if the node is in both maps
            for j=1:size(cNodes,2)
                if(newPatched_nh(i)==cNodes(j).NetId)%find which commone node it is
                    newPatched_network(i,:)=(node(node_k).patched_network(cNodes(j).kId,:)+node(patchNode).local_network_patch(cNodes(j).pId,:))/2;
                     break; %take the average value of the position values from both maps
                end
            end
        else
            if(ismember(newPatched_nh(i),node(node_k).patched_nh))%the node was only in node_k's map
                for j=1:size(node(node_k).patched_nh,2)
                    if(newPatched_nh(i)==node(node_k).patched_nh(j))
                        newPatched_network(i,:)=node(node_k).patched_network(j,:);
                        break;
                    end
                end
            end
            if(ismember(newPatched_nh(i),node(patchNode).nh_merge))%the node is only in patchNode's map
                for j=1:size(node(patchNode).nh_merge,2)
                    if(newPatched_nh(i)==node(patchNode).nh_merge(j))
                        newPatched_network(i,:)=node(patchNode).local_network_patch(j,:);
                        break;
                    end %if
                end %for
            end %if
        end %if
    end %for
    node(patchNode).patch=1;
    patchedSet=union(patchedSet,patchNode);
    node(node_k).patched_nh=newPatched_nh;
    node(node_k).patched_network=newPatched_network;
    patchCandi=setdiff(node(node_k).patched_nh,patchedSet);
    P_N=size(patchCandi,2);
    deleteCandi=[];
    for i=1:P_N
%         if ((patchCandi(i)==node_k)|node(patchCandi(i)).D_dist_mean>0.2|(size(node(patchCandi(i)).nh_merge,2)==0))
        if ((patchCandi(i)==node_k)|(size(node(patchCandi(i)).nh_merge,2)==0))
            deleteCandi=union(deleteCandi,patchCandi(i));
            node(patchCandi(i)).patch=1; %will not be able to patch it. so mark it as patched. 
            patchedSet=union(patchedSet,patchCandi(i));
        end
 
        if (option==0) %to improve the patch speed to patch as less nodes as possible in getting the global map
            numberOfNewNodes=size(setdiff(node(patchCandi(i)).nh_merge,node(node_k).patched_nh),2);
            if (numberOfNewNodes==0)
                deleteCandi =union(deleteCandi,patchCandi(i));
                node(patchCandi(i)).patch=1; %will not need to patch it. so mark it as patched. 
                patchedSet=union(patchedSet,patchCandi(i));
            end
        end
    end
    if (size(deleteCandi,2)~=0)
        patchCandi=setdiff(patchCandi,deleteCandi);
    end
    P_N=size(patchCandi,2);
%     if (P_N==0) %don't use this. If P_N==0, there is partition in the
%     network.
%         for i=1:N
%             if(node(i).patch==0)
%                 patchCandi=[patchCandi,i];
%             end
%         end
%     end
    M=3;%minimum number of common nodes needed for patch
    newNodes=0;
    patchNode=node_k;%no node selected for patch
    newPatched_network=[];
    
    %we check the result of this patch
%     local_network=Network(node(node_k).patched_nh(1),:); %get the deployed network values
%     for i=2:size(node(node_k).patched_nh,2)
%         local_network=[local_network;Network(node(node_k).patched_nh(1),:)];
%     end
   % N=size(local_network,1);
   % N1=1;
   % N2=int16(N/3);
   % N3=int16(N*2/3+1);
   % X1=node(node_k).patched_network(N1,:)';
   % X2=node(node_k).patched_network(N2,:)';
   % X3=node(node_k).patched_network(N3,:)';
   % Y1=Network(N1,:)';
   % Y2=Network(N2,:)';
   % Y3=Network(N3,:)';
   % [Z,Cx]= mapTrans(X1,X2,X3,Y1,Y2,Y3,N);
   % C_transform=(Z*node(node_k).patched_network'+Cx)';
%     D_C = sqrt(disteusq(node(node_k).patched_network,node(node_k).patched_network,'x'));
%     D_D=sqrt(disteusq(local_network,local_network,'x'));
%     D_dist_mean = mean((mean(abs(D_C-D_D)))');
    %D_coordinates_mean=mean(abs(C_transform-local_network));
    %D_coordinates_median=median(abs(C_transform-local_network));
    %C_delta=C_transform - local_network;

end %while

T=toc;
node(node_k).map_patchTime=T;
M=size(anchorNodes,2);
N_Map=size(node(node_k).patched_nh,2);
N=size(Network,1);
if (N_Map==N) %we have a fully patched map
    for i=1:M
        Y(i,:)=(node(node_k).patched_network(anchorNodes(i),:))';
        X(i,:)=(Network(anchorNodes(i),:))';
    end
else %we don't have a fully patched map
    for i=1:M
            [ft,loc]=ismember(anchorNodes(i),node(node_k).patched_nh);
            if(ft==0)
                fprintf(2,'Partition in the network. Patch failed\n');
                fprintf(2,'Anchor Node %d not in the patched map\n', anchorNodes(i));
                return;
            end
            Y(i,:)=(node(node_k).patched_network(loc,:))';
            X(i,:)=(Network(anchorNodes(i),:))';
    end
end %if

%    N=size(local_network,1);
%    N1=1;
%    N2=int16(N/3);
%    N3=int16(N*2/3+1);
%    N2=23;
%    N3=48;
%    X1=node(node_k).patched_network(N1,:)';
%    X2=node(node_k).patched_network(N2,:)';
%    X3=node(node_k).patched_network(N3,:)';
%    Y1=Network(N1,:)';
%    Y2=Network(N2,:)';
%    Y3=Network(N3,:)';
%    [Z,Cx]= mapTrans(X1,X2,X3,Y1,Y2,Y3,N);

%[Z,Cx]= mapTransMax(X,Y,N);

% N_Map=size(node(node_k).patched_nh,2);
% N=size(Network,1);
if (N_Map==N) %we have a fully patched map
    [d, Z, transform] = procrustes(X, Y);
    C=transform.c;
    for i=1:(N-size(transform.c,1))
        C=[C;transform.c(1,:)];
    end
    C_transform=transform.b * node(node_k).patched_network * transform.T+C;
    %C_transform=(Z*node(node_k).patched_network'+Cx)';
    node(node_k).patched_network_transform=C_transform;
    D_C = sqrt(disteusq(C_transform,C_transform,'x'));
    D_dist_mean = mean((mean(abs(D_C-D)))');
    D_dist_mean=D_dist_mean/r;
    D_coordinates_mean=mean(abs(C_transform-Network));
    D_coordinates_mean=D_coordinates_mean/r;
    node(node_k).patched_net_dist_error_mean=D_dist_mean;
    node(node_k).patched_net_coordinates_error_mean=D_coordinates_mean;
    D_coordinates_median=median(abs(C_transform-Network));
    D_coordinates_median=D_coordinates_median/r;
    node(node_k).patched_net_coordinates_error_median=D_coordinates_median;
    C_delta=C_transform - Network;
else %Partition in the network. We only have a partly patched map
    fprintf(2,'Partition in the network\n');
    N=N_Map;
    [d, Z, transform] = procrustes(X, Y);
    C=transform.c;
    for i=1:(N-size(transform.c,1))
        C=[C;transform.c(1,:)];
    end
    local_network=Network(node(node_k).patched_nh(1),:); %get the deployed network values
    for i=2:size(node(node_k).patched_nh,2)
        local_network=[local_network;Network(node(node_k).patched_nh(1),:)];
    end
    C_transform=transform.b * node(node_k).patched_network * transform.T+C;
    %C_transform=(Z*node(node_k).patched_network'+Cx)';
    node(node_k).patched_network_transform=C_transform;
    D_C = sqrt(disteusq(C_transform,C_transform,'x'));
    D_D=sqrt(disteusq(local_network,local_network,'x'));
    D_dist_mean = mean((mean(abs(D_C-D_D)))');
    D_dist_mean=D_dist_mean/r;
    D_coordinates_mean=mean(abs(C_transform-local_network));
    D_coordinates_mean=D_coordinates_mean/r;
    node(node_k).patched_net_dist_error_mean=D_dist_mean;
    node(node_k).patched_net_coordinates_error_mean=D_coordinates_mean;
    D_coordinates_median=median(abs(C_transform-local_network));
    D_coordinates_median=D_coordinates_median/r;
    node(node_k).patched_net_coordinates_error_median=D_coordinates_median;
    C_delta=C_transform - local_network;
end
    

