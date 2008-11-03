function NetworkConnectivityPlot(Network,r)

%Given a Network and a radius, this function plots the connectivity of the
%network.

D=sqrt(disteusq(Network,Network,'x'));
N=size(Network,1);
for i=1:N
    for j=1:N
        if (D(i,j)<r) Connectivity(i,j)=1;
        else Connectivity(i,j)=0;
        end
    end
end

disconnect=0;
for i=1:N
    for j=1:N
        if D(i,j)<r
            D_hopCount(i,j)=1;
        else
            D_hopCount(i,j)=2*N;
        end
    end
end %get prepared to compute the shortest hop matrix for D

for k=1:N
    D_hopCount = min(D_hopCount,repmat(D_hopCount(:,k),[1 N])+repmat(D_hopCount(k,:),[N 1])); 
end %compute the shortest hop matrix using Floyed algorithm

for i=1:N
    for j=i:N
        if (D_hopCount(i,j)==2*N)
            disconnect=1;
            break;
        end
    end
end

if (disconnect==1)
    fprintf(2,'network not connected\n');
end
            
gplot(Connectivity, Network,'-o');