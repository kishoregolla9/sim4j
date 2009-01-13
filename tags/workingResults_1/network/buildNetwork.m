function [network]=buildNetwork(type,width,N,length)
%Li - Oct. 2006, modified April 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function netDeployment generates a network given the number of nodes, the
%width and the type
%network -output coordinates of the nodes deployed
%type - 0/1/2/3/4/5/6/7/8/9/10
%  0:random square
%  1:grid square with 10% average placement errors
%  2:C-shape random
%  3:C-shape grid
%  4:rectangle random
%  5:rectangle grid with 10% placement error (width=width,length=1.3*width)
%  6:L-shape random
%  7:L-shape grid with 10% placement error)
%  8:loop random
%  9:loop grid with 10% placement error
%  10:irregular
%width - edge length of a square area for deployment. e.g., if size=r, then
%  the deployment area is rxr. in the rectangle random, size is the width to
%  length (length is taken as 10 unit) ratio
%N - number of nodes in most cases.
%  In square grid, N=sizexsize;
%  In rectangle grid, Nxsize is the nubmer of nodes where width is the width and N length.
%  In C shape grid, N is about 79 when width=10; in L-shape grid, N is about 51
%length - length of the network, for rectangles (default 25)

  network=struct();
  
  switch type
    case 0  % random
        points=rand(N,2)*width;
        network.shape=sprintf('Random-%.0fx%.0f-Square-with-%.0f-nodes',width,width,N);
        network.points=points;
        network.numberOfNodes=N;
    case 1  % Square Grid 
        if (sqrt(N) ~= width)
            fprintf(2,'Size must be %fx%f=%f!',width,width,N); 
            return;
        end 
        network.shape=sprintf('Grid-%.0fx%.0f-Square-with-%.0f-nodes',width,width,N);
        points=zeros(N,2);
        k=1;
        for i=1:width
            for j=1:width
                x=i+(rand-0.5)*0.4;
                y=j+(rand-0.5)*0.4;
                points(k,1)=x;
                points(k,2)=y;
                k=k+1;
            end
        end
        network.points=points;
        network.numberOfNodes=width*width;        
    case 2 % C-shape random
        network.shape=sprintf('C-Shape-Random-%ix%i',width,width);
        fraction = 0.3;
        network.points=zeros(N,2);
        for j = 1:N
            new_points = rand(1,2);
            while (new_points(1) > fraction) && (new_points(2) > fraction) && ...
                    (new_points(2) < (1- fraction))
                new_points = rand(1,2);
            end
            network.points(j,:) = new_points*width;
        end
        
    case 3  %C-shape grid, N is not used. N is determined by width.
        network.shape=sprintf('C-Shape-Grid-%ix%i',width,width);
        fraction = 0.3;
        index = 1;
        network.points=zeros(N,2);
        for i=1:width
            if (i <= width*fraction)
                for j=1:width
                    network.points(index, 1) = i+(rand-0.5)*0.4;
                    network.points(index, 2) = j+(rand-0.5)*0.4;
                    index = index + 1;
                end
            else
                for j=1:width*fraction
                    network.points(index, 1) = i+(rand-0.5)*0.4;
                    network.points(index, 2) = j+(rand-0.5)*0.4;
                    index = index + 1;
                end
                for j= width*(1-fraction):width
                    network.points(index, 1) = i+(rand-0.5)*0.4;
                    network.points(index, 2) = j+(rand-0.5)*0.4;
                    index = index + 1;
                end
            end
        end
        
    case 4 %rectangle random. width is the width to length ratio.
        network.shape=sprintf('Rectangle-Random-%ix%i',width,length);
        network.points=zeros(N,2);
        for j = 1:N
            new_points = rand(1,2);
            while (new_points(2) > width)
                new_points = rand(1,2);
            end
            network.points(j,:) = new_points*length; 
        end

    case 5 % Rectangle grid with 20% placement error
        network.shape=sprintf('Rectangle-Grid(20\%error)-%ix%i',width,length);       
        deploy_width=width;
        network.points=zeros(deploy_width,2);
        for i=1:deploy_width
            a_fixed=1:N;
            delta =(rand(1,N)-0.5*ones(1,N))*0.4;
            a=a_fixed+delta;
            b_fixed =zeros(1,N);
            delta =(rand(1,N)-0.5*ones(1,N))*0.4;
            b=b_fixed+delta+i;
            network.points=[network; a' b'];
        end

    case 6  %L-shape random
        fraction = 0.3;
        network.shape=sprintf('L-Shape-Random-%ix%i',N,length);                
        network.points=zeros(N,2);
        for j = 1:N
            new_points = rand(1,2);
            while (new_points(1) > fraction) && (new_points(2) > fraction)
                new_points = rand(1,2);
            end
            network.points(j,:) = new_points*width;
        end


    case 7 %In L-shape grid case, we get about 51 nodes
        network.shape=sprintf('L-Shape-Grid-%ix%i',width,length);
        rawNetwork=zeros(N,2);
        network.points=zeros(N,2);
        for i=1:width
            a_fixed=1:width;
            delta =(rand(1,width)-0.5*ones(1,width))*0.4;
            a=a_fixed+delta;
            b_fixed =zeros(1,width);
            delta =(rand(1,width)-0.5*ones(1,width))*0.4;
            b=b_fixed+delta+i;
            rawNetwork=[rawNetwork; a' b'];
        end
        %now we have a square grid. Kick out the ones not in the L-shape
        
        N=width*width;
        fraction=0.32*width;
        jj=1;
        for ii=1:N
            if (rawNetwork(ii,1)>fraction) && (rawNetwork(ii,2)>fraction)
                rawNetwork(ii,:);
            else
                network.points(jj,:)=rawNetwork(ii,:);
                jj=jj+1;
            end
        end

    case 8 %loop random
        network.shape=sprintf('Loop-Random %ix%i',width,length);
        network.points=zeros(N,2);
        fraction = 0.2;
        for j = 1:N
            new_points = rand(1,2);
            while (new_points(1) > fraction) && (new_points(2) > fraction) ... 
                    && (new_points(2) < (1- fraction)) ... 
                    && (new_points(1)<(1- fraction))
                new_points = rand(1,2);
            end
            network.points(j,:) = new_points*width;
        end

    case 9 %In loop grid case, we get about 51-64 nodes. N is not used
        network.shape=sprintf('Loop Grid %ix%i',width,length);
        network.points=zeros(N,2);        
        rawNetwork=[];
        for i=1:width
            a_fixed=1:width;
            delta =(rand(1,width)-0.5*ones(1,width))*0.4;
            a=a_fixed+delta;
            b_fixed =zeros(1,width);
            delta =(rand(1,width)-0.5*ones(1,width))*0.4;
            b=b_fixed+delta+i;
            rawNetwork=[rawNetwork; a' b'];
        end %now we have a square grid. Kick out the ones not to form the perimeter
        N=width*width;
        fraction=0.35*width;
        fraction1=width-(fraction-0.13*width);
        jj=1;
        for ii=1:N
            if (rawNetwork(ii,1)>fraction)&(rawNetwork(ii,2)>fraction)&...
                    (rawNetwork(ii,2) < fraction1)&(rawNetwork(ii,1)<fraction1)
                rawNetwork(ii,:);
            else
                network.points(jj,:)=rawNetwork(ii,:);
                jj=jj+1;
            end
        end

    case 10  % irregular shape
        network.shape=sprintf('Irregular-%ix%i',width,length);
        xdist = sin(pi/3);
        ydist = 1;
        network.points=zeros(N, 2);
        for i=1:width
            if mod(i,2) == 0
                for j=1:width
                    network.points((i-1)*width+j, 1) = i*xdist+randn*0.05;
                    network.points((i-1)*width+j, 2) = j*ydist+randn*0.3;
                end
            else
                for j=1:width
                    network.points((i-1)*width+j, 1) = i*xdist+randn*0.05;
                    network.points((i-1)*width+j, 2) = j*ydist+randn*0.05+0.5;
                end
            end
        end
        
  end
 
end
